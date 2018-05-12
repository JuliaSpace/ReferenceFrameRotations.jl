################################################################################
#                          TEST: DCM <=> Euler Angles
################################################################################

for k = 1:samples
    for rot_seq in rot_seq_array
        # Sample three angles form a uniform distribution [-pi,pi].
        eulerang = EulerAngles(-pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               rot_seq)

        # Get the error matrix related to the conversion from DCM => Euler
        # Angles => DCM.
        error = angle2rot(dcm2angle(angle2dcm(eulerang),rot_seq)) -
                angle2rot(eulerang)

        # If everything is fine, the norm of the matrix error should be small.
        @test norm(error) < 1e-10
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
    error = angle2rot(eulerang) -
            smallangle2rot(eulerang.a1, eulerang.a2, eulerang.a3)

    # If everything is fine, the norm of the matrix error should be small.
    @test norm(error) < 1e-7
end

