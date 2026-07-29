## Description #############################################################################
#
# Tests related to conversion from direction cosine matrices to Euler angle and axis.
#
############################################################################################

# == File: ./src/conversions/dcm_to_angleaxis.jl ===========================================

# -- Functions: dcm_to_angleaxis -----------------------------------------------------------

@testset "DCM => Euler Angle and Axis" begin
    for T in (Float32, Float64)
        # Create a random DCM.
        D = rand(DCM{T})

        # Convert to Euler angle and axis.
        av = dcm_to_angleaxis(D)
        @test eltype(av) === T

        # Check if the rotation expressed by D is consistent, which is performed in two
        # steps:
        #
        #   1. A vector aligned with `v` does not change.
        #   2. A vector perpendicular to `v` is rotated by `a`.

        v = av.v
        vr = D * v
        @test vr ≈ v
        @test eltype(v) === eltype(vr) === T

        # Auxiliary vector to obtain a vector perpendicular to `v`.
        aux = @SVector randn(T, 3)
        aux = aux / norm(aux)

        vp = av.v × aux
        vp = vp / norm(vp)
        vpr = D * vp
        @test eltype(vp) === eltype(vpr) === T

        # Compute the angle between vp and vpr in [0, 2π].
        a = acos(vp ⋅ vpr)
        @test a ≈ av.a
    end
end

@testset "DCM => Euler Angle and Axis (generic numeric stability)" begin
    for T in (Int, Rational{Int}, Float32, Float64, BigFloat)
        Tf = float(T)
        I₃ = DCM(T[1 0 0; 0 1 0; 0 0 1])
        av = @inferred dcm_to_angleaxis(I₃)
        @test av isa EulerAngleAxis{Tf}
        @test av.a == zero(Tf)

        D = DCM(T[0 1 0; 0 0 1; 1 0 0])
        av = @inferred dcm_to_angleaxis(D)
        @test av isa EulerAngleAxis{Tf}
        @test angleaxis_to_dcm(av) ≈ D atol = 20sqrt(eps(Tf))

        Dπ = DCM(T[1 0 0; 0 -1 0; 0 0 -1])
        avπ = @inferred dcm_to_angleaxis(Dπ)
        @test avπ isa EulerAngleAxis{Tf}
        @test avπ.a ≈ Tf(π)
        @test avπ.v == SVector{3, Tf}(one(Tf), zero(Tf), zero(Tf))
    end

    for T in (Float32, Float64, BigFloat)
        # Roundoff outside the trace bound must not reach sqrt or acos unchecked.
        x = one(T) + eps(T)
        D = DCM(T[x 0 0; 0 -1 0; 0 0 -1])
        av = @inferred dcm_to_angleaxis(D)
        @test av isa EulerAngleAxis{T}
        @test isfinite(av.a)
        @test all(isfinite, av.v)
    end
end

