using Test
using ReferenceFrameRotations
using LinearAlgebra
using StaticArrays

import Base: isapprox

# Define the function `isapprox` for `EulerAngleAxis` to make the comparison
# easier.
function isapprox(x::EulerAngleAxis, y::EulerAngleAxis; keys...)
    a = isapprox(x.a, y.a; keys...)
    v = isapprox(x.v, y.v; keys...)

    a && v
end

# Define the function `isapprox` for `EulerAngles` to make the comparison
# easier.
function isapprox(x::EulerAngles, y::EulerAngles; keys...)
    a1 = isapprox(x.a1, y.a1; keys...)
    a2 = isapprox(x.a2, y.a2; keys...)
    a3 = isapprox(x.a3, y.a3; keys...)
    r  = x.rot_seq == y.rot_seq

    a1 && a2 && a3 && r
end

# Available rotations.
const rot_seq_array = [:XYX,
                       :XYZ,
                       :XZX,
                       :XZY,
                       :YXY,
                       :YXZ,
                       :YZX,
                       :YZY,
                       :ZXY,
                       :ZXZ,
                       :ZYX,
                       :ZYZ]

# Number of samples.
const samples = 1000

@time @testset "Direction Cosine Matrices" begin
    include("./test_dcm.jl")
end
println("")

@time @testset "Euler Angles" begin
    include("./test_euler_angles.jl")
end
println("")

@time @testset "Euler Angle and Axis" begin
    include("./test_euler_angle_axis.jl")
end
println("")

@time @testset "Quaternions" begin
    include("./test_quaternions.jl")
end
println("")

@time @testset "DCM <=> Euler Angle and Axis" begin
    include("./test_conversion_dcm_euler_angle_axis.jl")
end
println("")

@time @testset "DCM <=> Euler Angles" begin
    include("./test_conversion_dcm_euler_angles.jl")
end
println("")

@time @testset "DCM <=> Quaternions" begin
    include("./test_conversion_dcm_quaternions.jl")
end
println("")

@time @testset "Euler Angles <=> Euler Angle and Axis" begin
    include("./test_conversion_euler_angles_euler_angle_axis.jl")
end
println("")

@time @testset "Euler Angles <=> Euler Angles" begin
    include("./test_conversion_euler_angles_euler_angles.jl")
end
println("")

@time @testset "Euler Angles <=> Quaternion" begin
    include("./test_conversion_euler_angles_quaternions.jl")
end
println("")

@time @testset "Euler Angle Axis <=> Quaternion" begin
    include("./test_conversion_euler_angle_axis_quaternions.jl")
end
println("")

@time @testset "Kinematics using DCMs" begin
    include("./test_kinematics_dcm.jl")
end
println("")

@time @testset "Kinematics using Quaternions" begin
    include("./test_kinematics_quaternions.jl")
end
println("")

@time @testset "Compose rotations" begin
    include("./test_compose_rotations.jl")
end
println("")
