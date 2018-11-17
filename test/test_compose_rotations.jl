################################################################################
#                           TEST: Compose Rotations
################################################################################

import Base: isapprox

# Define the function `isapprox` for `EulerAngleAxis` to make the comparison
# easier.
function isapprox(x::EulerAngleAxis, y::EulerAngleAxis; keys...)
    a = isapprox(x.a, y.a; keys...)
    v = isapprox(x.v, y.v; keys...)

    a && v
end
#
# Define the function `isapprox` for `EulerAngles` to make the comparison
# easier.
function isapprox(x::EulerAngles, y::EulerAngles; keys...)
    a1 = isapprox(x.a1, y.a1; keys...)
    a2 = isapprox(x.a2, y.a2; keys...)
    a3 = isapprox(x.a3, y.a3; keys...)
    r  = x.rot_seq == y.rot_seq

    a1 && a2 && a3 && r
end

for i = 1:samples
    # DCMs
    # ==========================================================================

    # Sample 8 DCMs.
    for sym in [:D1, :D2, :D3, :D4, :D5, :D6, :D7, :D8]
        @eval $sym = angle_to_dcm(EulerAngles(-pi + 2*pi*rand(),
                                              -pi + 2*pi*rand(),
                                              -pi + 2*pi*rand(),
                                              rand($rot_seq_array)))
    end

    # Test the function `compose_rotation`.
    @test                   D2*D1 ≈ compose_rotation(D1,D2)                   atol=1e-14
    @test                D3*D2*D1 ≈ compose_rotation(D1,D2,D3)                atol=1e-14
    @test             D4*D3*D2*D1 ≈ compose_rotation(D1,D2,D3,D4)             atol=1e-14
    @test          D5*D4*D3*D2*D1 ≈ compose_rotation(D1,D2,D3,D4,D5)          atol=1e-14
    @test       D6*D5*D4*D3*D2*D1 ≈ compose_rotation(D1,D2,D3,D4,D5,D6)       atol=1e-14
    @test    D7*D6*D5*D4*D3*D2*D1 ≈ compose_rotation(D1,D2,D3,D4,D5,D6,D7)    atol=1e-14
    @test D8*D7*D6*D5*D4*D3*D2*D1 ≈ compose_rotation(D1,D2,D3,D4,D5,D6,D7,D8) atol=1e-14

    # Euler angle and axis
    # ==========================================================================

    # Sample 8 Euler angle and axis.
    for sym in [:ea1, :ea2, :ea3, :ea4, :ea5, :ea6, :ea7, :ea8 ]
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

    ear4 = ea5*ea4*ea3*ea2*ea1
    eac4 = compose_rotation(ea1,ea2,ea3,ea4,ea5)

    ear5 = ea6*ea5*ea4*ea3*ea2*ea1
    eac5 = compose_rotation(ea1,ea2,ea3,ea4,ea5,ea6)

    ear6 = ea7*ea6*ea5*ea4*ea3*ea2*ea1
    eac6 = compose_rotation(ea1,ea2,ea3,ea4,ea5,ea6,ea7)

    ear7 = ea8*ea7*ea6*ea5*ea4*ea3*ea2*ea1
    eac7 = compose_rotation(ea1,ea2,ea3,ea4,ea5,ea6,ea7,ea8)

    # Test the function `compose_rotation`.
    @test ear1 ≈ eac1 atol = 1e-14
    @test ear2 ≈ eac2 atol = 1e-14
    @test ear3 ≈ eac3 atol = 1e-14
    @test ear4 ≈ eac4 atol = 1e-14
    @test ear5 ≈ eac5 atol = 1e-14
    @test ear6 ≈ eac6 atol = 1e-14
    @test ear7 ≈ eac7 atol = 1e-14

    # Euler angles
    # ==========================================================================

    # Sample 8 Euler angles.
    for sym in [:Θ1, :Θ2, :Θ3, :Θ4, :Θ5, :Θ6, :Θ7, :Θ8 ]
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

    Θr4 = Θ5*Θ4*Θ3*Θ2*Θ1
    Θc4 = compose_rotation(Θ1,Θ2,Θ3,Θ4,Θ5)

    Θr5 = Θ6*Θ5*Θ4*Θ3*Θ2*Θ1
    Θc5 = compose_rotation(Θ1,Θ2,Θ3,Θ4,Θ5,Θ6)

    Θr6 = Θ7*Θ6*Θ5*Θ4*Θ3*Θ2*Θ1
    Θc6 = compose_rotation(Θ1,Θ2,Θ3,Θ4,Θ5,Θ6,Θ7)

    Θr7 = Θ8*Θ7*Θ6*Θ5*Θ4*Θ3*Θ2*Θ1
    Θc7 = compose_rotation(Θ1,Θ2,Θ3,Θ4,Θ5,Θ6,Θ7,Θ8)

    # Test the function `compose_rotation`.
    @test Θr1 ≈ Θc1 atol = 1e-14
    @test Θr2 ≈ Θc2 atol = 1e-14
    @test Θr3 ≈ Θc3 atol = 1e-14
    @test Θr4 ≈ Θc4 atol = 1e-14
    @test Θr5 ≈ Θc5 atol = 1e-14
    @test Θr6 ≈ Θc6 atol = 1e-14
    @test Θr7 ≈ Θc7 atol = 1e-14

    # Quaternions
    # ==========================================================================

    # Sample 8 quaternions.
    for sym in [:q1, :q2, :q3, :q4, :q5, :q6, :q7, :q8]
        @eval $sym = angle_to_quat(EulerAngles(-pi + 2*pi*rand(),
                                               -pi + 2*pi*rand(),
                                               -pi + 2*pi*rand(),
                                               rand($rot_seq_array)))
    end

    # Test the function `compose_rotation`.
    @test                   (q1*q2)[:] ≈ compose_rotation(q1,q2)[:]                   atol=1e-14
    @test                (q1*q2*q3)[:] ≈ compose_rotation(q1,q2,q3)[:]                atol=1e-14
    @test             (q1*q2*q3*q4)[:] ≈ compose_rotation(q1,q2,q3,q4)[:]             atol=1e-14
    @test          (q1*q2*q3*q4*q5)[:] ≈ compose_rotation(q1,q2,q3,q4,q5)[:]          atol=1e-14
    @test       (q1*q2*q3*q4*q5*q6)[:] ≈ compose_rotation(q1,q2,q3,q4,q5,q6)[:]       atol=1e-14
    @test    (q1*q2*q3*q4*q5*q6*q7)[:] ≈ compose_rotation(q1,q2,q3,q4,q5,q6,q7)[:]    atol=1e-14
    @test (q1*q2*q3*q4*q5*q6*q7*q8)[:] ≈ compose_rotation(q1,q2,q3,q4,q5,q6,q7,q8)[:] atol=1e-14
end
