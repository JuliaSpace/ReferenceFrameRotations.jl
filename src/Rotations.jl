VERSION >= v"0.4.0-dev+6521" && __precompile__()

module Rotations

export EulerAngles, Quaternion

import Base: sin, cos

################################################################################
#                                    Types
################################################################################

"""
### type EulerAngles{T<:Real}

The definition of Euler Angles, which is composed of three angles `a1`, `a2`,
and `a3` together with a rotation sequence `rot_seq`. The latter is provided by
a string with three characters, each one indicating the rotation axis of the
corresponding angle.
"""

type EulerAngles{T<:Real}
    a1::T
    a2::T
    a3::T
    rot_seq::AbstractString
end


"""
### type Quaternion{T<:Real}

The definition of the quaternion. It has four values of the same type. The
quaternion representation is:

    q0 + q1.i + q2.j + q3.k
"""

type Quaternion{T<:Real}
    q0::T
    q1::T
    q2::T
    q3::T
end


################################################################################
#                                   Includes
################################################################################

include("exceptions.jl")

include("DCM.jl")
include("euler_angles.jl")
include("quaternion.jl")

end # module
