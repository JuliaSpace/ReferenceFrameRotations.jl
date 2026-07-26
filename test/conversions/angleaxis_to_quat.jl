## Description #############################################################################
#
# Tests related to conversion from Euler angle and axis to quaternion.
#
############################################################################################

# == File: ./src/conversions/angleaxis_to_quat.jl ==========================================

# -- Functions: angleaxis_to_quat ----------------------------------------------------------

@testset "Euler Angle and Axis => Quaternion" begin
    for T in (Float32, Float64)
        # Sample a random Euler angle and axis.
        v = @SVector randn(T, 3)
        v = v / norm(v)
        a = _rand_ang(T)
        av = EulerAngleAxis(a, v)
        q = angleaxis_to_quat(av)
        s = (cos(a / 2) < 0) ? -1 : 1
        @test eltype(q) === T
        @test q.q0 ≈ s * cos(a / 2)
        @test q.q1 ≈ v[1] * sin(a / 2)
        @test q.q2 ≈ v[2] * sin(a / 2)
        @test q.q3 ≈ v[3] * sin(a / 2)
    end

    @testset "Input containers and promotion" begin
        for T in (Float32, Float64)
            a = T(0.7)
            axis = T[1, 2, 3] / sqrt(T(14))
            expected = angleaxis_to_quat(a, SVector{3,T}(axis))

            @test @inferred(angleaxis_to_quat(a, axis)) ≈ expected
            @test @inferred(angleaxis_to_quat(a, @view(axis[1:3]))) ≈ expected
            @test @inferred(angleaxis_to_quat(a, SVector{3,T}(axis))) ≈ expected
            @test angleaxis_to_quat(a, axis) isa Quaternion{T}
        end

        mixed = angleaxis_to_quat(Float32(0.7), Float64[1, 0, 0])
        @test mixed isa Quaternion{Float64}
        @test mixed ≈
              angleaxis_to_quat(Float64(Float32(0.7)), @SVector [1.0, 0.0, 0.0])

        @test_throws ArgumentError angleaxis_to_quat(0.1, [1.0, 0.0])
        @test_throws ArgumentError angleaxis_to_quat(0.1, [1.0, 0.0, 0.0, 0.0])
    end

    @testset "Dynamic vector allocations" begin
        axis = [1.0, 0.0, 0.0]
        angleaxis_to_quat(0.7, axis)
        @test @allocated(angleaxis_to_quat(0.7, axis)) == 0
    end
end
