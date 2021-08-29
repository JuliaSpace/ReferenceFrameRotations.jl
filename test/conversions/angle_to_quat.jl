# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to conversion from Euler angles to quaternion.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/conversions/angle_to_quat.jl
# ========================================

# Functions: angle_to_quat
# ------------------------

@testset "Angle about an axis => Quaternion (Float64)" begin
    # Sample an angle to use in all rotations.
    ang = _rand_ang()

    # Rotations
    # =========

    # X Axis
    # ------

    # Create a quaternion that rotates about X axis.
    q = angle_to_quat(ang, :X)
    @test eltype(q) === Float64

    # Create a vector that does not have X component.
    v = SVector(0, randn(), randn())

    # Rotate the reference using the quaternion.
    v_r = vect(q \ v * q)
    @test eltype(v_r) === Float64

    # Get the sine of the angle between the representations.
    sin_ang = ((v_r × v) / norm(v)^2)[1]

    # Test the angle between the two representations.
    @test abs(sin(ang) - sin_ang) ≈ 0 atol = 1e-12

    # Y Axis
    # ------

    # Create a quaternion that rotates about Y axis.
    q = angle_to_quat(ang, :Y)
    @test eltype(q) === Float64

    # Create a vector that does not have Y component.
    v = SVector(randn(), 0, randn())

    # Rotate the reference using the quaternion.
    v_r = vect(q \ v * q)
    @test eltype(v_r) === Float64

    # Get the sine of the angle between the representations.
    sin_ang = ((v_r × v) / norm(v)^2)[2]

    # Test the angle between the two representations.
    @test abs(sin(ang) - sin_ang) ≈ 0 atol = 1e-12

    # Z Axis
    # ------

    # Create a quaternion that rotates about Z axis.
    q = angle_to_quat(ang, :Z)
    @test eltype(q) === Float64

    # Create a vector that does not have Z component.
    v = SVector(randn(), randn(), 0)

    # Rotate the reference using the quaternion.
    v_r = vect(q \ v * q)
    @test eltype(v_r) === Float64

    # Get the sine of the angle between the representations.
    sin_ang = ((v_r × v) / norm(v)^2)[3]

    # Test the angle between the two representations.
    @test abs(sin(ang) - sin_ang) ≈ 0 atol = 1e-12
end

@testset "Angle about an axis => Quaternion (Float32)" begin
    # Sample an angle to use in all rotations.
    ang = _rand_ang(Float32)

    # Rotations
    # =========

    # X Axis
    # ------

    # Create a quaternion that rotates about X axis.
    q = angle_to_quat(ang, :X)
    @test eltype(q) === Float32

    # Create a vector that does not have X component.
    v = SVector{3, Float32}(0, randn(), randn())

    # Rotate the reference using the quaternion.
    v_r = vect(q \ v * q)
    @test eltype(v_r) === Float32

    # Get the sine of the angle between the representations.
    sin_ang = ((v_r × v) / norm(v)^2)[1]

    # Test the angle between the two representations.
    @test abs(sin(ang) - sin_ang) ≈ 0 atol = 1e-6

    # Y Axis
    # ------

    # Create a quaternion that rotates about Y axis.
    q = angle_to_quat(ang, :Y)
    @test eltype(q) === Float32

    # Create a vector that does not have Y component.
    v = SVector{3, Float32}(randn(), 0, randn())

    # Rotate the reference using the quaternion.
    v_r = vect(q \ v * q)
    @test eltype(v_r) === Float32

    # Get the sine of the angle between the representations.
    sin_ang = ((v_r × v) / norm(v)^2)[2]

    # Test the angle between the two representations.
    @test abs(sin(ang) - sin_ang) ≈ 0 atol = 1e-6

    # Z Axis
    # ------

    # Create a quaternion that rotates about Z axis.
    q = angle_to_quat(ang, :Z)
    @test eltype(q) === Float32

    # Create a vector that does not have Z component.
    v = SVector{3, Float32}(randn(), randn(), 0)

    # Rotate the reference using the quaternion.
    v_r = vect(q \ v * q)
    @test eltype(v_r) === Float32

    # Get the sine of the angle between the representations.
    sin_ang = ((v_r × v) / norm(v)^2)[3]

    # Test the angle between the two representations.
    @test abs(sin(ang) - sin_ang) ≈ 0 atol = 1e-6
