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
    q = angleaxis_to_quat(angleaxis)

    # Convert back to Euler Angle and Axis.
    angleaxis_conv = quat_to_angleaxis(q)

    # Notice that the returned Euler angle will be always in the interval
    # [0,π].
    s = +1
    (a > π) && (a = 2π - a; s = -1)

    # Compare.
    @test  abs(angleaxis_conv.a -   a) < 1e-10
    @test norm(angleaxis_conv.v - s*v) < 1e-10

    # Rotate a vector aligned with the Euler axis using the quaternion.
    r     = v*randn()
    r_rot = vect(q\r*q)

    # The vector representation must be the same after the rotation.
    @test norm(r-r_rot) < 1e-10
end

# Identity quaternion.
@test quat_to_angleaxis(Quaternion(1I))   === EulerAngleAxis(0,   [0,0,0])
@test quat_to_angleaxis(Quaternion(1.0I)) === EulerAngleAxis(0.0, [0,0,0])

# Test the exceptions.
@test_throws ArgumentError angleaxis_to_quat(0, [1;2;3;4])
