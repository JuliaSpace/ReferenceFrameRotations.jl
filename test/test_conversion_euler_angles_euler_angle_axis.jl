################################################################################
#                      Euler Angles <=> Euler Angle Axis
################################################################################

for k = 1:samples

    # Euler Angle and Axis => Euler Angles
    # ==========================================================================

    # Sample a vector that will be aligned with the Euler angle.
    v = [randn();randn();randn()]
    v = v/norm(v)

    # Sample a angle between (0,2π).
    a = 2*pi*rand()

    # Create the Euler Angle and Axis representation.
    angleaxis = EulerAngleAxis(a,v)

    # Sampe a rotation sequence.
    rot_seq = rand(rot_seq_array)

    # Convert to Euler angles.
    Θ = angleaxis_to_angle(angleaxis, rot_seq)

    # Obtain the Euler angles using the quaternion.
    Θq = quat_to_angle( angleaxis_to_quat(angleaxis), rot_seq )

    # Compare.
    @test Θ.a1       ≈ Θq.a1    atol = 1e-10
    @test Θ.a2       ≈ Θq.a2    atol = 1e-10
    @test Θ.a3       ≈ Θq.a3    atol = 1e-10
    @test Θ.rot_seq == rot_seq

    # Euler Angles => Euler Angle and Axis
    # ==========================================================================

    # Convert back to Euler angle and axis.
    ea = angle_to_angleaxis(Θ)

    # Normalize `a`.
    s = 1

    if a > π
        a = 2π - a
        s = -1
    end

    # Compare.
    @test a    ≈ ea.a      atol = 1e-8
    @test v[1] ≈ s*ea.v[1] atol = 1e-8
    @test v[2] ≈ s*ea.v[2] atol = 1e-8
    @test v[3] ≈ s*ea.v[3] atol = 1e-8
end

# Test the exceptions.
@test_throws ArgumentError angleaxis_to_angle(0, [1,0,0], :ABC)
