# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to conversion from Euler angle and axis to Euler angles.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/angleaxis.jl
# ========================

# Functions: angleaxis_to_angle
# -----------------------------

@testset "Euler angle and axis => Euler angles (Float64)" begin
    T = Float64
    # We do not need comprehensive test here because `quat_to_angle` first
    # converts an Euler angle and axis to DCM and then to Euler angles. Those
    # two operations are already heavily tested.

    av = EulerAngleAxis(deg2rad(T(45)), T[1, 0, 0])
    ea = angleaxis_to_angle(av, :ZYX)
    @test eltype(ea) === T
    @test ea.a1 ≈ 0
    @test ea.a2 ≈ 0
    @test ea.a3 ≈ 45 * pi / 180
    @test ea.rot_seq === :ZYX

    av = EulerAngleAxis(deg2rad(T(45)), [0, 1, 0])
    ea = angleaxis_to_angle(av, :ZYX)
    @test eltype(ea) === T
    @test ea.a1 ≈ 0
    @test ea.a2 ≈ 45 * pi / 180
    @test ea.a3 ≈ 0
    @test ea.rot_seq === :ZYX

    av = EulerAngleAxis(deg2rad(T(45)), T[0, 0, 1])
    ea = angleaxis_to_angle(av, :ZYX)
    @test eltype(ea) === T
    @test ea.a1 ≈ 45 * pi / 180
    @test ea.a2 ≈ 0
    @test ea.a3 ≈ 0
    @test ea.rot_seq === :ZYX

    av = EulerAngleAxis(deg2rad(T(45)), [0, 0, 1])
    ea = angleaxis_to_angle(av, :YXZ)
    @test eltype(ea) === T
    @test ea.a1 ≈ 0
    @test ea.a2 ≈ 0
    @test ea.a3 ≈ 45 * pi / 180
    @test ea.rot_seq === :YXZ
end

@testset "Euler angle and axis => Euler angles (Float32)" begin
    T = Float32
    # We do not need comprehensive test here because `quat_to_angle` first
    # converts an Euler angle and axis to DCM and then to Euler angles. Those
    # two operations are already heavily tested.

    av = EulerAngleAxis(deg2rad(T(45)), T[1, 0, 0])
    ea = angleaxis_to_angle(av, :ZYX)
    @test eltype(ea) === T
    @test ea.a1 ≈ 0
    @test ea.a2 ≈ 0
    @test ea.a3 ≈ 45 * pi / 180
    @test ea.rot_seq === :ZYX

    av = EulerAngleAxis(deg2rad(T(45)), [0, 1, 0])
    ea = angleaxis_to_angle(av, :ZYX)
    @test eltype(ea) === T
    @test ea.a1 ≈ 0
    @test ea.a2 ≈ 45 * pi / 180
    @test ea.a3 ≈ 0
    @test ea.rot_seq === :ZYX

    av = EulerAngleAxis(deg2rad(T(45)), T[0, 0, 1])
    ea = angleaxis_to_angle(av, :ZYX)
    @test eltype(ea) === T
    @test ea.a1 ≈ 45 * pi / 180
    @test ea.a2 ≈ 0
    @test ea.a3 ≈ 0
    @test ea.rot_seq === :ZYX

    av = EulerAngleAxis(deg2rad(T(45)), [0, 0, 1])
    ea = angleaxis_to_angle(av, :YXZ)
    @test eltype(ea) === T
    @test ea.a1 ≈ 0
    @test ea.a2 ≈ 0
    @test ea.a3 ≈ 45 * pi / 180
    @test ea.rot_seq === :YXZ
end

@testset "Euler angle and axis => Euler angles (Errors)" begin
    @test_throws ArgumentError angleaxis_to_angle(0, [1, 2], :ZYX)
    @test_throws ArgumentError angleaxis_to_angle(0, [1, 2, 3, 4], :ZYX)
end
