# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to conversion from quaternions to direction cosine matrices.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/conversions/quaternion_to_dcm.jl
# ============================================

# Functions: quat_to_dcm
# ----------------------

@testset "Quaternion => DCM" begin
    for T in (Float32, Float64)
        # Create a random quaternion.
        q = rand(Quaternion{T})

        # Convert to quaternion and test the conversion.
        D = quat_to_dcm(q)
        @test eltype(D) === T

        q0 = q.q0
        q1 = q.q1
        q2 = q.q2
        q3 = q.q3

        @test D[1, 1] ≈ q0^2 + q1^2 - q2^2 - q3^2
        @test D[1, 2] ≈ 2(q1 * q2 + q0 * q3)
        @test D[1, 3] ≈ 2(q1 * q3 - q0 * q2)
        @test D[2, 1] ≈ 2(q1 * q2 - q0 * q3)
        @test D[2, 2] ≈ q0^2 - q1^2 + q2^2 - q3^2
        @test D[2, 3] ≈ 2(q2 * q3 + q0 * q1)
        @test D[3, 1] ≈ 2(q1 * q3 + q0 * q2)
        @test D[3, 2] ≈ 2(q2 * q3 - q0 * q1)
        @test D[3, 3] ≈ q0^2 - q1^2 - q2^2 + q3^2
    end
end
