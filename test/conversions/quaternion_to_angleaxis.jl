# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to conversion from quaternions to Euler angle and axis.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/conversions/quaternion_to_angleaxis.jl
# ==================================================

# Functions: quat_to_angleaxis
# ----------------------------

@testset "Quaternion => Euler angle and axis (Float64)" begin
    T = Float64

    q = Quaternion(cosd(T(75 / 2)), 0, sind(T(75 / 2)), 0)
    av = quat_to_angleaxis(q)
    @test eltype(av) === T
    @test av.a ≈ 75 * pi / 180
    @test av.v ≈ [0, 1, 0]

    q = Quaternion(cosd(T(225 / 2)), 0, sind(T(225 / 2)), 0)
    av = quat_to_angleaxis(q)
    @test eltype(av) === T
    @test av.a ≈ 135 * pi / 180
    @test av.v ≈ [0, -1, 0]
end

@testset "Quaternion => Euler angle and axis (Float32)" begin
    T = Float32

    q = Quaternion(cosd(T(75 / 2)), 0, sind(T(75 / 2)), 0)
    av = quat_to_angleaxis(q)
    @test eltype(av) === T
    @test av.a ≈ T(75 * pi / 180)
    @test av.v ≈ [0, 1, 0]

    q = Quaternion(cosd(T(225 / 2)), 0, sind(T(225 / 2)), 0)
    av = quat_to_angleaxis(q)
    @test eltype(av) === T
    @test av.a ≈ T(135 * pi / 180)
    @test av.v ≈ [0, -1, 0]
end

@testset "Quaternion => Euler angle and axis (Special cases)" begin
    q = Quaternion{Float64}(1, 0, 0, 0)
    av = quat_to_angleaxis(q)
    @test eltype(av) == Float64
    @test av.a == 0
    @test av.v == [0, 0, 0]

    q = Quaternion{Float32}(-1, 0, 0, 0)
    av = quat_to_angleaxis(q)
    @test eltype(av) == Float32
    @test av.a == 0
    @test av.v == [0, 0, 0]
end
