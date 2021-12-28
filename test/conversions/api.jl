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

        # Convert to DCM.
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

        # Convert to DCM.
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
