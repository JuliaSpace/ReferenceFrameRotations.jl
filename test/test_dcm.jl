################################################################################
#                                  TEST: DCM
################################################################################

for k = 1:samples
    # Rotations
    # =========

    # X Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a DCM that rotates about X axis.
    dcm = create_rotation_matrix(ang, :X)

    # Create a vector that does not have X component.
    v = [0;randn();randn()]

    # Rotate the reference using the DCM.
    v_r = dcm*v

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[1]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Y Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a DCM that rotates about Y axis.
    dcm = create_rotation_matrix(ang, :Y)

    # Create a vector that does not have Y component.
    v = [randn();0;randn()]

    # Rotate the reference using the DCM.
    v_r = dcm*v

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[2]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Z Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a DCM that rotates about Z axis.
    dcm = create_rotation_matrix(ang, :Z)

    # Create a vector that does not have Z component.
    v = [randn();randn();0]

    # Rotate the reference using the DCM.
    v_r = dcm*v

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[3]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Orthonormality
    # ==============

    # Sample two DCMs.
    dcm1 = create_rotation_matrix(randn(), rand([:X,:Y,:Z]))
    dcm2 = create_rotation_matrix(randn(), rand([:X,:Y,:Z]))

    # Create another DCM.
    dcm3 = dcm2*dcm1

    # Check if they are orthonormal.
    @test norm(inv_rotation(dcm3)-inv(dcm1)*inv(dcm2)) < 5e-10
end

# Test exceptions.
I3 = DCM(Matrix{Float64}(I, 3, 3))

@test_throws Exception create_rotation_matrix(0, :x)
@test_throws Exception create_rotation_matrix(0, :y)
@test_throws Exception create_rotation_matrix(0, :z)
@test_throws Exception create_rotation_matrix(0, :a)
@test_throws ArgumentError dcm2angle(I3,:xyz)
@test_throws ArgumentError dcm2angle(I3,:zyx)
@test_throws ArgumentError dcm2angle(I3,:xyx)
@test_throws ArgumentError dcm2angle(I3,:abc)
@test_throws ArgumentError ddcm(I3, [1])
@test_throws ArgumentError ddcm(I3, [1;2])
@test_throws ArgumentError ddcm(I3, [1;2;3;4])
@test_throws ArgumentError ddcm(I3, [1;2;3;4;5])

