# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to the operations with Euler angles.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/angle.jl
# ====================

# Functions: *
# ------------

@testset "Operations with Euler angles: *"  begin
    # We do not need comprehensive test here. `*` first converts the Euler
    # angles to quaternions, and then it performs the multiplication. At the
    # end, it converts the quaternion back to Euler angles.

    for T in (Float32, Float64)
        ea1 = EulerAngles(deg2rad(T(45)), 0, 0, :ZYX)
        ea2 = EulerAngles(0, deg2rad(T(15)), 0, :YZY)
        ea3 = ea2 * ea1
        @test eltype(ea3) === T
        @test ea3.a1 ≈ T(0)
        @test ea3.a2 ≈ deg2rad(T(60))
        @test ea3.a3 ≈ T(0)
        @test ea3.rot_seq == :YZY
    end
end
