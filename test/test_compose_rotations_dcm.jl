################################################################################
#                      TEST: Compose Rotations using DCMs
################################################################################

for i = 1:samples
    # Sample 8 DCMs.
    D1 = angle_to_dcm(EulerAngles(-pi + 2*pi*rand(),
                                  -pi + 2*pi*rand(),
                                  -pi + 2*pi*rand(),
                                  rand(rot_seq_array)))

    D2 = angle_to_dcm(EulerAngles(-pi + 2*pi*rand(),
                                  -pi + 2*pi*rand(),
                                  -pi + 2*pi*rand(),
                                  rand(rot_seq_array)))

    D3 = angle_to_dcm(EulerAngles(-pi + 2*pi*rand(),
                                  -pi + 2*pi*rand(),
                                  -pi + 2*pi*rand(),
                                  rand(rot_seq_array)))

    D4 = angle_to_dcm(EulerAngles(-pi + 2*pi*rand(),
                                  -pi + 2*pi*rand(),
                                  -pi + 2*pi*rand(),
                                  rand(rot_seq_array)))

    D5 = angle_to_dcm(EulerAngles(-pi + 2*pi*rand(),
                                  -pi + 2*pi*rand(),
                                  -pi + 2*pi*rand(),
                                  rand(rot_seq_array)))

    D6 = angle_to_dcm(EulerAngles(-pi + 2*pi*rand(),
                                  -pi + 2*pi*rand(),
                                  -pi + 2*pi*rand(),
                                  rand(rot_seq_array)))

    D7 = angle_to_dcm(EulerAngles(-pi + 2*pi*rand(),
                                  -pi + 2*pi*rand(),
                                  -pi + 2*pi*rand(),
                                  rand(rot_seq_array)))

    D8 = angle_to_dcm(EulerAngles(-pi + 2*pi*rand(),
                                  -pi + 2*pi*rand(),
                                  -pi + 2*pi*rand(),
                                  rand(rot_seq_array)))

    # Test the function `compose_rotation`.
    @test                   D2*D1 ≈ compose_rotation(D1,D2)                   atol=1e-14
    @test                D3*D2*D1 ≈ compose_rotation(D1,D2,D3)                atol=1e-14
    @test             D4*D3*D2*D1 ≈ compose_rotation(D1,D2,D3,D4)             atol=1e-14
    @test          D5*D4*D3*D2*D1 ≈ compose_rotation(D1,D2,D3,D4,D5)          atol=1e-14
    @test       D6*D5*D4*D3*D2*D1 ≈ compose_rotation(D1,D2,D3,D4,D5,D6)       atol=1e-14
    @test    D7*D6*D5*D4*D3*D2*D1 ≈ compose_rotation(D1,D2,D3,D4,D5,D6,D7)    atol=1e-14
    @test D8*D7*D6*D5*D4*D3*D2*D1 ≈ compose_rotation(D1,D2,D3,D4,D5,D6,D7,D8) atol=1e-14

end
