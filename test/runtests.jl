using Test
using ReferenceFrameRotations
using LinearAlgebra
using Random
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

# Available rotations.
const valid_rot_seqs_2angles = [
    :XY,
    :XZ,
    :YX,
    :YZ,
    :ZX,
    :ZY,
]

const valid_rot_seqs = [
    :XYX,
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
    :ZYZ
]

# Define the function `isapprox` for `EulerAngleAxis` to make the comparison
# easier.
function isapprox(x::EulerAngleAxis, y::EulerAngleAxis; keys...)
    a = isapprox(x.a, y.a; keys...)
    v = isapprox(x.v, y.v; keys...)

    return a && v
end

# Define the function `isapprox` for `EulerAngles` to make the comparison
# easier.
function isapprox(x::EulerAngles, y::EulerAngles; keys...)
    a1 = isapprox(x.a1, y.a1; keys...)
    a2 = isapprox(x.a2, y.a2; keys...)
    a3 = isapprox(x.a3, y.a3; keys...)
    r  = x.rot_seq == y.rot_seq

    return a1 && a2 && a3 && r
end

# Add `verbose = true` option to testsets if Julia version is 1.6 or higher.
macro addverbose(expr)
    if VERSION ≥ v"1.6.0"
        if (expr.head == :macrocall) &&
            (expr.args[1] == Symbol("@testset")) &&
            (length(expr.args) ≥ 4)
            expr.args = vcat(
                expr.args[1:3],
                Expr(:(=), :verbose, true),
                expr.args[4:end]
            )
        end
    end

    return expr
end

@time @addverbose @testset "Direction cosine matrices" begin
    include("./dcm/misc.jl")
    include("./dcm/kinematics.jl")
    include("./dcm/orthonormalize.jl")
end
println("")

@time @addverbose @testset "Euler angle and axis" begin
    include("./angleaxis/functions.jl")
    include("./angleaxis/operations.jl")
end
println("")

@time @addverbose @testset "Euler angles" begin
    include("./angle/functions.jl")
    include("./angle/operations.jl")
end
println("")

@time @addverbose @testset "Quaternions" begin
    include("./quaternion/constructors.jl")
    include("./quaternion/functions.jl")
    include("./quaternion/julia_api.jl")
    include("./quaternion/kinematics.jl")
    include("./quaternion/operations.jl")
end
println("")

@time @addverbose @testset "Conversions" begin
    include("./conversions/angle_to_angle.jl")
    include("./conversions/angle_to_angleaxis.jl")
    include("./conversions/angle_to_dcm.jl")
    include("./conversions/angle_to_quat.jl")
    include("./conversions/angle_to_rot.jl")
    include("./conversions/angleaxis_to_angle.jl")
    include("./conversions/angleaxis_to_dcm.jl")
    include("./conversions/angleaxis_to_quat.jl")
    include("./conversions/api.jl")
    include("./conversions/dcm_to_angleaxis.jl")
    include("./conversions/dcm_to_angle.jl")
    include("./conversions/dcm_to_quaternion.jl")
    include("./conversions/quaternion_to_angle.jl")
    include("./conversions/quaternion_to_angleaxis.jl")
    include("./conversions/quaternion_to_dcm.jl")
end
println("")

@time @addverbose @testset "Compose rotations" begin
    include("./compose_rotations.jl")
end
println("")

@time @addverbose @testset "Invert rotations" begin
    include("./inv_rotations.jl")
end
println("")

@time @addverbose @testset "Random rotations" begin
    include("./random.jl")
end
println("")
