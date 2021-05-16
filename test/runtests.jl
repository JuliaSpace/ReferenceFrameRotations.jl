using Test
using ReferenceFrameRotations
using LinearAlgebra
using StaticArrays

import Base: isapprox

################################################################################
#                             Auxiliary functions
################################################################################

# Function to uniformly sample an angle in [-π, π].
_rand_ang(T = Float64) = -T(π) + T(2π) * rand(T)

# Function to uniformly sample an angle in [-π / 2, +π / 2].
_rand_ang2(T = Float64) = -T(π) / 2 + T(π) * rand(T)

# Function to uniformly sample an angle in [0.1, 1.5].
_rand_ang3(T = Float64) = T(0.1) + T(1.4) * rand(T)

# Normalize angle between [-π, +π].
function _norm_ang(α::T) where T
    Tf = float(T)
    αr = mod(α, Tf(2π))  # Make sure α ∈ [0, 2π].
    if αr ≤ π
        return αr
    else
        return αr - Tf(2π)
    end
end

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

@time @testset "Direction cosine matrices" begin
    include("./dcm/create_rotation_matrix.jl")
    include("./dcm/kinematics.jl")
    include("./dcm/orthonormalize.jl")
end
println("")

@time @testset "Quaternions" begin
    include("./quaternion/constructors.jl")
    include("./quaternion/operations.jl")
end
println("")

@time @testset "Conversions" begin
    include("./conversions/dcm_to_angleaxis.jl")
    include("./conversions/dcm_to_euler_angles.jl")
    include("./conversions/dcm_to_quaternion.jl")
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
