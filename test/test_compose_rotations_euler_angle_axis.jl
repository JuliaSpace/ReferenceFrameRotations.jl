################################################################################
#              TEST: Compose Rotations using Euler Angle and Axis
################################################################################

import Base: isapprox

# Define the function `isapprox` for `EulerAngleAxis` to make the comparison
# easier.
function isapprox(x::EulerAngleAxis, y::EulerAngleAxis; keys...)
    a = isapprox(x.a, y.a; keys...)
    v = isapprox(x.v, y.v; keys...)

    a && v
end

for i = 1:samples
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
end
