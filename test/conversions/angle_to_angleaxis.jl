# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to conversion from Euler angles to Euler angle and axis.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/conversions/angle_to_angleaxis.jl
# =============================================

# Functions: angle_to_angleaxis
# -----------------------------

@testset "Euler angles => Euler angle and axis" begin
    for T in (Float32, Float64)
        # We do not need comprehensive test here because `angle_to_angleaxis`
        # first converts the Euler angles to DCM and then to Euler angle and
        # axis. Those two operations are already heavily tested.

        ea = EulerAngles(deg2rad(T(45)), 0, 0, :XYZ)
        av = angle_to_angleaxis(ea)
        @test eltype(av) === T
        @test av.a ≈ deg2rad(T(45))
        @test av.v ≈ T[1, 0, 0]

        ea = EulerAngles(deg2rad(T(45)), 0, 0, :YXZ)
        av = angle_to_angleaxis(ea)
        @test eltype(av) === T
        @test av.a ≈ deg2rad(T(45))
        @test av.v ≈ T[0, 1, 0]

        ea = EulerAngles(deg2rad(T(45)), 0, 0, :ZXY)
        av = angle_to_angleaxis(ea)
        @test eltype(av) === T
        @test av.a ≈ deg2rad(T(45))
        @test av.v ≈ T[0, 0, 1]

        ea = EulerAngles(0, deg2rad(T(45)), 0, :ZXY)
        av = angle_to_angleaxis(ea)
        @test eltype(av) === T
        @test av.a ≈ deg2rad(T(45))
        @test av.v ≈ T[1, 0, 0]
    end
end
