# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to conversion from quaternions to Euler angles.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/conversions/quaternion_to_angle.jl
# ==============================================

# Functions: quat_to_angle
# ------------------------

@testset "Quaternion => Euler angles (Float64)" begin
    T = Float64
    # We do not need comprehensive test here because `quat_to_angle` first
    # converts a quaternion to DCM and then to Euler angles. Those two
    # operations are already heavily tested.

    q = Quaternion(cosd(45 / 2), sind(45 / 2), 0, 0)
    ea = quat_to_angle(q, :ZYX)
    @test eltype(ea) === T
    @test ea.a1 ≈ 0
    @test ea.a2 ≈ 0
    @test ea.a3 ≈ 45 * pi / 180
    @test ea.rot_seq === :ZYX

    q = Quaternion(cosd(45 / 2), 0, sind(45 / 2), 0)
    ea = quat_to_angle(q, :ZYX)
    @test eltype(ea) === T
    @test ea.a1 ≈ 0
    @test ea.a2 ≈ 45 * pi / 180
    @test ea.a3 ≈ 0
    @test ea.rot_seq === :ZYX

    q = Quaternion(cosd(45 / 2), 0, 0, sind(45 / 2))
    ea = quat_to_angle(q, :ZYX)
    @test eltype(ea) === T
    @test ea.a1 ≈ 45 * pi / 180
    @test ea.a2 ≈ 0
    @test ea.a3 ≈ 0
    @test ea.rot_seq === :ZYX

    q = Quaternion(cosd(45 / 2), 0, 0, sind(45 / 2))
    ea = quat_to_angle(q, :YXZ)
    @test eltype(ea) === T
    @test ea.a1 ≈ 0
    @test ea.a2 ≈ 0
    @test ea.a3 ≈ 45 * pi / 180
    @test ea.rot_seq === :YXZ
end

@testset "Quaternion => Euler angles (Float64)" begin
    T = Float32
    # We do not need comprehensive test here because `quat_to_angle` first
    # converts a quaternion to DCM and then to Euler angles. Those two
    # operations are already heavily tested.

    q = Quaternion(cosd(T(45 / 2)), sind(T(45 / 2)), 0, 0)
    ea = quat_to_angle(q, :ZYX)
    @test eltype(ea) === T
    @test ea.a1 ≈ 0
    @test ea.a2 ≈ 0
    @test ea.a3 ≈ 45 * pi / 180
    @test ea.rot_seq === :ZYX

    q = Quaternion(cosd(T(45 / 2)), 0, sind(T(45 / 2)), 0)
    ea = quat_to_angle(q, :ZYX)
    @test eltype(ea) === T
    @test ea.a1 ≈ 0
    @test ea.a2 ≈ 45 * pi / 180
    @test ea.a3 ≈ 0
    @test ea.rot_seq === :ZYX

    q = Quaternion(cosd(T(45 / 2)), 0, 0, sind(T(45 / 2)))
    ea = quat_to_angle(q, :ZYX)
    @test eltype(ea) === T
    @test ea.a1 ≈ 45 * pi / 180
    @test ea.a2 ≈ 0
    @test ea.a3 ≈ 0
    @test ea.rot_seq === :ZYX

    q = Quaternion(cosd(T(45 / 2)), 0, 0, sind(T(45 / 2)))
    ea = quat_to_angle(q, :YXZ)
    @test eltype(ea) === T
    @test ea.a1 ≈ 0
    @test ea.a2 ≈ 0
    @test ea.a3 ≈ 45 * pi / 180
    @test ea.rot_seq === :YXZ
end
