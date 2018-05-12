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
        DCM = angle2dcm(eulerang)
        rv_dcm = DCM*v

        # Rotate the vector using a quaternion.
        q = angle2quat(eulerang)
        rv_quat = vect(inv(q)*v*q)

        # Compare.
        @test norm(rv_quat-rv_dcm) < 1e-10
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
    error = angle2quat(eulerang) -
            smallangle2quat(eulerang.a1, eulerang.a2, eulerang.a3)

    # If everything is fine, the norm of the matrix error should be small.
    @test norm(error) < 1e-7
end
