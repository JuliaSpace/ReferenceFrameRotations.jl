VERSION >= v"0.4.0-dev+6521" && __precompile__()

module ReferenceFrameRotations

export DCM, EulerAngleAxis, EulerAngles, Quaternion

import Base: sin, cos

importall StaticArrays

################################################################################
#                                    Types
################################################################################

"""
The Direction Cosine Matrice is a `SMatrix{3,3}`, which is a 3x3 static matrix.

"""
DCM{T} = SMatrix{3,3,T}

"""
### struct EulerAngles{T<:Real}

The definition of Euler Angles, which is composed of three angles `a1`, `a2`,
and `a3` together with a rotation sequence `rot_seq`. The latter is provided by
a symbol with three characters, each one indicating the rotation axis of the
corresponding angle (for example, `:ZYX`).

"""
struct EulerAngles{T<:Real}
    a1::T
    a2::T
    a3::T
    rot_seq::Symbol
end

"""
### struct EulerAngleAxis{T<:Real}

The definition of Euler Angle and Axis to represent a 3D rotation.

* `a` is the Euler angle [rad].
* `v` is a unitary vector aligned with the Euler axis.

"""
struct EulerAngleAxis{T<:Real}
    a::T
    v::Vector{T}
end

"""
### struct Quaternion{T<:Real}

The definition of the quaternion. It has four values of the same type. The
quaternion representation is:

    q0 + q1.i + q2.j + q3.k

"""
struct Quaternion{T<:Real}
    q0::T
    q1::T
    q2::T
    q3::T
end

################################################################################
#                                   Includes
################################################################################

include("exceptions.jl")

include("compose_rotations.jl")
include("DCM.jl")
include("euler_angle_axis.jl")
include("euler_angles.jl")
include("quaternion.jl")

end # module
