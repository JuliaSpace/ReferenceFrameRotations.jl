using Rotations
using Base.Test

# Available rotations.
rot_seq_array = ["XYX",
                 "XYZ",
                 "XZX",
                 "XZY",
                 "YXY",
                 "YXZ",
                 "YZX",
                 "YZY",
                 "ZXY",
                 "ZXZ",
                 "ZYX",
                 "ZYZ"]

# Number of samples.
samples = 1000

################################################################################
#                                  TEST: DCM
################################################################################

println("Testing DCM functions ($samples samples)...")

for k = 1:samples
    # Rotations
    # =========

    # X Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a DCM that rotates about X axis.
    dcm = create_rotation_matrix(ang, 'x')

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
    dcm = create_rotation_matrix(ang, 'y')

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
    dcm = create_rotation_matrix(ang, 'z')

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
    dcm1 = create_rotation_matrix(randn(), rand(['x','y','z']))
    dcm2 = create_rotation_matrix(randn(), rand(['x','y','z']))

    # Create another DCM.
    dcm3 = dcm2*dcm1

    # Check if they are orthonormal.
    @test norm(dcm3'-inv(dcm1)*inv(dcm2)) < 1e-10
end

################################################################################
#                              TEST: Quaternions
################################################################################

println("Testing Quaternions functions ($samples samples)...")

for i = 1:samples
    # Rotations
    # =========

    # X Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a quaternion that rotates about X axis.
    q = Quaternion(cos(ang/2), sin(ang/2)*[1;0;0])

    # Create a vector that does not have X component.
    v = [0;randn();randn()]

    # Rotate the reference using the quaternion.
    v_r = vect(inv(q)*v*q)

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[1]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Y Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a quaternion that rotates about Y axis.
    q = Quaternion(cos(ang/2), sin(ang/2)*[0;1;0])

    # Create a vector that does not have Y component.
    v = [randn();0;randn()]

    # Rotate the reference using the quaternion.
    v_r = vect(inv(q)*v*q)

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[2]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Z Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a quaternion that rotates about Z axis.
    q = Quaternion(cos(ang/2), sin(ang/2)*[0;0;1])

    # Create a vector that does not have Z component.
    v = [randn();randn();0]

    # Rotate the reference using the quaternion.
    v_r = vect(inv(q)*v*q)

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[3]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10
end

################################################################################
#                          TEST: DCM <=> Euler Angles
################################################################################

println("Testing DCM <=> Euler Angles conversions ($samples samples)...")

for k = 1:samples
    for rot_seq in rot_seq_array
        # Sample three angles form a uniform distribution [-pi,pi].
        eulerang = EulerAngles(-pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               rot_seq)

        # Get the error matrix related to the conversion from DCM => Euler Angles =>
        # DCM.
        error = angle2dcm(dcm2angle(angle2dcm(eulerang),rot_seq)) -
        angle2dcm(eulerang)

        # If everything is fine, the norm of the matrix error should be small.
        @test norm(error) < 1e-10
    end
end

################################################################################
#                          TEST: DCM <=> Quaternions
################################################################################

println("Testing DCM <=> Quaternion conversions ($samples samples)...")

for k = 1:samples
    # Conversion test
    # ===============

    # Create a random quaternion.
    q1 = Quaternion(randn(), randn(), randn(), rand())
    q1 = q1/norm(q1)

    # Make sure that the real part is positive.
    (q1.q0 < 0) && (q1 *= -1)

    # Create a random DCM using Euler Angles.
    dcm2 = angle2dcm(randn(), randn(), randn(), rot_seq_array[rand(1:9)])

    # Convert the quaternion in DCM and the DCM in quaternion.
    q2   = dcm2quat(dcm2)
    dcm1 = quat2dcm(q1)

    # Do the inverse conversion and compare.
    error_dcm = dcm2 - quat2dcm(q2)
    @test norm(error_dcm) < 1e-10

    error_q = q1 - dcm2quat(dcm1)
    @test norm(error_q) < 1e-10

    # Multiplication test
    # ===================

    # Sample a 3x1 vector.
    v = randn(3)

    # Compute the rotated vector using the quaternions.
    v_rot_q = vect(inv(q1*q2)*v*(q1*q2))

    # Compute the rotated vector using the DCMs.
    v_rot_dcm = dcm2*dcm1*v

    # Compare.
    @test norm(v_rot_q-v_rot_dcm) < 1e-10
end
