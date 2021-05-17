# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to conversion between Euler angles.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/angle.jl
# ========================

# Functions: angle_to_angle
# -------------------------

@testset "Euler angles => Euler angles (Float64)" begin
    T = Float64

    # We do not need comprehensive test here because `angle_to_angle` first
    # converts the Euler angles to DCM and then back to Euler angles. Those
    # two operations are already heavily tested.

    ea1 = EulerAngles(deg2rad(T(45)), 0, 0, :XYZ)
    ea2 = angle_to_angle(ea1, :ZYX)
    @test eltype(ea2) === T
    @test ea2.a1 ≈ T(0)
    @test ea2.a2 ≈ T(0)
    @test ea2.a3 ≈ deg2rad(T(45))
    @test ea2.rot_seq == :ZYX

    ea1 = EulerAngles(deg2rad(T(45)), 0, 0, :YXZ)
    ea2 = angle_to_angle(ea1, :ZYX)
    @test eltype(ea2) === T
    @test ea2.a1 ≈ T(0)
    @test ea2.a2 ≈ deg2rad(T(45))
    @test ea2.a3 ≈ T(0)
    @test ea2.rot_seq == :ZYX

    ea1 = EulerAngles(deg2rad(T(45)), 0, 0, :ZXY)
    ea2 = angle_to_angle(ea1, :ZYX)
    @test eltype(ea2) === T
    @test ea2.a1 ≈ deg2rad(T(45))
    @test ea2.a2 ≈ T(0)
    @test ea2.a3 ≈ T(0)
    @test ea2.rot_seq == :ZYX

    ea1 = EulerAngles(π / 2, π / 6, 2 / 3 * π, :ZYX)
    ea2 = angle_to_angle(ea1, :ZYX)
    @test eltype(ea2) === T
    @test ea2.a1 ≈ ea1.a1
    @test ea2.a2 ≈ ea1.a2
    @test ea2.a3 ≈ ea1.a3
    @test ea2.rot_seq == :ZYX
end

@testset "Euler angles => Euler angles (Float32)" begin
    T = Float32

    # We do not need comprehensive test here because `angle_to_angle` first
    # converts the Euler angles to DCM and then back to Euler angles. Those
    # two operations are already heavily tested.

    ea1 = EulerAngles(deg2rad(T(45)), 0, 0, :XYZ)
    ea2 = angle_to_angle(ea1, :ZYX)
    @test eltype(ea2) === T
    @test ea2.a1 ≈ T(0)
    @test ea2.a2 ≈ T(0)
    @test ea2.a3 ≈ deg2rad(T(45))
    @test ea2.rot_seq == :ZYX

    ea1 = EulerAngles(deg2rad(T(45)), 0, 0, :YXZ)
    ea2 = angle_to_angle(ea1, :ZYX)
    @test eltype(ea2) === T
    @test ea2.a1 ≈ T(0)
    @test ea2.a2 ≈ deg2rad(T(45))
    @test ea2.a3 ≈ T(0)
    @test ea2.rot_seq == :ZYX

    ea1 = EulerAngles(deg2rad(T(45)), 0, 0, :ZXY)
    ea2 = angle_to_angle(ea1, :ZYX)
    @test eltype(ea2) === T
    @test ea2.a1 ≈ deg2rad(T(45))
    @test ea2.a2 ≈ T(0)
    @test ea2.a3 ≈ T(0)
    @test ea2.rot_seq == :ZYX

    ea1 = EulerAngles(T(π / 2), T(π / 6), T(2 / 3 * π), :ZYX)
    ea2 = angle_to_angle(ea1, :ZYX)
    @test eltype(ea2) === T
    @test ea2.a1 ≈ ea1.a1
    @test ea2.a2 ≈ ea1.a2
    @test ea2.a3 ≈ ea1.a3
    @test ea2.rot_seq == :ZYX
end
