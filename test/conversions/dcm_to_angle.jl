## Description #############################################################################
#
# Tests related to conversion from direction cosine matrices to Euler angles.
#
############################################################################################

# == File: ./src/conversions/dcm_to_angle.jl ===============================================

# -- Functions: dcm_to_angle ---------------------------------------------------------------

@testset "DCM => Euler angles" begin
    for T in (Float32, Float64)
        # The conversion is performed by creating DCMs using the tested function
        # `angle_to_dcm`, and then converting to Euler angles.

        # The test set is formed of three rotations angles, the rotation sequence, and the
        # comparison mode. The latter is used for the cases with singularities. In those
        # cases, we need to know if the angles a₁ and a₃ must be summed or subtracted due to
        # the singularity.
        testset = [
            # ZYX
            (_rand_ang(T), _rand_ang2(T), _rand_ang(T), :Z, :Y, :X, :none)
            (_rand_ang(T), +T(π / 2), _rand_ang(T), :Z, :Y, :X, :sub)
            (_rand_ang(T), -T(π / 2), _rand_ang(T), :Z, :Y, :X, :sum)
            # XYX
            (_rand_ang(T), _rand_ang3(T), _rand_ang(T), :X, :Y, :X, :none)
            (_rand_ang(T), T(0), _rand_ang(T), :X, :Y, :X, :sum)
            (_rand_ang(T), +T(π), _rand_ang(T), :X, :Y, :X, :sub)
            (_rand_ang(T), -T(π), _rand_ang(T), :X, :Y, :X, :sub)
            # XYZ
            (_rand_ang(T), _rand_ang2(T), _rand_ang(T), :X, :Y, :Z, :none)
            (_rand_ang(T), +T(π / 2), _rand_ang(T), :X, :Y, :Z, :sum)
            (_rand_ang(T), -T(π / 2), _rand_ang(T), :X, :Y, :Z, :sub)
            # XZX
            (_rand_ang(T), _rand_ang3(T), _rand_ang(T), :X, :Z, :X, :none)
            (_rand_ang(T), T(0), _rand_ang(T), :X, :Z, :X, :sum)
            (_rand_ang(T), +T(π), _rand_ang(T), :X, :Z, :X, :sub)
            (_rand_ang(T), -T(π), _rand_ang(T), :X, :Z, :X, :sub)
            # XZY
            (_rand_ang(T), _rand_ang2(T), _rand_ang(T), :X, :Z, :Y, :none)
            (_rand_ang(T), +T(π / 2), _rand_ang(T), :X, :Z, :Y, :sub)
            (_rand_ang(T), -T(π / 2), _rand_ang(T), :X, :Z, :Y, :sum)
            # YXY
            (_rand_ang(T), _rand_ang3(T), _rand_ang(T), :Y, :X, :Y, :none)
            (_rand_ang(T), T(0), _rand_ang(T), :Y, :X, :Y, :sum)
            (_rand_ang(T), +T(π), _rand_ang(T), :Y, :X, :Y, :sub)
            (_rand_ang(T), -T(π), _rand_ang(T), :Y, :X, :Y, :sub)
            # YXZ
            (_rand_ang(T), _rand_ang2(T), _rand_ang(T), :Y, :X, :Z, :none)
            (_rand_ang(T), +T(π / 2), _rand_ang(T), :Y, :X, :Z, :sub)
            (_rand_ang(T), -T(π / 2), _rand_ang(T), :Y, :X, :Z, :sum)
            # YZX
            (_rand_ang(T), _rand_ang2(T), _rand_ang(T), :Y, :Z, :X, :none)
            (_rand_ang(T), +T(π / 2), _rand_ang(T), :Y, :Z, :X, :sum)
            (_rand_ang(T), -T(π / 2), _rand_ang(T), :Y, :Z, :X, :sub)
            # YZY
            (_rand_ang(T), _rand_ang3(T), _rand_ang(T), :Y, :Z, :Y, :none)
            (_rand_ang(T), T(0), _rand_ang(T), :Y, :Z, :Y, :sum)
            (_rand_ang(T), +T(π), _rand_ang(T), :Y, :Z, :Y, :sub)
            (_rand_ang(T), -T(π), _rand_ang(T), :Y, :Z, :Y, :sub)
            # ZXY
            (_rand_ang(T), _rand_ang2(T), _rand_ang(T), :Z, :X, :Y, :none)
            (_rand_ang(T), +T(π / 2), _rand_ang(T), :Z, :X, :Y, :sum)
            (_rand_ang(T), -T(π / 2), _rand_ang(T), :Z, :X, :Y, :sub)
            # ZXZ
            (_rand_ang(T), _rand_ang3(T), _rand_ang(T), :Z, :X, :Z, :none)
            (_rand_ang(T), T(0), _rand_ang(T), :Z, :X, :Z, :sum)
            (_rand_ang(T), +T(π), _rand_ang(T), :Z, :X, :Z, :sub)
            (_rand_ang(T), -T(π), _rand_ang(T), :Z, :X, :Z, :sub)
            # ZYZ
            (_rand_ang(T), _rand_ang3(T), _rand_ang(T), :Z, :Y, :Z, :none)
            (_rand_ang(T), T(0), _rand_ang(T), :Z, :Y, :Z, :sum)
            (_rand_ang(T), +T(π), _rand_ang(T), :Z, :Y, :Z, :sub)
            (_rand_ang(T), -T(π), _rand_ang(T), :Z, :Y, :Z, :sub)
        ]

        for test in testset
            # Unpack values in tuple.
            a₁, a₂, a₃, r₁, r₂, r₃, c = test

            D = angle_to_dcm(a₃, r₃) * angle_to_dcm(a₂, r₂) * angle_to_dcm(a₁, r₁)

            rot_seq = Symbol(string(r₁) * string(r₂) * string(r₃))
            ea = dcm_to_angle(D, rot_seq)
            @test eltype(ea) === T

            # Check the rotation sequence.
            @test ea.rot_seq == rot_seq

            # Compare the representations considering the singularities.
            if c == :none
                @test ea.a1 ≈ a₁ atol = 50 * eps(T)
                @test ea.a2 ≈ a₂ atol = 50 * eps(T)
                @test ea.a3 ≈ a₃ atol = 50 * eps(T)
            elseif c == :sum
                # Treat the singularity when a₂ is ±π.
                abs(a₂) ≈ π && (a₂ = sign(ea.a2) * π)

                @test ea.a1 ≈ _norm_ang(a₁ + a₃) atol = 50 * eps(T)
                @test ea.a2 ≈ a₂ atol = 50 * eps(T)
                @test ea.a3 ≈ 0 atol = 50 * eps(T)
            elseif c == :sub
                # Treat the singularity when a₂ is ±π.
                abs(a₂) ≈ π && (a₂ = sign(ea.a2) * π)

                @test ea.a1 ≈ _norm_ang(a₁ - a₃) atol = 50 * eps(T)
                @test ea.a2 ≈ a₂ atol = 50 * eps(T)
                @test ea.a3 ≈ 0 atol = 50 * eps(T)
            end
        end
    end
