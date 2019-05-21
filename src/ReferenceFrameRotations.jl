module ReferenceFrameRotations

export DCM, EulerAngleAxis, EulerAngles, Quaternion

import Base: +, -, *, /, \, conj, copy, display, getindex, inv, imag, real, show
import Base: zeros
import LinearAlgebra: norm

using Crayons
using LinearAlgebra
using Printf
using StaticArrays

# Re-export `I` from LinearAlgebra.
export I

################################################################################
#                                    Types
################################################################################

"""
The Direction Cosine Matrix of type `T` is a `SMatrix{3,3,T,9}`, which is a 3x3
static matrix of type `T`.

"""
DCM{T} = SMatrix{3,3,T,9}

"""
    struct EulerAngles{T}

The definition of Euler Angles, which is composed of three angles `a1`, `a2`,
and `a3` together with a rotation sequence `rot_seq`. The latter is provided by
a symbol with three characters, each one indicating the rotation axis of the
corresponding angle (for example, `:ZYX`). The valid values for `rot_seq` are:

* `:XYX`, `:XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`,
  `:ZXZ`, `:ZYX`, and `ZYZ`.

# Constructor

    function EulerAngles(a1::T1, a2::T2, a3::T3, rot_seq::Symbol = :ZYX) where {T1,T2,T3}

Create a new instance of `EulerAngles` with the angles `a1`, `a2`, and `a3` and
the rotation sequence `rot_seq`. The type will be inferred from `T1`, `T2`, and
`T3`. If `rot_seq` is not provided, then it defaults to `:ZYX`.

"""
struct EulerAngles{T}
    a1::T
    a2::T
    a3::T
    rot_seq::Symbol
end

function EulerAngles(a1::T1, a2::T2, a3::T3, rot_seq::Symbol = :ZYX) where
    {T1,T2,T3}

    T = promote_type(T1,T2,T3)
    EulerAngles(T(a1), T(a2), T(a3), rot_seq)
end

"""
    struct EulerAngleAxis{T}

The definition of Euler Angle and Axis to represent a 3D rotation.

# Fields

* `a`: The Euler angle [rad].
* `v`: The unitary vector aligned with the Euler axis.

# Constructor

    function EulerAngleAxis(a::T1, v::AbstractVector{T2}) where {T1,T2}

Create an Euler Angle and Axis representation structure with angle `a` [rad] and
vector `v`. Notice that the vector `v` will not be normalized. The type of the
returned structure will be selected according to the input types.

"""
struct EulerAngleAxis{T}
    a::T
    v::SVector{3,T}

    EulerAngleAxis(a::T,v::SVector{3,T}) where T<:Number = new{T}(a,v)
end

function EulerAngleAxis(a::T1, v::AbstractVector{T2}) where {T1,T2}
    (length(v) != 3) && error("The vector `v` must have 3 dimensions.")
    T = promote_type(T1,T2)
    EulerAngleAxis(T(a), SVector{3,T}(v))
end

"""
### struct Quaternion{T}

The definition of the quaternion. It has four values of type `T`. The
quaternion representation is:

    q0 + q1.i + q2.j + q3.k

"""
struct Quaternion{T}
    q0::T
    q1::T
    q2::T
    q3::T
end

################################################################################
#                                 Deprecations
################################################################################

@deprecate eye(::Type{Quaternion{T}}) where T Quaternion{T}(I)
@deprecate eye(::Type{Quaternion}) where T Quaternion{Float64}(I)
@deprecate eye(q::Quaternion{T}) where T Quaternion(I,q)

################################################################################
#                                  Constants
################################################################################

# Pre-defined crayons.
const _reset_crayon = Crayon(reset = true)
const _crayon_bold  = crayon"bold"
const _crayon_g     = crayon"bold green"
const _crayon_u     = crayon"bold blue"
const _crayon_y     = crayon"bold yellow"

# Escape sequences related to the crayons.
const _b = _crayon_bold
const _d = _reset_crayon
const _g = _crayon_g
const _y = _crayon_y
const _u = _crayon_u

################################################################################
#                                   Includes
################################################################################

include("compose_rotations.jl")
include("DCM.jl")
include("euler_angle_axis.jl")
include("euler_angles.jl")
include("inv_rotations.jl")
include("quaternion.jl")

include("deprecations.jl")

end # module
