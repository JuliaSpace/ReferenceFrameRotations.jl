## Desription ##############################################################################
#
# Tests related to conversion from Euler angles to direction cosine matrices.
#
############################################################################################

# == File: ./src/conversions/angle_to_dcm.jl ===============================================

# -- Functions: angle_to_dcm ---------------------------------------------------------------

@testset "Angle about an axis => DCM" begin
    for T in (Float32, Float64)
        # Sample an angle to use in all rotations.
        ang = _rand_ang(T)

        # == Rotations =====================================================================

        # -- X Axis ------------------------------------------------------------------------

        # Create a DCM that rotates about X axis.
        dcm = angle_to_dcm(ang, :X)
        @test eltype(dcm) === T

        # Create a vector that does not have X component.
        v = SVector(0, randn(T), randn(T))

        # Rotate the reference using the DCM.
        v_r = dcm * v
        @test eltype(v_r) === T

        # Get the sine of the angle between the representations.
        sin_ang = ((v_r × v) / norm(v)^2)[1]

        # Test the angle between the two representations.
        @test abs(sin(ang) - sin_ang) ≈ 0 atol = √(eps(T))

        # -- Y Axis ------------------------------------------------------------------------

        # Create a DCM that rotates about Y axis.
        dcm = angle_to_dcm(ang, :Y)
        @test eltype(dcm) === T

        # Create a vector that does not have Y component.
        v = SVector(randn(T), 0, randn(T))

        # Rotate the reference using the DCM.
        v_r = dcm * v
        @test eltype(v_r) === T

        # Get the sine of the angle between the representations.
        sin_ang = ((v_r × v) / norm(v)^2)[2]

        # Test the angle between the two representations.
        @test abs(sin(ang) - sin_ang) ≈ 0 atol = √(eps(T))

        # -- Z Axis ------------------------------------------------------------------------

        # Create a DCM that rotates about Z axis.
        dcm = angle_to_dcm(ang, :Z)
        @test eltype(dcm) === T

        # Create a vector that does not have Z component.
        v = SVector(randn(T), randn(T), 0)

        # Rotate the reference using the DCM.
        v_r = dcm * v
        @test eltype(v_r) === T

        # Get the sine of the angle between the representations.
        sin_ang = ((v_r × v) / norm(v)^2)[3]

        # Test the angle between the two representations.
        @test abs(sin(ang) - sin_ang) ≈ 0 atol = √(eps(T))
    end
end

@testset "Angle About an Axis => DCM (Errors)" begin
    @test_throws ArgumentError angle_to_dcm(0, :A)
end

@testset "Euler angles => DCM" begin
    for T in (Float32, Float64)
        # == Two rotations =================================================================

        for rot_seq in valid_rot_seqs_2angles
            # Sample Euler angles.
            θ₁ = _rand_ang(T)
            θ₂ = _rand_ang(T)

            # Convert to DCM.
            D = angle_to_dcm(θ₁, θ₂, rot_seq)
            @test eltype(D) === T

            # Create the DCM by composing the rotations.
            rot_seq_str = string(rot_seq)
            D₁ = angle_to_dcm(θ₁, Symbol(rot_seq_str[1]))
            D₂ = angle_to_dcm(θ₂, Symbol(rot_seq_str[2]))
            De = D₂ * D₁

            # Compare.
            @test D ≈ De
        end

        # == Three rotations ===============================================================

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
end

@testset "Euler Angles => DCM (Promotion)" begin
    # Check if promotion is working as intended.
    dcm = angle_to_dcm(Int64(1), 0.0f0, Float64(0))
    @test eltype(dcm) === Float64

    dcm = angle_to_dcm(Int64(1), 0.0f0, 0.0f0)
    @test eltype(dcm) === Float32

    dcm = angle_to_dcm(Int64(1), Int32(0), Float16(0))
    @test eltype(dcm) === Float16
end

@testset "Euler Angles => DCM (Errors)" begin
    @test_throws ArgumentError angle_to_dcm(1, :V)
    @test_throws ArgumentError angle_to_dcm(1, 2, :ZZ)
    @test_throws ArgumentError angle_to_dcm(1, 2, 3, :ZZY)
end

# -- Functions: smallangle_to_dcm ----------------------------------------------------------

@testset "Small Euler Angles => DCM" begin
    for T in (Float32, Float64)
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
end

@testset "Small Euler Angles => DCM (Promotion)" begin
    # Check if promotion is working as intended.
    dcm = smallangle_to_dcm(Int64(1), 0.0f0, Float64(0))
    @test eltype(dcm) === Float64

    dcm = smallangle_to_dcm(Int64(1), 0.0f0, 0.0f0)
    @test eltype(dcm) === Float32

    dcm = smallangle_to_dcm(Int64(1), Int32(0), Float16(0))
    @test eltype(dcm) === Float16
end
