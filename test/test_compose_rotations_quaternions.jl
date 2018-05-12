################################################################################
#                  TEST: Compose Rotations using Quaternions
################################################################################


for i = 1:samples
    # Sample 8 quaternions.
    q1 = angle2quat(EulerAngles(-pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                rand(rot_seq_array)))

    q2 = angle2quat(EulerAngles(-pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                rand(rot_seq_array)))

    q3 = angle2quat(EulerAngles(-pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                rand(rot_seq_array)))

    q4 = angle2quat(EulerAngles(-pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                rand(rot_seq_array)))

    q5 = angle2quat(EulerAngles(-pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                rand(rot_seq_array)))

    q6 = angle2quat(EulerAngles(-pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                rand(rot_seq_array)))

    q7 = angle2quat(EulerAngles(-pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                rand(rot_seq_array)))

    q8 = angle2quat(EulerAngles(-pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                rand(rot_seq_array)))

    # Test the function `compose_rotation`.
    @test                   (q1*q2)[:] ≈ compose_rotation(q1,q2)[:]                   atol=1e-14
    @test                (q1*q2*q3)[:] ≈ compose_rotation(q1,q2,q3)[:]                atol=1e-14
    @test             (q1*q2*q3*q4)[:] ≈ compose_rotation(q1,q2,q3,q4)[:]             atol=1e-14
    @test          (q1*q2*q3*q4*q5)[:] ≈ compose_rotation(q1,q2,q3,q4,q5)[:]          atol=1e-14
    @test       (q1*q2*q3*q4*q5*q6)[:] ≈ compose_rotation(q1,q2,q3,q4,q5,q6)[:]       atol=1e-14
    @test    (q1*q2*q3*q4*q5*q6*q7)[:] ≈ compose_rotation(q1,q2,q3,q4,q5,q6,q7)[:]    atol=1e-14
    @test (q1*q2*q3*q4*q5*q6*q7*q8)[:] ≈ compose_rotation(q1,q2,q3,q4,q5,q6,q7,q8)[:] atol=1e-14

end