end

@testset "DCM => Euler Angles (errors)" begin
    D = DCM(I)
    @test_throws ArgumentError dcm_to_angle(D, :XXY)
end

@testset "DCM => Euler Angles (Internal Functions)" begin
    for T in (Float32, Float64)
        a = ReferenceFrameRotations._mod_acos(T(1) + eps(T))
        @test a isa T
        @test a == 0

        a = ReferenceFrameRotations._mod_acos(-T(1) - eps(T))
        @test a isa T
        @test a == T(π)

        a = ReferenceFrameRotations._mod_asin(T(1) + eps(T))
        @test a isa T
        @test a == T(π / 2)

        a = ReferenceFrameRotations._mod_asin(-T(1) - eps(T))
        @test a isa T
        @test a == T(-π / 2)
    end
end

@testset "DCM => Euler angles (floating-point boundaries)" begin
    # At a singularity, compare the rotations instead of a particular Euler-angle
    # representation, since the first and third angles are not independently defined.
    for T in (Float32, Float64)
        for rot_seq in (:ZYX, :XYZ, :XZY, :YXZ, :YZX, :ZXY)
            for sign in (-one(T), one(T))
                D = angle_to_dcm(T(0.37), sign * T(π / 2), T(-0.81), rot_seq)
                ea = dcm_to_angle(D, rot_seq)
                @test angle_to_dcm(ea) ≈ D atol = 100 * eps(T)
            end
        end

        # The adjacent representable value below one must remain on the regular
        # side of the inverse trigonometric functions without producing NaN.
        x = prevfloat(one(T))
        D₁ = angle_to_dcm(T(0.37), asin(x), T(-0.81), :ZYX)
        D₂ = angle_to_dcm(T(0.37), acos(x), T(-0.81), :XYX)
        # Inverting a sine/cosine one ULP from ±1 is ill-conditioned: the
        # resulting angle error is O(√eps), so use a scale-aware tolerance.
        atol = 10 * sqrt(eps(T))
        @test angle_to_dcm(dcm_to_angle(D₁, :ZYX)) ≈ D₁ atol = atol
        @test angle_to_dcm(dcm_to_angle(D₂, :XYX)) ≈ D₂ atol = atol

        # One-ULP excursions are clamped by the same private helpers used by
        # singular branches.
        @test isfinite(ReferenceFrameRotations._mod_asin(one(T) + eps(T)))
        @test isfinite(ReferenceFrameRotations._mod_acos(-one(T) - eps(T)))
    end
