using Test
using ReferenceFrameRotations
using LinearAlgebra
using StaticArrays

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