end

@testset "Euler angles => Quaternion (Float64)" begin
    T = Float64

    for rot_seq in valid_rot_seqs
        # Sample Euler angles.
        ea = EulerAngles(_rand_ang(T), _rand_ang(T), _rand_ang(T), rot_seq)

        # Convert to quaternion.
        q = angle_to_quat(ea)
        @test eltype(q) === T

        # Create the quaternion by composing the rotations.
        rot_seq_str = string(rot_seq)

        q₁ = angle_to_quat(ea.a1, Symbol(rot_seq_str[1]))
        q₂ = angle_to_quat(ea.a2, Symbol(rot_seq_str[2]))
        q₃ = angle_to_quat(ea.a3, Symbol(rot_seq_str[3]))
        qe = q₁ * q₂ * q₃

        # Make sure q0 is positive.
        (qe.q0 < 0) && (qe = -qe)

        # Compare.
        @test q ≈ qe
    end
end

@testset "Euler angles => Quaternion (Float32)" begin
    T = Float32

    for rot_seq in valid_rot_seqs
        # Sample Euler angles.
        ea = EulerAngles(_rand_ang(T), _rand_ang(T), _rand_ang(T), rot_seq)

        # Convert to quaternion.
        q = angle_to_quat(ea)
        @test eltype(q) === T

        # Create the quaternion by composing the rotations.
        rot_seq_str = string(rot_seq)

        q₁ = angle_to_quat(ea.a1, Symbol(rot_seq_str[1]))
        q₂ = angle_to_quat(ea.a2, Symbol(rot_seq_str[2]))
        q₃ = angle_to_quat(ea.a3, Symbol(rot_seq_str[3]))
        qe = q₁ * q₂ * q₃

        # Make sure q0 is positive.
        (qe.q0 < 0) && (qe = -qe)

        # Compare.
        @test q ≈ qe
    end
end

@testset "Euler angles => Quaternion (Promotion)" begin
    # Check if promotion is working as intended.
    quat = angle_to_quat(Int64(1), 0.0f0, Float64(0))
    @test eltype(quat) === Float64

    quat = angle_to_quat(Int64(1), 0.0f0, 0.0f0)
    @test eltype(quat) === Float32

    quat = angle_to_quat(Int64(1), Int32(0), Float16(0))
    @test eltype(quat) === Float16
end

@testset "Euler angles => Quaternion (Errors)" begin
    @test_throws ArgumentError angle_to_quat(1, 2, 3, :ZZY)
end

# Functions: smallangle_to_quat
# -----------------------------

@testset "Small Euler angles => Quaternion (Float64)" begin
    T = Float64

    # Sample three small angles.
    θx = _rand_ang(T) * T(0.001)
    θy = _rand_ang(T) * T(0.001)
    θz = _rand_ang(T) * T(0.001)

    # Create the quaternion.
    q = smallangle_to_quat(θx, θy, θz)

    # Expected result.
    qe = Quaternion(1, θx / 2, θy / 2, θz / 2)
    qe = qe / norm(qe)

    @test qe ≈ q
end

@testset "Small Euler angles => Quaternion (Float32)" begin
    T = Float32

    # Sample three small angles.
    θx = _rand_ang(T) * T(0.001)
    θy = _rand_ang(T) * T(0.001)
    θz = _rand_ang(T) * T(0.001)

    # Create the quaternion.
    q = smallangle_to_quat(θx, θy, θz)

    # Expected result.
    qe = Quaternion(1, θx / 2, θy / 2, θz / 2)
    qe = qe / norm(qe)

    @test qe ≈ q
end
