## Description #############################################################################
#
# Test Functions for DCM Zygote Extension.
#
############################################################################################

@testset "Test DCM Zygote Differentiation" begin
    data = [
        0.9071183,
        -0.38511035,
        0.1697833,
        -0.18077055,
        0.0077917147,
        0.98349446,
        -0.38007677,
        -0.9228377,
        -0.06254859,
    ]

    f, ad = value_and_jacobian(DCM, AutoZygote(), data)

    expected_f = DCM(data)
    expected_jac = I(9)

    @test f == expected_f
    @test ad == expected_jac

    data_tuple = (data...,)

    ad_jac = reduce(hcat, Zygote.jacobian(DCM, data_tuple...))

    @test ad_jac == expected_jac

    f_fd, df_fd = value_and_jacobian((x) -> orthonormalize(DCM(x)), AutoFiniteDiff(), data)
    f_ad, df_ad = value_and_jacobian((x) -> orthonormalize(DCM(x)), AutoZygote(), data)

    @test f_ad ≈ f_fd
    @test df_ad ≈ df_fd

    regular_dcm = angle_to_dcm(0.31, -0.27, 0.43, :ZYX)
    regular_data = collect(Tuple(regular_dcm))
    zygote_ext = Base.get_extension(
        ReferenceFrameRotations, :ReferenceFrameRotationsZygoteExt
    )
    chainrules = getproperty(zygote_ext, :ChainRulesCore)
    forwarddiff = Base.root_module(
        Base.PkgId(Base.UUID("f6369f11-7733-5829-9624-2563aa707210"), "ForwardDiff")
    )

    dcm64 = angle_to_dcm(0.4, :X)
    cast_dcm32, cast_pullback = chainrules.rrule(
        ReferenceFrameRotations._cast_dcm, DCM{Float32}, dcm64
    )
    @test cast_dcm32 === convert(DCM{Float32}, dcm64)

    zero_tangent = chainrules.ZeroTangent()
    zero_pullback = cast_pullback(zero_tangent)
    @test zero_pullback[1] isa chainrules.NoTangent
    @test zero_pullback[2] isa chainrules.NoTangent
    @test zero_pullback[3] === zero_tangent

    cotangent32 = DCM{Float32}(ntuple(Float32, 9))
    thunked_cotangent = chainrules.Thunk(() -> cotangent32)
    ordinary_pullback = cast_pullback(thunked_cotangent)
    @test ordinary_pullback[1] isa chainrules.NoTangent
    @test ordinary_pullback[2] isa chainrules.NoTangent
    @test ordinary_pullback[3] isa DCM{Float64}
    @test ordinary_pullback[3] == DCM{Float64}(Tuple(cotangent32))

    for T in (Float32, Float64)
        rng = MersenneTwister(2026)
        random_dcm = DCM(rand(rng, T, 3, 3) + I)
        δ = T(1e-3)
        e₁ = @SVector T[1, 0.2, -0.1]
        near_dcm = DCM(
            hcat(e₁, e₁ + δ * @SVector(T[0.1, 1, 0.2]), e₁ + δ * @SVector(T[0.2, 0.1, 1]))
        )
        cotangent = DCM(ntuple(i -> T(i) / T(10), 9))

        for dcm in (random_dcm, near_dcm)
            primal, pullback = chainrules.rrule(orthonormalize, dcm)
            @test primal === orthonormalize(dcm)

            zero_tangent = chainrules.ZeroTangent()
            zero_result = pullback(zero_tangent)
            @test zero_result[1] isa chainrules.NoTangent
            @test zero_result[2] === zero_tangent

            dcm_result = pullback(chainrules.Thunk(() -> cotangent))
            matrix_result = pullback(chainrules.Thunk(() -> Matrix(cotangent)))
            @test dcm_result[1] isa chainrules.NoTangent
            @test dcm_result[2] isa DCM{T}
            @test matrix_result[2] isa DCM{T}

            dcm_data = collect(Tuple(dcm))
            jacobian = forwarddiff.jacobian(x -> collect(orthonormalize(DCM(x))), dcm_data)
            forwarddiff_vjp = DCM{T}(Tuple(jacobian' * collect(Tuple(cotangent))))
            is_near = dcm === near_dcm
            vjp_rtol = is_near ? 100sqrt(eps(T)) : 100eps(T)
            vjp_atol = 1000eps(T)
            @test dcm_result[2] ≈ forwarddiff_vjp rtol = vjp_rtol atol = vjp_atol
            @test matrix_result[2] ≈ forwarddiff_vjp rtol = vjp_rtol atol = vjp_atol

            objective(d) = sum(cotangent .* orthonormalize(d))
            zygote_vjp = Zygote.gradient(objective, dcm)[1]
            @test zygote_vjp isa DCM{T}
            @test zygote_vjp ≈ dcm_result[2] rtol = 100eps(T)

            h = if T === Float32
                is_near ? T(1e-5) : T(1e-3)
            else
                is_near ? T(1e-7) : T(1e-6)
            end
            finite_vjp = similar(dcm_data)
            for i in eachindex(dcm_data)
                x₊ = copy(dcm_data)
                x₋ = copy(dcm_data)
                x₊[i] += h
                x₋[i] -= h
                finite_vjp[i] = (objective(DCM(x₊)) - objective(DCM(x₋))) / (2h)
            end
            finite_dcm = DCM{T}(Tuple(finite_vjp))
            finite_rtol = is_near ? T(0.08) : T(0.01)
            @test dcm_result[2] ≈ finite_dcm rtol = finite_rtol atol = finite_rtol
        end
    end

    scalar_conversions = (
        x -> dcm_to_quat(DCM(x)).q1,
        x -> dcm_to_angleaxis(DCM(x)).a,
        x -> dcm_to_angle(DCM(x), :ZYX).a1,
    )

    for scalar_conversion in scalar_conversions
        dz = Zygote.gradient(scalar_conversion, regular_data)[1]
        df = forwarddiff.gradient(scalar_conversion, regular_data)
        @test dz ≈ df rtol = 100eps(Float64) atol = 100eps(Float64)
    end

    for (source_T, target_T) in ((Float64, Float32), (Float32, Float64))
        x = source_T(0.4)
        conversion_sum(x) = sum(convert(DCM{target_T}, angle_to_dcm(x, :X)))
        dz = Zygote.gradient(conversion_sum, x)[1]
        expected = -target_T(2) * sin(target_T(x))

        @test dz !== nothing
        @test dz ≈ expected rtol = 10sqrt(eps(target_T))
    end
end
