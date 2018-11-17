################################################################################
#                  TEST: Compose Rotations using Euler Angles
################################################################################

import Base: isapprox

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
end
