################################################################################
#                         Euler Angles <=> Quaternions
################################################################################

for rot_seq in rot_seq_array
    for k = 1:samples
        # Sample a vector.
        v = randn(3)

        # Sample three angles form a uniform distribution [-pi,pi].
        θx = -pi + 2*pi*rand()
        θy = -pi + 2*pi*rand()
        θz = -pi + 2*pi*rand()
        Θ  = EulerAngles(θx, θy, θz, rot_seq)

        # Rotate the vector using a DCM (which was already tested).
        D      = angle_to_rot(Θ)
        rv_dcm = D*v

        # Rotate the vector using a quaternion.
        q1    = angle_to_rot(Quaternion,Θ)
        rv_q1 = vect(q1\v*q1)

        q2    = angle_to_rot(Quaternion,θx,θy,θz,rot_seq)
        rv_q2 = vect(q2\v*q2)

        # Compare.
        @test norm(rv_q1-rv_dcm) < 1e-10
        @test norm(rv_q2-rv_dcm) < 1e-10
        @test rv_q1 ≈ rv_q2

        # Compute the Euler angles using the Quaternion.
        Θ_quat = quat_to_angle(q1, Θ.rot_seq)

        # Create the quaternion using those Euler angles and compare to the
        # original.
        q3 = angle_to_rot(Quaternion,Θ_quat)

        @test q3.q0 ≈ q1.q0 atol=1e-10
        @test q3.q1 ≈ q1.q1 atol=1e-10
        @test q3.q2 ≈ q1.q2 atol=1e-10
        @test q3.q3 ≈ q1.q3 atol=1e-10
    end

    # Check situations with singularities.
    α  = -pi + 2*pi*rand()

    q  = angle_to_quat(α, 0, 0, :XYZ)
    Θ₁ = quat_to_angle(q, :XYX)
    Θ₂ = quat_to_angle(q, :XZX)
    @test Θ₁.a1 ≈ α
    @test Θ₂.a1 ≈ α

    q  = angle_to_quat(0, α, 0, :XYZ)
    Θ₁ = quat_to_angle(q, :YXY)
    Θ₂ = quat_to_angle(q, :YZY)
    @test Θ₁.a1 ≈ α
    @test Θ₂.a1 ≈ α

    q  = angle_to_quat(0, 0, α, :XYZ)
    Θ₁ = quat_to_angle(q, :ZXZ)
    Θ₂ = quat_to_angle(q, :ZYZ)
    @test Θ₁.a1 ≈ α
    @test Θ₂.a1 ≈ α
end

for k = 1:samples
    # Sample three angles form a uniform distribution [-0.0001,0.0001].
    Θ = EulerAngles(-0.0001 + 0.0002*rand(),
                    -0.0001 + 0.0002*rand(),
                    -0.0001 + 0.0002*rand(),
                    :XYZ)

    # Get the error between the exact rotation and the small angle
    # approximation.
    error = angle_to_rot(Quaternion,Θ) -
            smallangle_to_rot(Quaternion,Θ.a1, Θ.a2, Θ.a3)

    # If everything is fine, the norm of the matrix error should be small.
    @test norm(error) < 1e-7
end
