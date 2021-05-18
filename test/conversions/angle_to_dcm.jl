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
        D₁ = create_rotation_matrix(ea.a1, Symbol(rot_seq_str[1]))
        D₂ = create_rotation_matrix(ea.a2, Symbol(rot_seq_str[2]))
        D₃ = create_rotation_matrix(ea.a3, Symbol(rot_seq_str[3]))
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
        D₁ = create_rotation_matrix(ea.a1, Symbol(rot_seq_str[1]))
        D₂ = create_rotation_matrix(ea.a2, Symbol(rot_seq_str[2]))
        D₃ = create_rotation_matrix(ea.a3, Symbol(rot_seq_str[3]))
        De = D₃ * D₂ * D₁

        # Compare.
        @test D ≈ De
    end
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
