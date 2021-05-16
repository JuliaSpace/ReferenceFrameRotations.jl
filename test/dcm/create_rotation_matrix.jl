# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to the function `create_rotation_matrix`.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/dcm.jl
# ==================

# Functions: create_rotation_matrix
# ---------------------------------

@testset "Function create_rotation_matrix" begin
    # Sample an angle to use in all rotations.
    ang = _rand_ang()

    # Rotations
    # =========

    # X Axis
    # ------

    # Create a DCM that rotates about X axis.
    dcm = create_rotation_matrix(ang, :X)

    # Create a vector that does not have X component.
    v = SVector(0, randn(), randn())

    # Rotate the reference using the DCM.
    v_r = dcm * v

    # Get the sine of the angle between the representations.
    sin_ang = ((v_r × v) / norm(v)^2)[1]

    # Test the angle between the two representations.
    @test abs(sin(ang) - sin_ang) ≈ 0 atol = 1e-12

    # Y Axis
    # ------

    # Create a DCM that rotates about Y axis.
    dcm = create_rotation_matrix(ang, :Y)

    # Create a vector that does not have Y component.
    v = SVector(randn(), 0, randn())

    # Rotate the reference using the DCM.
    v_r = dcm * v

    # Get the sine of the angle between the representations.
    sin_ang = ((v_r × v) / norm(v)^2)[2]

    # Test the angle between the two representations.
    @test abs(sin(ang) - sin_ang) ≈ 0 atol = 1e-12

    # Z Axis
    # ------

    # Create a DCM that rotates about Z axis.
    dcm = create_rotation_matrix(ang, :Z)

    # Create a vector that does not have Z component.
    v = SVector(randn(), randn(), 0)

    # Rotate the reference using the DCM.
    v_r = dcm * v

    # Get the sine of the angle between the representations.
    sin_ang = ((v_r × v) / norm(v)^2)[3]

    # Test the angle between the two representations.
    @test abs(sin(ang) - sin_ang) ≈ 0 atol = 1e-12
end
