# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to the Julia API to convert between the representations.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/conversions/api.jl
# ==============================

# Conversion to DCM
# ------------------------------------------------------------------------------

@testset "Julia conversion API: To DCM (Float 64)" begin
    T = Float64

    # Euler angles
    # ==========================================================================

    for rot_seq in valid_rot_seqs
        # Sample Euler angles.
        ea = EulerAngles(_rand_ang(T), _rand_ang(T), _rand_ang(T), rot_seq)

        D_exp = angle_to_dcm(ea)
        D_api = convert(DCM, ea)

        @test D_api === D_exp
    end

    # Euler angle and axis
    # ==========================================================================

    # Sample a random Euler angle and axis.
    v = @SVector randn(T, 3)
    v = v / norm(v)
    a = _rand_ang(T)
    av = EulerAngleAxis(a, v)

    D_exp = angleaxis_to_dcm(av)
    D_api = convert(DCM, av)

    @test D_api === D_exp

    # Quaternion
    # ==========================================================================

    # Create a random quaternion.
    q = Quaternion(randn(T), randn(T), randn(T), randn(T))
    q = q / norm(q)

    D_exp = quat_to_dcm(q)
    D_api = convert(DCM, q)

    @test D_api === D_exp
end

@testset "Julia conversion API: To DCM (Float 32)" begin
    T = Float32

    # Euler angles
    # ==========================================================================

    for rot_seq in valid_rot_seqs
        # Sample Euler angles.
        ea = EulerAngles(_rand_ang(T), _rand_ang(T), _rand_ang(T), rot_seq)

        D_exp = angle_to_dcm(ea)
        D_api = convert(DCM, ea)

        @test D_api === D_exp
    end

    # Euler angle and axis
    # ==========================================================================

    # Sample a random Euler angle and axis.
    v = @SVector randn(T, 3)
    v = v / norm(v)
    a = _rand_ang(T)
    av = EulerAngleAxis(a, v)

    D_exp = angleaxis_to_dcm(av)
    D_api = convert(DCM, av)

    @test D_api === D_exp

    # Quaternion
    # ==========================================================================

    # Create a random quaternion.
    q = Quaternion(randn(T), randn(T), randn(T), randn(T))
    q = q / norm(q)

    D_exp = quat_to_dcm(q)
    D_api = convert(DCM, q)

    @test D_api === D_exp
end

# Conversion to quaternion
# ------------------------------------------------------------------------------

@testset "Julia conversion API: To Quaternion (Float 64)" begin
    T = Float64

    # Euler angles
    # ==========================================================================

    for rot_seq in valid_rot_seqs
        # Sample Euler angles.
        ea = EulerAngles(_rand_ang(T), _rand_ang(T), _rand_ang(T), rot_seq)

        q_exp = angle_to_quat(ea)
        q_api = convert(Quaternion, ea)

        @test q_api === q_exp
    end

    # Euler angle and axis
    # ==========================================================================

    # Sample a random Euler angle and axis.
    v = @SVector randn(T, 3)
    v = v / norm(v)
    a = _rand_ang(T)
    av = EulerAngleAxis(a, v)

    q_exp = angleaxis_to_quat(av)
    q_api = convert(Quaternion, av)

    @test q_api === q_exp

    # Quaternion
    # ==========================================================================

    # Create a random quaternion.
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
        D = angle_to_dcm(a₃, r₃) * angle_to_dcm(a₂, r₂) * angle_to_dcm(a₁, r₁)

        q_exp = dcm_to_quat(D)
        q_api = convert(Quaternion, D)

        @test q_api === q_exp

    end
end

@testset "Julia conversion API: To Quaternion (Float 32)" begin
    T = Float32

    # Euler angles
    # ==========================================================================

    for rot_seq in valid_rot_seqs
        # Sample Euler angles.
        ea = EulerAngles(_rand_ang(T), _rand_ang(T), _rand_ang(T), rot_seq)

        q_exp = angle_to_quat(ea)
        q_api = convert(Quaternion, ea)

        @test q_api === q_exp
    end

    # Euler angle and axis
    # ==========================================================================

    # Sample a random Euler angle and axis.
    v = @SVector randn(T, 3)
    v = v / norm(v)
    a = _rand_ang(T)
    av = EulerAngleAxis(a, v)

    q_exp = angleaxis_to_quat(av)
    q_api = convert(Quaternion, av)

    @test q_api === q_exp

    # Quaternion
    # ==========================================================================

    # Create a random quaternion.
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
        D = angle_to_dcm(a₃, r₃) * angle_to_dcm(a₂, r₂) * angle_to_dcm(a₁, r₁)

        q_exp = dcm_to_quat(D)
        q_api = convert(Quaternion, D)

        @test q_api === q_exp

    end
end
