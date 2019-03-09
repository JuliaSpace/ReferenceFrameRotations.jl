################################################################################
#                           TEST: Compose Rotations
################################################################################

for i = 1:samples
    # DCMs
    # ==========================================================================

    # Sample 4 DCMs.
    for sym in [:D1, :D2, :D3, :D4]
        @eval $sym = angle_to_dcm(EulerAngles(-pi + 2*pi*rand(),
                                              -pi + 2*pi*rand(),
                                              -pi + 2*pi*rand(),
                                              rand($rot_seq_array)))
    end

    # Test the function `compose_rotation`.
    @test          D1 === compose_rotation(D1)
    @test       D2*D1  ≈  compose_rotation(D1,D2)       atol=1e-14
    @test    D3*D2*D1  ≈  compose_rotation(D1,D2,D3)    atol=1e-14
    @test D4*D3*D2*D1  ≈  compose_rotation(D1,D2,D3,D4) atol=1e-14

    # Euler angle and axis
    # ==========================================================================

    # Sample 4 Euler angle and axis.
    for sym in [:ea1, :ea2, :ea3, :ea4]
        α   = -π + 2π*rand()
        v   = randn(3)
        v   = v/norm(v)

        @eval $sym = EulerAngleAxis($α,$v)
    end

    ear1 = ea2*ea1
    eac1 = compose_rotation(ea1,ea2)

    ear2 = ea3*ea2*ea1
    eac2 = compose_rotation(ea1,ea2,ea3)

    ear3 = ea4*ea3*ea2*ea1
    eac3 = compose_rotation(ea1,ea2,ea3,ea4)

    # Test the function `compose_rotation`.
    @test ea1 === compose_rotation(ea1)
    @test ear1 ≈ eac1 atol = 1e-14
    @test ear2 ≈ eac2 atol = 1e-14
    @test ear3 ≈ eac3 atol = 1e-14

    # Euler angles
    # ==========================================================================

    # Sample 4 Euler angles.
    for sym in [:Θ1, :Θ2, :Θ3, :Θ4]
        θx      = -π + 2π*rand()
        θy      = -π + 2π*rand()
        θz      = -π + 2π*rand()
        rot_seq = Meta.quot(rand([:XYZ,:ZYX]))

        @eval $sym = EulerAngles($θx, $θy, $θz, $rot_seq)
    end

    Θr1 = Θ2*Θ1
    Θc1 = compose_rotation(Θ1,Θ2)

    Θr2 = Θ3*Θ2*Θ1
    Θc2 = compose_rotation(Θ1,Θ2,Θ3)

    Θr3 = Θ4*Θ3*Θ2*Θ1
    Θc3 = compose_rotation(Θ1,Θ2,Θ3,Θ4)

    # Test the function `compose_rotation`.
    @test Θ1 === compose_rotation(Θ1)
    @test Θr1 ≈ Θc1 atol = 1e-14
    @test Θr2 ≈ Θc2 atol = 1e-14
    @test Θr3 ≈ Θc3 atol = 1e-14

    # Quaternions
    # ==========================================================================

    # Sample 4 quaternions.
    for sym in [:q1, :q2, :q3, :q4]
        @eval $sym = angle_to_quat(EulerAngles(-pi + 2*pi*rand(),
                                               -pi + 2*pi*rand(),
                                               -pi + 2*pi*rand(),
                                               rand($rot_seq_array)))
    end

    # Test the function `compose_rotation`.
    @test           q1     === compose_rotation(q1)
    @test       (q1*q2)[:]  ≈  compose_rotation(q1,q2)[:]       atol=1e-14
    @test    (q1*q2*q3)[:]  ≈  compose_rotation(q1,q2,q3)[:]    atol=1e-14
    @test (q1*q2*q3*q4)[:]  ≈  compose_rotation(q1,q2,q3,q4)[:] atol=1e-14
end
