# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to conversion from direction cosine matrices to Euler angles.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/conversions/dcm_to_angle.jl
# =======================================

# Functions: dcm_to_angle
# -----------------------

@testset "DCM => Euler angles (Float64)" begin
    T = Float64

    # The conversion is performed by creating DCMs using the tested function
    # `create_rotation_matrix`, and then converting to Euler angles.

    # The test set is formed of three rotations angles, the rotation sequence,
    # and the comparison mode. The latter is used for the cases with
    # singularities. In those cases, we need to know if the angles a₁ and a₃
    # must be summed or subtracted due to the singularity.
    testset = [
        # ZYX
        (_rand_ang(), _rand_ang2(), _rand_ang(), :Z, :Y, :X, :none)
        (_rand_ang(), +π / 2      , _rand_ang(), :Z, :Y, :X, :sub)
        (_rand_ang(), -π / 2      , _rand_ang(), :Z, :Y, :X, :sum)
        # XYX
        (_rand_ang(), _rand_ang3(), _rand_ang(), :X, :Y, :X, :none)
        (_rand_ang(), 0           , _rand_ang(), :X, :Y, :X, :sum)
        (_rand_ang(), +π          , _rand_ang(), :X, :Y, :X, :sub)
        (_rand_ang(), -π          , _rand_ang(), :X, :Y, :X, :sub)
        # XYZ
        (_rand_ang(), _rand_ang2(), _rand_ang(), :X, :Y, :Z, :none)
        (_rand_ang(), +π / 2      , _rand_ang(), :X, :Y, :Z, :sum)
        (_rand_ang(), -π / 2      , _rand_ang(), :X, :Y, :Z, :sub)
        # XZX
        (_rand_ang(), _rand_ang3(), _rand_ang(), :X, :Z, :X, :none)
        (_rand_ang(), 0           , _rand_ang(), :X, :Z, :X, :sum)
        (_rand_ang(), +π          , _rand_ang(), :X, :Z, :X, :sub)
        (_rand_ang(), -π          , _rand_ang(), :X, :Z, :X, :sub)
        # XZY
        (_rand_ang(), _rand_ang2(), _rand_ang(), :X, :Z, :Y, :none)
        (_rand_ang(), +π / 2      , _rand_ang(), :X, :Z, :Y, :sub)
        (_rand_ang(), -π / 2      , _rand_ang(), :X, :Z, :Y, :sum)
        # YXY
        (_rand_ang(), _rand_ang3(), _rand_ang(), :Y, :X, :Y, :none)
        (_rand_ang(), 0           , _rand_ang(), :Y, :X, :Y, :sum)
        (_rand_ang(), +π          , _rand_ang(), :Y, :X, :Y, :sub)
        (_rand_ang(), -π          , _rand_ang(), :Y, :X, :Y, :sub)
        # YXZ
        (_rand_ang(), _rand_ang2(), _rand_ang(), :Y, :X, :Z, :none)
        (_rand_ang(), +π / 2      , _rand_ang(), :Y, :X, :Z, :sub)
        (_rand_ang(), -π / 2      , _rand_ang(), :Y, :X, :Z, :sum)
        # YZX
        (_rand_ang(), _rand_ang2(), _rand_ang(), :Y, :Z, :X, :none)
        (_rand_ang(), +π / 2      , _rand_ang(), :Y, :Z, :X, :sum)
        (_rand_ang(), -π / 2      , _rand_ang(), :Y, :Z, :X, :sub)
        # YZY
        (_rand_ang(), _rand_ang3(), _rand_ang(), :Y, :Z, :Y, :none)
        (_rand_ang(), 0           , _rand_ang(), :Y, :Z, :Y, :sum)
        (_rand_ang(), +π          , _rand_ang(), :Y, :Z, :Y, :sub)
        (_rand_ang(), -π          , _rand_ang(), :Y, :Z, :Y, :sub)
        # ZXY
        (_rand_ang(), _rand_ang2(), _rand_ang(), :Z, :X, :Y, :none)
        (_rand_ang(), +π / 2      , _rand_ang(), :Z, :X, :Y, :sum)
        (_rand_ang(), -π / 2      , _rand_ang(), :Z, :X, :Y, :sub)
        # ZXZ
        (_rand_ang(), _rand_ang3(), _rand_ang(), :Z, :X, :Z, :none)
        (_rand_ang(), 0           , _rand_ang(), :Z, :X, :Z, :sum)
        (_rand_ang(), +π          , _rand_ang(), :Z, :X, :Z, :sub)
        (_rand_ang(), -π          , _rand_ang(), :Z, :X, :Z, :sub)
        # ZYZ
        (_rand_ang(), _rand_ang3(), _rand_ang(), :Z, :Y, :Z, :none)
        (_rand_ang(), 0           , _rand_ang(), :Z, :Y, :Z, :sum)
        (_rand_ang(), +π          , _rand_ang(), :Z, :Y, :Z, :sub)
        (_rand_ang(), -π          , _rand_ang(), :Z, :Y, :Z, :sub)
    ]

    for test in testset
        # Unpack values in tuple.
        a₁, a₂, a₃, r₁, r₂, r₃, c = test

        D = create_rotation_matrix(a₃, r₃) *
            create_rotation_matrix(a₂, r₂) *
            create_rotation_matrix(a₁, r₁)

        rot_seq = Symbol(string(r₁) * string(r₂) * string(r₃))
        ea = dcm_to_angle(D, rot_seq)
        @test eltype(ea) === T

        # Check the rotation sequence.
        @test ea.rot_seq == rot_seq

        # Compare the representations considering the singularities.
        if c == :none
            @test ea.a1 ≈ a₁
            @test ea.a2 ≈ a₂
            @test ea.a3 ≈ a₃
        elseif c == :sum
            # Treat the singularity when a₂ is ±π.
            abs(a₂) ≈ π && (a₂ = sign(ea.a2) * π)

            @test ea.a1 ≈ _norm_ang(a₁ + a₃)
            @test ea.a2 ≈ a₂
            @test ea.a3 ≈ 0
        elseif c == :sub
            # Treat the singularity when a₂ is ±π.
            abs(a₂) ≈ π && (a₂ = sign(ea.a2) * π)

            @test ea.a1 ≈ _norm_ang(a₁ - a₃)
            @test ea.a2 ≈ a₂
            @test ea.a3 ≈ 0
        end
    end
