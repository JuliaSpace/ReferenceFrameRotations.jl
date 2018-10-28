################################################################################
#                          TEST: DCM <=> Quaternions
################################################################################

for k = 1:samples
    # Conversion test
    # ===============

    # Create a random quaternion.
    q1 = Quaternion(randn(), randn(), randn(), rand())
    q1 = q1/norm(q1)

    # Make sure that the real part is positive.
    (q1.q0 < 0) && (q1 *= -1)

    # Create a random DCM using Euler Angles.
    dcm2 = angle_to_dcm(randn(), randn(), randn(), rot_seq_array[rand(1:9)])

    # Convert the quaternion in DCM and the DCM in quaternion.
    q2   = dcm_to_quat(dcm2)
    dcm1 = quat_to_dcm(q1)

    # Do the inverse conversion and compare.
    error_dcm = dcm2 - quat_to_dcm(q2)
    @test norm(error_dcm) < 1e-10

    error_q = q1 - dcm_to_quat(dcm1)
    @test norm(error_q) < 1e-10

    # Multiplication test
    # ===================

    # Sample a 3x1 vector.
    v = randn(3)

    # Compute the rotated vector using the quaternions.
    v_rot_q = vect((q1*q2)\v*(q1*q2))

    # Compute the rotated vector using the DCMs.
    v_rot_dcm = dcm2*dcm1*v

    # Compare.
    @test norm(v_rot_q-v_rot_dcm) < 1e-10
end