@testset "DCM => Euler Angle and Axis (Special Cases)" begin
    for T in (Float32, Float64)
        D = DCM(T(1) * I)
        av = dcm_to_angleaxis(D)
        @test eltype(av) === T
        @test av.a ≈ 0
        @test av.v ≈ [0, 0, 0]

        # For a half turn, `v` and `-v` describe exactly the same rotation. Hence, the sign
        # of the returned axis is arbitrary and we must compare using its absolute value.
        D = angle_to_dcm(T(π), :X)
        av = dcm_to_angleaxis(D)
        @test eltype(av) === T
        @test av.a ≈ π
        @test abs.(av.v) ≈ [1, 0, 0]
        @test angleaxis_to_dcm(av) ≈ D atol = 10 * eps(T)

        D = angle_to_dcm(T(π), :Y)
        av = dcm_to_angleaxis(D)
        @test eltype(av) === T
        @test av.a ≈ π
        @test abs.(av.v) ≈ [0, 1, 0]
        @test angleaxis_to_dcm(av) ≈ D atol = 10 * eps(T)

        D = angle_to_dcm(T(π), :Z)
        av = dcm_to_angleaxis(D)
        @test eltype(av) === T
        @test av.a ≈ π
        @test abs.(av.v) ≈ [0, 0, 1]
        @test angleaxis_to_dcm(av) ≈ D atol = 10 * eps(T)

        D = angle_to_dcm(T(2π / 3), :X)
        av = dcm_to_angleaxis(D)
        @test eltype(av) === T
        @test av.a ≈ T(2π / 3)
        @test av.v ≈ [1, 0, 0]

        D = angle_to_dcm(T(-2π / 3), :X)
        av = dcm_to_angleaxis(D)
        @test eltype(av) === T
        @test av.a ≈ T(2π / 3)
        @test av.v ≈ [-1, 0, 0]

        D = angle_to_dcm(T(2π / 3), :Y)
        av = dcm_to_angleaxis(D)
        @test eltype(av) === T
        @test av.a ≈ T(2π / 3)
        @test av.v ≈ [0, 1, 0]

        D = angle_to_dcm(T(-2π / 3), :Y)
        av = dcm_to_angleaxis(D)
        @test eltype(av) === T
        @test av.a ≈ T(2π / 3)
        @test av.v ≈ [0, -1, 0]

        D = angle_to_dcm(T(2π / 3), :Z)
        av = dcm_to_angleaxis(D)
        @test eltype(av) === T
        @test av.a ≈ T(2π / 3)
        @test av.v ≈ [0, 0, 1]

        D = angle_to_dcm(T(-2π / 3), :Z)
        av = dcm_to_angleaxis(D)
        @test eltype(av) === T
        @test av.a ≈ T(2π / 3)
        @test av.v ≈ [0, 0, -1]

        D = angle_to_dcm(T(-2π / 3), :Z) * angle_to_dcm(T(-π / 2), :Y)
        av = dcm_to_angleaxis(D)
        @test eltype(av) === T
        @test av.a ≈ 2.4188584057763776
        @test av.v ≈ [0.6546536707079772, -0.37796447300922736, -0.6546536707079772]

        # Half turn about [1, -1, -1] / √3, that is, `D = 2vvᵀ - I`.
        #! format: off
        D = DCM(
            T(-1 / 3), T(-2 / 3), T(-2 / 3),
            T(-2 / 3), T(-1 / 3), T(+2 / 3),
            T(-2 / 3), T(+2 / 3), T(-1 / 3)
        )'
        #! format: on

        av = dcm_to_angleaxis(D)
        @test eltype(av) === T
        @test av.a ≈ T(π)
        @test abs.(av.v) ≈ [T(√3 / 3), T(√3 / 3), T(√3 / 3)]
        @test angleaxis_to_dcm(av) ≈ D atol = 10 * eps(T)
    end
end

@testset "DCM => Euler Angle and Axis (Half Turns With a Zero Component)" begin
    # For `θ = π` the DCM is `2vvᵀ - I`, and the relative sign between two components is only
    # observable through an off-diagonal element that involves both. Hence, we must sweep
    # axes in which each component vanishes in turn.
    axes_180 = (
        SVector(0.0, +1 / √2, -1 / √2),
        SVector(0.0, +1 / √2, +1 / √2),
        SVector(+1 / √2, 0.0, -1 / √2),
        SVector(+1 / √2, 0.0, +1 / √2),
        SVector(+1 / √2, -1 / √2, 0.0),
        SVector(+1 / √2, +1 / √2, 0.0),
        SVector(0.0, 0.6, -0.8),
        SVector(0.0, -0.6, -0.8),
        SVector(-0.8, 0.0, 0.6),
        SVector(0.6, -0.8, 0.0),
    )

    for T in (Float32, Float64)
        for v in axes_180
            vt = SVector{3, T}(v)
            D = DCM(2 * vt * vt' - I)

            av = dcm_to_angleaxis(D)
            @test eltype(av) === T
            @test av.a ≈ T(π) atol = 10 * eps(T)
            @test abs.(av.v) ≈ abs.(vt) atol = 10 * eps(T)
            @test angleaxis_to_dcm(av) ≈ D atol = 100 * eps(T)
        end
    end
end

@testset "DCM => Euler Angle and Axis (Round-Trip Accuracy)" begin
    rng = MersenneTwister(20260729)

    worst = 0.0
    for _ in 1:100_000
        D = rand(rng, DCM)
        av = dcm_to_angleaxis(D)
        worst = max(worst, maximum(abs, angleaxis_to_dcm(av) - D))
    end

    @test worst < 1e-14
end
