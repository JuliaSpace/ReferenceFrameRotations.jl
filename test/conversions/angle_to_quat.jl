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

        q₁ = if rot_seq_str[1] == 'X'
            Quaternion(cos(ea.a1 / 2), T[1, 0, 0] * sin(ea.a1 / 2))
        elseif rot_seq_str[1] == 'Y'
            Quaternion(cos(ea.a1 / 2), T[0, 1, 0] * sin(ea.a1 / 2))
        elseif rot_seq_str[1] == 'Z'
            Quaternion(cos(ea.a1 / 2), T[0, 0, 1] * sin(ea.a1 / 2))
        end

        q₂ = if rot_seq_str[2] == 'X'
            Quaternion(cos(ea.a2 / 2), T[1, 0, 0] * sin(ea.a2 / 2))
        elseif rot_seq_str[2] == 'Y'
            Quaternion(cos(ea.a2 / 2), T[0, 1, 0] * sin(ea.a2 / 2))
        elseif rot_seq_str[2] == 'Z'
            Quaternion(cos(ea.a2 / 2), T[0, 0, 1] * sin(ea.a2 / 2))
        end

        q₃ = if rot_seq_str[3] == 'X'
            Quaternion(cos(ea.a3 / 2), T[1, 0, 0] * sin(ea.a3 / 2))
        elseif rot_seq_str[3] == 'Y'
            Quaternion(cos(ea.a3 / 2), T[0, 1, 0] * sin(ea.a3 / 2))
        elseif rot_seq_str[3] == 'Z'
            Quaternion(cos(ea.a3 / 2), T[0, 0, 1] * sin(ea.a3 / 2))
        end
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

        q₁ = if rot_seq_str[1] == 'X'
            Quaternion(cos(ea.a1 / 2), T[1, 0, 0] * sin(ea.a1 / 2))
        elseif rot_seq_str[1] == 'Y'
            Quaternion(cos(ea.a1 / 2), T[0, 1, 0] * sin(ea.a1 / 2))
        elseif rot_seq_str[1] == 'Z'
            Quaternion(cos(ea.a1 / 2), T[0, 0, 1] * sin(ea.a1 / 2))
        end

        q₂ = if rot_seq_str[2] == 'X'
            Quaternion(cos(ea.a2 / 2), T[1, 0, 0] * sin(ea.a2 / 2))
        elseif rot_seq_str[2] == 'Y'
            Quaternion(cos(ea.a2 / 2), T[0, 1, 0] * sin(ea.a2 / 2))
        elseif rot_seq_str[2] == 'Z'
            Quaternion(cos(ea.a2 / 2), T[0, 0, 1] * sin(ea.a2 / 2))
        end

        q₃ = if rot_seq_str[3] == 'X'
            Quaternion(cos(ea.a3 / 2), T[1, 0, 0] * sin(ea.a3 / 2))
        elseif rot_seq_str[3] == 'Y'
            Quaternion(cos(ea.a3 / 2), T[0, 1, 0] * sin(ea.a3 / 2))
        elseif rot_seq_str[3] == 'Z'
            Quaternion(cos(ea.a3 / 2), T[0, 0, 1] * sin(ea.a3 / 2))
        end
        qe = q₁ * q₂ * q₃

        # Make sure q0 is positive.
        (qe.q0 < 0) && (qe = -qe)

        # Compare.
        @test q ≈ qe
    end
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
