# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to conversion from direction cosine matrices to quaternion.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/dcm.jl
# ==================

# Functions: dcm_to_quat
# ----------------------

@testset "DCM => Quaternion (Float64)" begin
    # The conversion between DCM and quaternion is tested by observing if the
    # rotation of a vector is consistent in both representations. In the
    # testset, we add all the special cases in the conversion.
    T = Float64
    testset = [
        (_rand_ang(), _rand_ang2(), _rand_ang(), :Z, :Y, :X)
        (-0.3,        +0.5,         +π,          :Z, :Y, :X)
        (+0.3,        +0.5,         +π,          :Z, :Y, :X)
        (+0.5,        +π,           -0.3,        :Z, :Y, :X)
        (+0.5,        +π,           +0.3,        :Z, :Y, :X)
        (+π,          +0.5,         -0.3,        :Z, :Y, :X)
        (+π,          +0.5,         +0.3,        :Z, :Y, :X)
    ]

    for test in testset
        # Unpack values in tuple.
        a₁, a₂, a₃, r₁, r₂, r₃ = test

        # Create the DCM.
        D = create_rotation_matrix(a₃, r₃) *
            create_rotation_matrix(a₂, r₂) *
            create_rotation_matrix(a₁, r₁)

        # Convert it to a quaternion.
        q = dcm_to_quat(D)

        # Test quaternion type.
        @test eltype(q) === T

        # The real part must always be positive.
        @test q.q0 > 0

        # The quaternion must be unitary.
        @test √(q.q0^2 + q.q1^2 + q.q2^2 + q.q3^2) ≈ 1

        # Compare the rotations between the DCM and quaternion.
        v = @SVector randn(3)

        vrd = D * v
        vrq = vect(q \ v * q)

        @test vrd ≈ vrq
        @test eltype(vrd) === eltype(vrq) === T
    end
end

@testset "DCM => Quaternion (Float32)" begin
    # The conversion between DCM and quaternion is tested by observing if the
    # rotation of a vector is consistent in both representations. In the
    # testset, we add all the special cases in the conversion.
    T = Float32
    testset = [
        (_rand_ang(T), _rand_ang2(T), _rand_ang(T), :Z, :Y, :X)
        (T(-0.3),      T(+0.5),       T(+π),        :Z, :Y, :X)
        (T(+0.3),      T(+0.5),       T(+π),        :Z, :Y, :X)
        (T(+0.5),      T(+π),         T(-0.3),      :Z, :Y, :X)
        (T(+0.5),      T(+π),         T(+0.3),      :Z, :Y, :X)
        (T(+π),        T(+0.5),       T(-0.3),      :Z, :Y, :X)
        (T(+π),        T(+0.5),       T(+0.3),      :Z, :Y, :X)
    ]

    for test in testset
        # Unpack values in tuple.
        a₁, a₂, a₃, r₁, r₂, r₃ = test

        # Create the DCM.
        D = create_rotation_matrix(a₃, r₃) *
            create_rotation_matrix(a₂, r₂) *
            create_rotation_matrix(a₁, r₁)

        # Convert it to a quaternion.
        q = dcm_to_quat(D)

        # Test quaternion type.
        @test eltype(q) === T

        # The real part must always be positive.
        @test q.q0 > 0

        # The quaternion must be unitary.
        @test √(q.q0^2 + q.q1^2 + q.q2^2 + q.q3^2) ≈ 1

        # Compare the rotations between the DCM and quaternion.
        v = @SVector randn(T, 3)

        vrd = D * v
        vrq = vect(q \ v * q)

        @test vrd ≈ vrq
        @test eltype(vrd) === eltype(vrq) === T
    end
end
