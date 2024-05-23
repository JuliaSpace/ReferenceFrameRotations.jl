## Desription ##############################################################################
#
# Tests related to conversion from quaternions to Euler angle and axis.
#
############################################################################################

# == File: ./src/conversions/quaternion_to_angleaxis.jl ====================================

# -- Functions: quat_to_angleaxis ----------------------------------------------------------

@testset "Quaternion => Euler Angle and Axis" begin
    for T in (Float32, Float64)
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
end

@testset "Quaternion => Euler Angle and Axis (Special Cases)" begin
    for T in (Float32, Float64)
        q = Quaternion{T}(1, 0, 0, 0)
        av = quat_to_angleaxis(q)
        @test eltype(av) == T
        @test av.a == 0
        @test av.v == [0, 0, 0]
    end
end
