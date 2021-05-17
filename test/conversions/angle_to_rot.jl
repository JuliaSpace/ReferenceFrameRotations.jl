# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to the API that converts Euler angles to rotations.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/angle.jl
# ========================

# Functions: angle_to_rot
# -----------------------

@testset "Euler angles => Rotation (Float64)" begin
    T = Float64

    for rot_seq in valid_rot_seqs
        # Sample Euler angles.
        ea = EulerAngles(_rand_ang(T), _rand_ang(T), _rand_ang(T), rot_seq)

        # Convert to DCM and quaternion.
        q1 = angle_to_rot(Quaternion, ea)
        D1 = angle_to_rot(DCM, ea)
        D2 = angle_to_rot(ea)
        @test eltype(q1) === eltype(D1) === eltype(D2) === T

        # Expected values.
        qe = angle_to_quat(ea)
        De = angle_to_dcm(ea)

        @test q1 ≈ qe
        @test D1 ≈ De
        @test D2 ≈ De
    end
end

@testset "Euler angles => Rotation (Float32)" begin
    T = Float32

    for rot_seq in valid_rot_seqs
        # Sample Euler angles.
        ea = EulerAngles(_rand_ang(T), _rand_ang(T), _rand_ang(T), rot_seq)

        # Convert to DCM and quaternion.
        q1 = angle_to_rot(Quaternion, ea)
        D1 = angle_to_rot(DCM, ea)
        D2 = angle_to_rot(ea)
        @test eltype(q1) === eltype(D1) === eltype(D2) === T

        # Expected values.
        qe = angle_to_quat(ea)
        De = angle_to_dcm(ea)

        @test q1 ≈ qe
        @test D1 ≈ De
        @test D2 ≈ De
    end
end

# Functions: smallangle_to_rot
# ----------------------------

@testset "Small Euler angles => Rotation (Float64)" begin
    T = Float64

    # Sample three small angles.
    θx = _rand_ang(T) * T(0.001)
    θy = _rand_ang(T) * T(0.001)
    θz = _rand_ang(T) * T(0.001)

    # Convert to DCM and quaternion.
    q1 = smallangle_to_rot(Quaternion, θx, θy, θz)
    D1 = smallangle_to_rot(DCM, θx, θy, θz; normalize = false)
    D2 = smallangle_to_rot(DCM, θx, θy, θz; normalize = true)
    D3 = smallangle_to_rot(θx, θy, θz; normalize = false)
    D4 = smallangle_to_rot(θx, θy, θz; normalize = true)
    @test eltype(q1) === eltype(D1) === eltype(D2) === T

    # Expected result.
    qe = smallangle_to_quat(θx, θy, θz)
    D1e = smallangle_to_dcm(θx, θy, θz; normalize = false)
    D2e = smallangle_to_dcm(θx, θy, θz; normalize = true)

    @test qe ≈ q1
    @test D1 ≈ D1e
    @test D2 ≈ D2e
    @test D3 ≈ D1e
    @test D4 ≈ D2e
end

@testset "Small Euler angles => Rotation (Float32)" begin
    T = Float32

    # Sample three small angles.
    θx = _rand_ang(T) * T(0.001)
    θy = _rand_ang(T) * T(0.001)
    θz = _rand_ang(T) * T(0.001)

    # Convert to DCM and quaternion.
    q1 = smallangle_to_rot(Quaternion, θx, θy, θz)
    D1 = smallangle_to_rot(DCM, θx, θy, θz; normalize = false)
    D2 = smallangle_to_rot(DCM, θx, θy, θz; normalize = true)
    D3 = smallangle_to_rot(θx, θy, θz; normalize = false)
    D4 = smallangle_to_rot(θx, θy, θz; normalize = true)
    @test eltype(q1) === eltype(D1) === eltype(D2) === T

    # Expected result.
    qe = smallangle_to_quat(θx, θy, θz)
    D1e = smallangle_to_dcm(θx, θy, θz; normalize = false)
    D2e = smallangle_to_dcm(θx, θy, θz; normalize = true)

    @test qe ≈ q1
    @test D1 ≈ D1e
    @test D2 ≈ D2e
    @test D3 ≈ D1e
    @test D4 ≈ D2e
end
