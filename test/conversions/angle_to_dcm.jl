# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to conversion from Euler angles to direction cosine matrices.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/conversions/angle_to_dcm.jl
# =======================================

# Functions: angle_to_dcm
# -----------------------

@testset "Angle about an axis => DCM (Float64)" begin
    # Sample an angle to use in all rotations.
    ang = _rand_ang()

    # Rotations
    # =========

    # X Axis
    # ------

    # Create a DCM that rotates about X axis.
    dcm = angle_to_dcm(ang, :X)
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
    dcm = angle_to_dcm(ang, :Y)
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
    dcm = angle_to_dcm(ang, :Z)
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

@testset "Angle about an axis => DCM (Float32)" begin
    # Sample an angle to use in all rotations.
    ang = _rand_ang(Float32)

    # Rotations
    # =========

    # X Axis
    # ------

    # Create a DCM that rotates about X axis.
    dcm = angle_to_dcm(ang, :X)
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
    dcm = angle_to_dcm(ang, :Y)
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
    dcm = angle_to_dcm(ang, :Z)
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

@testset "Angle about an axis => DCM (Errors)" begin
    @test_throws ArgumentError create_rotation_matrix(0, :A)
end

@testset "Euler angles => DCM (Float64)" begin
    T = Float64

    for rot_seq in valid_rot_seqs
        # Sample Euler angles.
        ea = EulerAngles(_rand_ang(T), _rand_ang(T), _rand_ang(T), rot_seq)

        # Convert to DCM.
        D = angle_to_dcm(ea)
        @test eltype(D) === T

        # Create the DCM by composing the rotations.
        rot_seq_str = string(rot_seq)
        D₁ = angle_to_dcm(ea.a1, Symbol(rot_seq_str[1]))
        D₂ = angle_to_dcm(ea.a2, Symbol(rot_seq_str[2]))
        D₃ = angle_to_dcm(ea.a3, Symbol(rot_seq_str[3]))
        De = D₃ * D₂ * D₁

        # Compare.
        @test D ≈ De
    end
end

@testset "Euler angles => DCM (Float32)" begin
    T = Float32

    for rot_seq in valid_rot_seqs
        # Sample Euler angles.
        ea = EulerAngles(_rand_ang(T), _rand_ang(T), _rand_ang(T), rot_seq)

        # Convert to DCM.
        D = angle_to_dcm(ea)
        @test eltype(D) === T

        # Create the DCM by composing the rotations.
        rot_seq_str = string(rot_seq)
        D₁ = angle_to_dcm(ea.a1, Symbol(rot_seq_str[1]))
        D₂ = angle_to_dcm(ea.a2, Symbol(rot_seq_str[2]))
        D₃ = angle_to_dcm(ea.a3, Symbol(rot_seq_str[3]))
        De = D₃ * D₂ * D₁

        # Compare.
        @test D ≈ De
    end
end

@testset "Euler angles => DCM (Promotion)" begin
    # Check if promotion is working as intended.
    dcm = angle_to_dcm(Int64(1), 0.0f0, Float64(0))
    @test eltype(dcm) === Float64

    dcm = angle_to_dcm(Int64(1), 0.0f0, 0.0f0)
    @test eltype(dcm) === Float32

    dcm = angle_to_dcm(Int64(1), Int32(0), Float16(0))
    @test eltype(dcm) === Float16
end

@testset "Euler angles => DCM (Errors)" begin
    @test_throws ArgumentError angle_to_dcm(1, 2, 3, :ZZY)
end

# Functions: smallangle_to_dcm
# ----------------------------

@testset "Small Euler angles => DCM (Float64)" begin
    T = Float64

    # Sample three small angles.
    θx = _rand_ang(T) * T(0.001)
    θy = _rand_ang(T) * T(0.001)
    θz = _rand_ang(T) * T(0.001)

    # Create the rotation matrix without normalization.
    D = smallangle_to_rot(θx, θy, θz, normalize = false)
    @test eltype(D) === T

    # Expected result.
    De = DCM(
          1, +θz, -θy,
        -θz,   1, +θx,
        +θy, -θx,   1
    )'

    @test De ≈ D

    # Create the rotation matrix with normalization.
    D = smallangle_to_rot(θx, θy, θz, normalize = true)
    @test eltype(D) === T

    @test orthonormalize(De) ≈ D
end

@testset "Small Euler angles => DCM (Float32)" begin
    T = Float32

    # Sample three small angles.
    θx = _rand_ang(T) * T(0.001)
    θy = _rand_ang(T) * T(0.001)
    θz = _rand_ang(T) * T(0.001)

    # Create the rotation matrix without normalization.
    D = smallangle_to_rot(θx, θy, θz, normalize = false)
    @test eltype(D) === T

    # Expected result.
    De = DCM(
          1, +θz, -θy,
        -θz,   1, +θx,
        +θy, -θx,   1
    )'

    @test De ≈ D

    # Create the rotation matrix with normalization.
    D = smallangle_to_rot(θx, θy, θz, normalize = true)
    @test eltype(D) === T

    @test orthonormalize(De) ≈ D
end
