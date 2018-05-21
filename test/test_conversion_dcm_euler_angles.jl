################################################################################
#                          TEST: DCM <=> Euler Angles
################################################################################

for k = 1:samples
    for rot_seq in rot_seq_array
        # Sample three angles form a uniform distribution [-pi,pi].
        θx       = -pi + 2*pi*rand()
        θy       = -pi + 2*pi*rand()
        θz       = -pi + 2*pi*rand()
        eulerang = EulerAngles(θx, θy, θz, rot_seq)

        # Get the error matrix related to the conversion from DCM => Euler
        # Angles => DCM.
        error1 = angle2rot(DCM, dcm2angle(angle2rot(eulerang),rot_seq)) -
                 angle2rot(DCM, θx, θy, θz, rot_seq)
        error2 = angle2rot(dcm2angle(angle2rot(θx, θy, θz, rot_seq),rot_seq)) -
                 angle2rot(eulerang)

        # If everything is fine, the norm of the matrix error should be small.
        @test norm(error1) < 1e-10
        @test norm(error2) < 1e-10
        @test error1 ≈ error2
    end
end

for k = 1:samples
    # Sample three angles form a uniform distribution [-0.0001,0.0001].
    θx       = -0.0001 + 0.0002*pi*rand()
    θy       = -0.0001 + 0.0002*pi*rand()
    θz       = -0.0001 + 0.0002*pi*rand()
    eulerang = EulerAngles(θx, θy, θz, :XYZ)

    # Get the error between the exact rotation and the small angle
    # approximation.
    error1 = angle2rot(eulerang) -
             smallangle2rot(DCM, eulerang.a1, eulerang.a2, eulerang.a3)
    error2 = angle2rot(θx, θy, θz, :XYZ) -
             smallangle2rot(eulerang.a1, eulerang.a2, eulerang.a3)

    # If everything is fine, the norm of the matrix error should be small.
    @test norm(error1) < 5e-7
    @test norm(error2) < 5e-7
    @test error1 ≈ error2
end

# Test exceptions.
@test_throws ArgumentError angle2dcm(0,0,0,:xyz)
@test_throws ArgumentError angle2dcm(0,0,0,:zyx)
@test_throws ArgumentError angle2dcm(0,0,0,:xyx)
@test_throws ArgumentError angle2dcm(0,0,0,:abc)
@test_throws ArgumentError angle2quat(0,0,0,:xyz)
@test_throws ArgumentError angle2quat(0,0,0,:zyx)
@test_throws ArgumentError angle2quat(0,0,0,:xyx)
@test_throws ArgumentError angle2quat(0,0,0,:abc)