end

@testset "DCM => Euler angles (near gimbal lock)" begin
    # Its sine lies within eps(Float32) of one, while its cosine is large enough
    # to distinguish it from an exact singularity.
    T = Float32
    a₁, a₂, a₃ = T(-0.86634374), -T(π / 2) + T(0.0004136), T(1.6752636)

    for rot_seq in (:XYZ, :XZY, :YXZ, :YZX, :ZXY, :ZYX)
        ea = dcm_to_angle(angle_to_dcm(a₁, a₂, a₃, rot_seq), rot_seq)
        @test ea.a1 ≈ a₁ atol = 50 * eps(T)
        @test ea.a2 ≈ a₂ atol = 50 * eps(T)
        @test ea.a3 ≈ a₃ atol = 50 * eps(T)
    end

    for a₂ in (T(0.0004136), T(π) - T(0.0004136))
        for rot_seq in (:XYX, :XZX, :YXY, :YZY, :ZXZ, :ZYZ)
            ea = dcm_to_angle(angle_to_dcm(a₁, a₂, a₃, rot_seq), rot_seq)
            @test ea.a1 ≈ a₁ atol = 50 * eps(T)
            @test ea.a2 ≈ a₂ atol = 50 * eps(T)
            @test ea.a3 ≈ a₃ atol = 50 * eps(T)
        end
    end
end

@testset "DCM => Euler angles (generic numeric stability)" begin
    for T in (Int, Rational{Int}, Float32, Float64, BigFloat)
        Tf = float(T)
        I₃ = DCM(T[1 0 0; 0 1 0; 0 0 1])
        ea = @inferred dcm_to_angle(I₃, :ZYX)
        @test ea isa EulerAngles{Tf}
        @test (ea.a1, ea.a2, ea.a3) == (zero(Tf), zero(Tf), zero(Tf))

        # A 120° cyclic permutation is exactly representable by every numeric family.
        D = DCM(T[0 1 0; 0 0 1; 1 0 0])
        ea = @inferred dcm_to_angle(D, :ZYX)
        @test ea isa EulerAngles{Tf}
        @test angle_to_dcm(ea) ≈ D atol = 20sqrt(eps(Tf))

        Dπ = DCM(T[1 0 0; 0 -1 0; 0 0 -1])
        eaπ = @inferred dcm_to_angle(Dπ, :XYX)
        @test eaπ isa EulerAngles{Tf}
        @test angle_to_dcm(eaπ) ≈ Dπ atol = 20sqrt(eps(Tf))
    end

    for T in (Float32, Float64, BigFloat)
        x = one(T) + eps(T)
        D = DCM(T[1 0 -x; 0 1 0; 0 0 1])
        ea = @inferred dcm_to_angle(D, :ZYX)
        @test ea isa EulerAngles{T}
        @test isfinite(ea.a2)
    end
end
