################################################################################
#                       Euler Angle Axis <=> Quaternions
################################################################################

for k = 1:samples
    # Sample a vector that will be aligned with the Euler angle.
    v = [randn();randn();randn()]
    v = v/norm(v)

    # Sample a angle between (0,2π).
    a = 2*pi*rand()

    # Create the Euler Angle and Axis representation.
    angleaxis = EulerAngleAxis(a,v)

    # Convert to quaternion.
    q = angleaxis2quat(angleaxis)

    # Convert back to Euler Angle and Axis.
    angleaxis_conv = quat2angleaxis(q)

    # Compare.
    @test  abs(angleaxis_conv.a - a) < 1e-10
    @test norm(angleaxis_conv.v - v) < 1e-10

    # Rotate a vector aligned with the Euler axis using the quaternion.
    r     = v*randn()
    r_rot = vect(q\r*q)

    # The vector representation must be the same after the rotation.
    @test norm(r-r_rot) < 1e-10
end

# Test the exceptions.
@test_throws ArgumentError angleaxis2quat(0, [1;2;3;4])
