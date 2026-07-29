## Description #############################################################################
#
# Tests related to conversion from quaternions to Euler angle and axis.
#
############################################################################################

# == File: ./src/conversions/quat_to_angleaxis.jl ==========================================

# -- Functions: quat_to_angleaxis ----------------------------------------------------------

@testset "Quaternion => Euler Angle and Axis" begin
    for T in (Float32, Float64)
        q = Quaternion(cosd(T(75 / 2)), 0, sind(T(75 / 2)), 0)
        av = quat_to_angleaxis(q)
        @test eltype(av) === T
        @test av.a ≈ 75 * pi / 180
        @test av.v ≈ [0, 1, 0]

        q = Quaternion(cosd(T(225 / 2)), 0, sind(T(225 / 2)), 0)
        av = quat_to_angleaxis(q)
        @test eltype(av) === T
        @test av.a ≈ 135 * pi / 180
        @test av.v ≈ [0, -1, 0]
    end
end

@testset "Quaternion => Euler Angle and Axis (generic numeric stability)" begin
    for T in (Int, Rational{Int}, Float32, Float64, BigFloat)
        Tf = float(T)
        qI = Quaternion{T}(one(T), zero(T), zero(T), zero(T))
        av = @inferred quat_to_angleaxis(qI)
        @test av isa EulerAngleAxis{Tf}
        @test av.a == zero(Tf)

        # This unit quaternion and its half-turn are exact in every numeric family.
        q = if T === Int
            Quaternion{T}(zero(T), one(T), one(T), one(T))
        else
            Quaternion{T}(T(1 // 2), T(1 // 2), T(1 // 2), T(1 // 2))
        end
        av = @inferred quat_to_angleaxis(q)
        @test av isa EulerAngleAxis{Tf}
        @test av.a ≈ (T === Int ? Tf(π) : Tf(2) * Tf(π) / Tf(3))
        @test av.v ≈ fill(inv(sqrt(Tf(3))), 3)

        qπ = Quaternion{T}(zero(T), one(T), zero(T), zero(T))
        avπ = @inferred quat_to_angleaxis(qπ)
        @test avπ isa EulerAngleAxis{Tf}
        @test avπ.a ≈ Tf(π)
        @test avπ.v == SVector{3, Tf}(one(Tf), zero(Tf), zero(Tf))
    end

    for T in (Float32, Float64, BigFloat)
        q = Quaternion{T}(prevfloat(one(T)), sqrt(eps(T)), zero(T), zero(T))
        av = @inferred quat_to_angleaxis(q)
        @test av isa EulerAngleAxis{T}
        @test isfinite(av.a)
        @test all(isfinite, av.v)
    end
end

@testset "Quaternion => Euler Angle and Axis (Special Cases)" begin
    for T in (Float32, Float64)
        q = Quaternion{T}(1, 0, 0, 0)
        av = quat_to_angleaxis(q)
        @test eltype(av) == T
        @test av.a == 0
        @test av.v == [0, 0, 0]
    end
end

@testset "Quaternion => Euler Angle and Axis (Small Angles)" begin
    for θ in (1e-6, 1e-8, 1e-12)
        q = Quaternion(cos(θ / 2), sin(θ / 2), 0.0, 0.0)
        av = quat_to_angleaxis(q)

        @test av.a ≈ θ rtol = 1e-12
        @test av.v ≈ [1.0, 0.0, 0.0]
    end
end
