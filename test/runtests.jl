VERSION >= v"0.7.0-DEV.2036" && using Test
VERSION <  v"0.7.0-DEV.2036" && using Base.Test

using ReferenceFrameRotations

# Available rotations.
rot_seq_array = [:XYX,
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
samples = 1000

@time @testset "Direction Cosine Matrices" begin
    include("./test_dcm.jl")
end
println("")

@time @testset "Quaternions" begin
    include("./test_quaternions.jl")
end
println("")

@time @testset "DCM <=> Euler Angles conversions" begin
    include("./test_conversion_dcm_euler_angles.jl")
end
println("")

@time @testset "DCM <=> Quaternions conversions" begin
    include("./test_conversion_dcm_quaternions.jl")
end
println("")

@time @testset "Euler Angles <=> Quaternion conversion" begin
    include("./test_conversion_euler_angles_quaternions.jl")
end
println("")

@time @testset "Euler Angle Axis <=> Quaternion conversions" begin
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

@time @testset "Compose rotations using DCMs" begin
    include("./test_compose_rotations_dcm.jl")
end
println("")

@time @testset "Compose rotations using Quaternions" begin
    include("./test_compose_rotations_quaternions.jl")
end
println("")
