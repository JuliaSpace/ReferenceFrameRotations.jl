# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to the API function to compose rotations.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/compose_rotations.jl
# ================================

# Functions: compose_rotations
# ----------------------------

@testset "Compose rotations (Float64)" begin
    T = Float64

    # DCMs
    # ==========================================================================

    # Sample 4 DCMs.
    for sym in [:D1, :D2, :D3, :D4]
        @eval $sym = angle_to_dcm(
            _rand_ang($T),
            _rand_ang($T),
            _rand_ang($T),
            rand($valid_rot_seqs)
        )
    end

    # Test the function `compose_rotation`.
    @test                D1 === compose_rotation(D1)
    @test           D2 * D1  ≈  compose_rotation(D1,D2)
    @test      D3 * D2 * D1  ≈  compose_rotation(D1,D2,D3)
    @test D4 * D3 * D2 * D1  ≈  compose_rotation(D1,D2,D3,D4)

    # Euler angle and axis
    # ==========================================================================

    # Sample 4 Euler angle and axis.
    for sym in [:ea1, :ea2, :ea3, :ea4]
        α   = _rand_ang(T)
        v   = @SVector randn(T, 3)
        v   = v/norm(v)

        @eval $sym = EulerAngleAxis($α, $v)
    end

    ear1 = ea2 * ea1
    eac1 = compose_rotation(ea1, ea2)

    ear2 = ea3 * ea2 * ea1
    eac2 = compose_rotation(ea1, ea2, ea3)

    ear3 = ea4 * ea3 * ea2 * ea1
    eac3 = compose_rotation(ea1, ea2, ea3, ea4)

    # Test the function `compose_rotation`.
    @test  ea1 === compose_rotation(ea1)
    @test ear1  ≈  eac1
    @test ear2  ≈  eac2
    @test ear3  ≈  eac3

    # Euler angles
    # ==========================================================================

    # Sample 4 Euler angles.
    for sym in [:Θ1, :Θ2, :Θ3, :Θ4]
        θx      = _rand_ang(T)
        θy      = _rand_ang(T)
        θz      = _rand_ang(T)
        rot_seq = Meta.quot(rand(valid_rot_seqs))

        @eval $sym = EulerAngles($θx, $θy, $θz, $rot_seq)
    end

    Θr1 = Θ2 * Θ1
    Θc1 = compose_rotation(Θ1, Θ2)

    Θr2 = Θ3 * Θ2 * Θ1
    Θc2 = compose_rotation(Θ1, Θ2, Θ3)

    Θr3 = Θ4 * Θ3 * Θ2 * Θ1
    Θc3 = compose_rotation(Θ1, Θ2, Θ3, Θ4)

    # Test the function `compose_rotation`.
    @test  Θ1 === compose_rotation(Θ1)
    @test Θr1  ≈  Θc1
    @test Θr2  ≈  Θc2
    @test Θr3  ≈  Θc3

    # Quaternions
    # ==========================================================================

    # Sample 4 quaternions.
    for sym in [:q1, :q2, :q3, :q4]
        @eval $sym = angle_to_quat(
            _rand_ang($T),
            _rand_ang($T),
            _rand_ang($T),
            rand($valid_rot_seqs)
        )
    end

    # Test the function `compose_rotation`.
    @test               q1 === compose_rotation(q1)
    @test       (q1*q2)[:]  ≈  compose_rotation(q1,q2)[:]
    @test    (q1*q2*q3)[:]  ≈  compose_rotation(q1,q2,q3)[:]
    @test (q1*q2*q3*q4)[:]  ≈  compose_rotation(q1,q2,q3,q4)[:]
end

@testset "Compose rotations (Float32)" begin
    T = Float32

    # DCMs
    # ==========================================================================

    # Sample 4 DCMs.
    for sym in [:D1, :D2, :D3, :D4]
        @eval $sym = angle_to_dcm(
            _rand_ang($T),
            _rand_ang($T),
            _rand_ang($T),
            rand($valid_rot_seqs)
        )
    end

    # Test the function `compose_rotation`.
    @test                D1 === compose_rotation(D1)
    @test           D2 * D1  ≈  compose_rotation(D1,D2)
    @test      D3 * D2 * D1  ≈  compose_rotation(D1,D2,D3)
    @test D4 * D3 * D2 * D1  ≈  compose_rotation(D1,D2,D3,D4)

    # Euler angle and axis
    # ==========================================================================

    # Sample 4 Euler angle and axis.
    for sym in [:ea1, :ea2, :ea3, :ea4]
        α   = _rand_ang(T)
        v   = @SVector randn(T, 3)
        v   = v/norm(v)

        @eval $sym = EulerAngleAxis($α, $v)
    end

    ear1 = ea2 * ea1
    eac1 = compose_rotation(ea1, ea2)

    ear2 = ea3 * ea2 * ea1
    eac2 = compose_rotation(ea1, ea2, ea3)

    ear3 = ea4 * ea3 * ea2 * ea1
    eac3 = compose_rotation(ea1, ea2, ea3, ea4)

    # Test the function `compose_rotation`.
    @test  ea1 === compose_rotation(ea1)
    @test ear1  ≈  eac1
    @test ear2  ≈  eac2
    @test ear3  ≈  eac3

    # Euler angles
    # ==========================================================================

    # Sample 4 Euler angles.
    for sym in [:Θ1, :Θ2, :Θ3, :Θ4]
        θx      = _rand_ang(T)
        θy      = _rand_ang(T)
        θz      = _rand_ang(T)
        rot_seq = Meta.quot(rand(valid_rot_seqs))

        @eval $sym = EulerAngles($θx, $θy, $θz, $rot_seq)
    end

    Θr1 = Θ2 * Θ1
    Θc1 = compose_rotation(Θ1, Θ2)

    Θr2 = Θ3 * Θ2 * Θ1
    Θc2 = compose_rotation(Θ1, Θ2, Θ3)

    Θr3 = Θ4 * Θ3 * Θ2 * Θ1
    Θc3 = compose_rotation(Θ1, Θ2, Θ3, Θ4)

    # Test the function `compose_rotation`.
    @test  Θ1 === compose_rotation(Θ1)
    @test Θr1  ≈  Θc1
    @test Θr2  ≈  Θc2
    @test Θr3  ≈  Θc3

    # Quaternions
    # ==========================================================================

    # Sample 4 quaternions.
    for sym in [:q1, :q2, :q3, :q4]
        @eval $sym = angle_to_quat(
            _rand_ang($T),
            _rand_ang($T),
            _rand_ang($T),
            rand($valid_rot_seqs)
        )
    end

    # Test the function `compose_rotation`.
    @test               q1 === compose_rotation(q1)
    @test       (q1*q2)[:]  ≈  compose_rotation(q1,q2)[:]
    @test    (q1*q2*q3)[:]  ≈  compose_rotation(q1,q2,q3)[:]
    @test (q1*q2*q3*q4)[:]  ≈  compose_rotation(q1,q2,q3,q4)[:]
end
