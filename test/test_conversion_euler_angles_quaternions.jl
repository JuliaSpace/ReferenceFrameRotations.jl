################################################################################
#                         Euler Angles <=> Quaternions
################################################################################

for rot_seq in rot_seq_array
    for k = 1:samples
        # Sample a vector.
        v = randn(3)

        # Sample three angles form a uniform distribution [-pi,pi].
        eulerang = EulerAngles(-pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               rot_seq)

        # Rotate the vector using a DCM (which was already tested).
        D      = angle2rot(eulerang)
        rv_dcm = D*v

        # Rotate the vector using a quaternion.
        q       = angle2rot(Quaternion,eulerang)
        rv_quat = vect(inv(q)*v*q)

        # Compare.
        @test norm(rv_quat-rv_dcm) < 1e-10

        # Compute the Euler angles using the Quaternion.
        eulerang_quat = quat2angle(q, eulerang.rot_seq)

        # Create the quaternion using those Euler angles and compare to the
        # original.
        q2 = angle2rot(Quaternion,eulerang_quat)

        @test q2.q0 ≈ q.q0 atol=1e-10
        @test q2.q1 ≈ q.q1 atol=1e-10
        @test q2.q2 ≈ q.q2 atol=1e-10
        @test q2.q3 ≈ q.q3 atol=1e-10
    end
end

for k = 1:samples
    # Sample three angles form a uniform distribution [-0.0001,0.0001].
    eulerang = EulerAngles(-0.0001 + 0.0002*rand(),
                           -0.0001 + 0.0002*rand(),
                           -0.0001 + 0.0002*rand(),
                           :XYZ)

    # Get the error between the exact rotation and the small angle
    # approximation.
    error = angle2rot(Quaternion,eulerang) -
            smallangle2rot(Quaternion,eulerang.a1, eulerang.a2, eulerang.a3)

    # If everything is fine, the norm of the matrix error should be small.
    @test norm(error) < 1e-7
end