end

@testset "DCM => Euler angles (Float32)" begin
    T = Float32

    # The conversion is performed by creating DCMs using the tested function
    # `create_rotation_matrix`, and then converting to Euler angles.

    # The test set is formed of three rotations angles, the rotation sequence,
    # and the comparison mode. The latter is used for the cases with
    # singularities. In those cases, we need to know if the angles a₁ and a₃
    # must be summed or subtracted due to the singularity.
    testset = [
        # ZYX
        (_rand_ang(T), _rand_ang2(T), _rand_ang(T), :Z, :Y, :X, :none)
        (_rand_ang(T), T(+π / 2)    , _rand_ang(T), :Z, :Y, :X, :sub)
        (_rand_ang(T), T(-π / 2)    , _rand_ang(T), :Z, :Y, :X, :sum)
        # XYX
        (_rand_ang(T), _rand_ang3(T), _rand_ang(T), :X, :Y, :X, :none)
        (_rand_ang(T), T(0)         , _rand_ang(T), :X, :Y, :X, :sum)
        (_rand_ang(T), T(+π)        , _rand_ang(T), :X, :Y, :X, :sub)
        (_rand_ang(T), T(-π)        , _rand_ang(T), :X, :Y, :X, :sub)
        # XYZ
        (_rand_ang(T), _rand_ang2(T), _rand_ang(T), :X, :Y, :Z, :none)
        (_rand_ang(T), T(+π / 2)    , _rand_ang(T), :X, :Y, :Z, :sum)
        (_rand_ang(T), T(-π / 2)    , _rand_ang(T), :X, :Y, :Z, :sub)
        # XZX
        (_rand_ang(T), _rand_ang3(T), _rand_ang(T), :X, :Z, :X, :none)
        (_rand_ang(T), T(0)         , _rand_ang(T), :X, :Z, :X, :sum)
        (_rand_ang(T), T(+π)        , _rand_ang(T), :X, :Z, :X, :sub)
        (_rand_ang(T), T(-π)        , _rand_ang(T), :X, :Z, :X, :sub)
        # YXY
        (_rand_ang(T), _rand_ang3(T), _rand_ang(T), :Y, :X, :Y, :none)
        (_rand_ang(T), T(0)         , _rand_ang(T), :Y, :X, :Y, :sum)
        (_rand_ang(T), T(+π)        , _rand_ang(T), :Y, :X, :Y, :sub)
        (_rand_ang(T), T(-π)        , _rand_ang(T), :Y, :X, :Y, :sub)
        # YXZ
        (_rand_ang(T), _rand_ang2(T), _rand_ang(T), :Y, :X, :Z, :none)
        (_rand_ang(T), T(+π / 2)    , _rand_ang(T), :Y, :X, :Z, :sub)
        (_rand_ang(T), T(-π / 2)    , _rand_ang(T), :Y, :X, :Z, :sum)
        # YZY
        (_rand_ang(T), _rand_ang3(T), _rand_ang(T), :Y, :Z, :Y, :none)
        (_rand_ang(T), T(0)         , _rand_ang(T), :Y, :Z, :Y, :sum)
        (_rand_ang(T), T(+π)        , _rand_ang(T), :Y, :Z, :Y, :sub)
        (_rand_ang(T), T(-π)        , _rand_ang(T), :Y, :Z, :Y, :sub)
        # ZXY
        (_rand_ang(T), _rand_ang2(T), _rand_ang(T), :Z, :X, :Y, :none)
        (_rand_ang(T), T(+π / 2)    , _rand_ang(T), :Z, :X, :Y, :sum)
        (_rand_ang(T), T(-π / 2)    , _rand_ang(T), :Z, :X, :Y, :sub)
        # ZXZ
        (_rand_ang(T), _rand_ang3(T), _rand_ang(T), :Z, :X, :Z, :none)
        (_rand_ang(T), T(0)         , _rand_ang(T), :Z, :X, :Z, :sum)
        (_rand_ang(T), T(+π)        , _rand_ang(T), :Z, :X, :Z, :sub)
        (_rand_ang(T), T(-π)        , _rand_ang(T), :Z, :X, :Z, :sub)
        # ZYZ
        (_rand_ang(T), _rand_ang3(T), _rand_ang(T), :Z, :Y, :Z, :none)
        (_rand_ang(T), T(0)         , _rand_ang(T), :Z, :Y, :Z, :sum)
        (_rand_ang(T), T(+π)        , _rand_ang(T), :Z, :Y, :Z, :sub)
        (_rand_ang(T), T(-π)        , _rand_ang(T), :Z, :Y, :Z, :sub)
    ]

    for test in testset
        # Unpack values in tuple.
        a₁, a₂, a₃, r₁, r₂, r₃, c = test

        D = create_rotation_matrix(a₃, r₃) *
            create_rotation_matrix(a₂, r₂) *
            create_rotation_matrix(a₁, r₁)

        rot_seq = Symbol(string(r₁) * string(r₂) * string(r₃))
        ea = dcm_to_angle(D, rot_seq)
        @test eltype(ea) === T

        # Check the rotation sequence.
        @test ea.rot_seq == rot_seq

        # Compare the representations considering the singularities.
        if c == :none
            @test ea.a1 ≈ a₁
            @test ea.a2 ≈ a₂
            @test ea.a3 ≈ a₃
        elseif c == :sum
            # Treat the singularity when a₂ is ±π.
            abs(a₂) ≈ π && (a₂ = sign(ea.a2) * π)

            @test ea.a1 ≈ _norm_ang(a₁ + a₃)
            @test ea.a2 ≈ a₂
            @test ea.a3 ≈ 0
        elseif c == :sub
            # Treat the singularity when a₂ is ±π.
            abs(a₂) ≈ π && (a₂ = sign(ea.a2) * π)

            @test ea.a1 ≈ _norm_ang(a₁ - a₃)
            @test ea.a2 ≈ a₂
            @test ea.a3 ≈ 0
        end
    end
