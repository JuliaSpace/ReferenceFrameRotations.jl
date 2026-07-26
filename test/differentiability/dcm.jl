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
    forwarddiff = getproperty(zygote_ext, :ForwardDiff)
    chainrules = getproperty(zygote_ext, :ChainRulesCore)

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
