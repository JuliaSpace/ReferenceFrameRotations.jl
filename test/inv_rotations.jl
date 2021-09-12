# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to the API function to invert rotations.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/inv_rotations.jl
# ============================

# Functions: inv_rotation
# -----------------------

@testset "Invert rotations (Float64)" begin
    T = Float64

    # DCM
    # ==========================================================================

    # Create a random DCM.
    D = angle_to_dcm(_rand_ang(T), :Z) *
        angle_to_dcm(_rand_ang(T), :Y) *
        angle_to_dcm(_rand_ang(T), :X)

    Di = inv_rotation(D)
    @test eltype(Di) === T

    Die = inv(D)
    @test Di ≈ Die

    # Quaternion
    # ==========================================================================

    # Create a random quaternion.
    q = Quaternion(_rand_ang(T), _rand_ang(T), _rand_ang(T), _rand_ang(T))
    q = q / norm(q)

    qi = inv_rotation(q)
    @test eltype(qi) === T

    qie = inv(q)
    @test qi ≈ qie

    # Euler angle and axis
    # ==========================================================================

    # Create a random Euler angle and axis.
    v = @SVector rand(T, 3)
    a = _rand_ang(T)
    av = EulerAngleAxis(a, v)

    avi = inv_rotation(av)
    @test eltype(avi) === T

    avie = inv(av)
    @test avi ≈ avie

    # Euler angles
    # ==========================================================================

    # Create random Euler angles.
    ea = EulerAngles(_rand_ang(T), _rand_ang(T), _rand_ang(T), rand(valid_rot_seqs))

    eai = inv_rotation(ea)
    @test eltype(eai) === T

    eaie = inv(ea)
    @test eai ≈ eaie
end

@testset "Invert rotations (Float32)" begin
    T = Float32

    # DCM
    # ==========================================================================

    # Create a random DCM.
    D = angle_to_dcm(_rand_ang(T), :Z) *
        angle_to_dcm(_rand_ang(T), :Y) *
        angle_to_dcm(_rand_ang(T), :X)

    Di = inv_rotation(D)
    @test eltype(Di) === T

    Die = inv(D)
    @test Di ≈ Die

    # Quaternion
    # ==========================================================================

    # Create a random quaternion.
    q = Quaternion(_rand_ang(T), _rand_ang(T), _rand_ang(T), _rand_ang(T))
    q = q / norm(q)

    qi = inv_rotation(q)
    @test eltype(qi) === T

    qie = inv(q)
    @test qi ≈ qie

    # Euler angle and axis
    # ==========================================================================

    # Create a random Euler angle and axis.
    v = @SVector rand(T, 3)
    a = _rand_ang(T)
    av = EulerAngleAxis(a, v)

    avi = inv_rotation(av)
    @test eltype(avi) === T

    avie = inv(av)
    @test avi ≈ avie

    # Euler angles
    # ==========================================================================

    # Create random Euler angles.
    ea = EulerAngles(_rand_ang(T), _rand_ang(T), _rand_ang(T), rand(valid_rot_seqs))

    eai = inv_rotation(ea)
    @test eltype(eai) === T

    eaie = inv(ea)
    @test eai ≈ eaie
end