end

@testset "DCM => Euler angles (errors)" begin
    D = DCM(I)
    @test_throws ArgumentError dcm_to_angle(D, :XXY)
end

@testset "DCM => Euler angles (internal functions)" begin
    # Float64
    # ==========================================================================
    T = Float64

    a = ReferenceFrameRotations._mod_acos(1.0 + eps(T))
    @test a isa T
    @test a == 0

    a = ReferenceFrameRotations._mod_acos(-1.0 - eps(T))
    @test a isa T
    @test a == T(π)

    a = ReferenceFrameRotations._mod_asin(1.0 + eps(T))
    @test a isa T
    @test a == T(π / 2)

    a = ReferenceFrameRotations._mod_asin(-1.0 - eps(T))
    @test a isa T
    @test a == T(-π / 2)

    # Float32
    # ==========================================================================
    T = Float32

    a = ReferenceFrameRotations._mod_acos(1.0f0 + eps(T))
    @test a isa T
    @test a == 0

    a = ReferenceFrameRotations._mod_acos(-1.0f0 - eps(T))
    @test a isa T
    @test a == T(π)

    a = ReferenceFrameRotations._mod_asin(1.0f0 + eps(T))
    @test a isa T
    @test a == T(π / 2)

    a = ReferenceFrameRotations._mod_asin(-1.0f0 - eps(T))
    @test a isa T
    @test a == T(-π / 2)
end
