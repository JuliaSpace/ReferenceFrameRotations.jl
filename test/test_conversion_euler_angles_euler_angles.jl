################################################################################
#                     TEST: Euler Angles <=> Euler Angles
################################################################################

let
    Θo  = EulerAngles(+π/2, +π/2, -π/2, :XYX)
    Θd1 = angle_to_angle(Θo, :ZXY)
    Θd2 = angle_to_angle(Θo, :XZY)
    Θd3 = angle_to_angle(Θo, :XYZ)
    Θd4 = angle_to_angle(Θo, :ZXZ)
    Θd5 = angle_to_angle(Θo, :ZYZ)

    @test Θd1.a1       ≈ π/2  atol = 1e-14
    @test Θd1.a2       ≈ 0    atol = 1e-14
    @test Θd1.a3       ≈ 0    atol = 1e-14
    @test Θd1.rot_seq == :ZXY

    @test Θd2.a1       ≈ 0    atol = 1e-14
    @test Θd2.a2       ≈ π/2  atol = 1e-14
    @test Θd2.a3       ≈ 0    atol = 1e-14
    @test Θd2.rot_seq == :XZY

    @test Θd3.a1       ≈ 0    atol = 1e-14
    @test Θd3.a2       ≈ 0    atol = 1e-14
    @test Θd3.a3       ≈ π/2  atol = 1e-14
    @test Θd3.rot_seq == :XYZ

    @test Θd4.a1       ≈ π/2  atol = 1e-14
    @test Θd4.a2       ≈ 0    atol = 1e-14
    @test Θd4.a3       ≈ 0    atol = 1e-14
    @test Θd4.rot_seq == :ZXZ

    @test Θd5.a1       ≈ π/2  atol = 1e-14
    @test Θd5.a2       ≈ 0    atol = 1e-14
    @test Θd5.a3       ≈ 0    atol = 1e-14
    @test Θd5.rot_seq == :ZYZ

    Θo  = EulerAngles(π/2, π/2, π/2, :XYX)
    Θd1 = angle_to_angle(Θo, :ZXY)
    Θd2 = angle_to_angle(Θo, :XZY)
    Θd3 = angle_to_angle(Θo, :XYZ)
    Θd4 = angle_to_angle(Θo, :ZXZ)
    Θd5 = angle_to_angle(Θo, :ZYZ)

    @test Θd1.a1       ≈ -π/2 atol = 1e-14
    @test Θd1.a2       ≈ 0    atol = 1e-14
    @test Θd1.a3       ≈ π    atol = 1e-14
    @test Θd1.rot_seq == :ZXY

    @test Θd2.a1       ≈ π    atol = 1e-14
    @test Θd2.a2       ≈ -π/2 atol = 1e-14
    @test Θd2.a3       ≈ 0    atol = 1e-14
    @test Θd2.rot_seq == :XZY

    @test Θd3.a1       ≈ π    atol = 1e-14
    @test Θd3.a2       ≈ 0    atol = 1e-14
    @test Θd3.a3       ≈ -π/2 atol = 1e-14
    @test Θd3.rot_seq == :XYZ

    @test Θd4.a1       ≈ π/2  atol = 1e-14
    @test Θd4.a2       ≈ π    atol = 1e-14
    @test Θd4.a3       ≈ 0    atol = 1e-14
    @test Θd4.rot_seq == :ZXZ

    @test Θd5.a1       ≈ -π/2 atol = 1e-14
    @test Θd5.a2       ≈ π    atol = 1e-14
    @test Θd5.a3       ≈ 0    atol = 1e-14
    @test Θd5.rot_seq == :ZYZ
end
