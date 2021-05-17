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

@testset "Function create_rotation_matrix (Float64)" begin
    # Sample an angle to use in all rotations.
    ang = _rand_ang()

    # Rotations
    # =========

    # X Axis
    # ------

    # Create a DCM that rotates about X axis.
    dcm = create_rotation_matrix(ang, :X)
    @test eltype(dcm) === Float64

    # Create a vector that does not have X component.
    v = SVector(0, randn(), randn())

    # Rotate the reference using the DCM.
    v_r = dcm * v
    @test eltype(v_r) === Float64

    # Get the sine of the angle between the representations.
    sin_ang = ((v_r × v) / norm(v)^2)[1]

    # Test the angle between the two representations.
    @test abs(sin(ang) - sin_ang) ≈ 0 atol = 1e-12

    # Y Axis
    # ------

    # Create a DCM that rotates about Y axis.
    dcm = create_rotation_matrix(ang, :Y)
    @test eltype(dcm) === Float64

    # Create a vector that does not have Y component.
    v = SVector(randn(), 0, randn())

    # Rotate the reference using the DCM.
    v_r = dcm * v
    @test eltype(v_r) === Float64

    # Get the sine of the angle between the representations.
    sin_ang = ((v_r × v) / norm(v)^2)[2]

    # Test the angle between the two representations.
    @test abs(sin(ang) - sin_ang) ≈ 0 atol = 1e-12

    # Z Axis
    # ------

    # Create a DCM that rotates about Z axis.
    dcm = create_rotation_matrix(ang, :Z)
    @test eltype(dcm) === Float64

    # Create a vector that does not have Z component.
    v = SVector(randn(), randn(), 0)

    # Rotate the reference using the DCM.
    v_r = dcm * v
    @test eltype(v_r) === Float64

    # Get the sine of the angle between the representations.
    sin_ang = ((v_r × v) / norm(v)^2)[3]

    # Test the angle between the two representations.
    @test abs(sin(ang) - sin_ang) ≈ 0 atol = 1e-12
end

@testset "Function create_rotation_matrix (Float32)" begin
    # Sample an angle to use in all rotations.
    ang = _rand_ang(Float32)

    # Rotations
    # =========

    # X Axis
    # ------

    # Create a DCM that rotates about X axis.
    dcm = create_rotation_matrix(ang, :X)
    @test eltype(dcm) === Float32

    # Create a vector that does not have X component.
    v = SVector{3, Float32}(0, randn(), randn())

    # Rotate the reference using the DCM.
    v_r = dcm * v
    @test eltype(v_r) === Float32

    # Get the sine of the angle between the representations.
    sin_ang = ((v_r × v) / norm(v)^2)[1]

    # Test the angle between the two representations.
    @test abs(sin(ang) - sin_ang) ≈ 0 atol = 1e-6

    # Y Axis
    # ------

    # Create a DCM that rotates about Y axis.
    dcm = create_rotation_matrix(ang, :Y)
    @test eltype(dcm) === Float32

    # Create a vector that does not have Y component.
    v = SVector{3, Float32}(randn(), 0, randn())

    # Rotate the reference using the DCM.
    v_r = dcm * v
    @test eltype(v_r) === Float32

    # Get the sine of the angle between the representations.
    sin_ang = ((v_r × v) / norm(v)^2)[2]

    # Test the angle between the two representations.
    @test abs(sin(ang) - sin_ang) ≈ 0 atol = 1e-6

    # Z Axis
    # ------

    # Create a DCM that rotates about Z axis.
    dcm = create_rotation_matrix(ang, :Z)
    @test eltype(dcm) === Float32

    # Create a vector that does not have Z component.
    v = SVector{3, Float32}(randn(), randn(), 0)

    # Rotate the reference using the DCM.
    v_r = dcm * v
    @test eltype(v_r) === Float32

    # Get the sine of the angle between the representations.
    sin_ang = ((v_r × v) / norm(v)^2)[3]

    # Test the angle between the two representations.
    @test abs(sin(ang) - sin_ang) ≈ 0 atol = 1e-6
end

@testset "Function create_rotation_matrix (Errors)" begin
    @test_throws ArgumentError create_rotation_matrix(0, :A)
end
