## Description #############################################################################
#
# Definition of types and structures.
#
############################################################################################

export DCM, EulerAngles, EulerAngleAxis, Quaternion, CRP, MRP, ReferenceFrameRotation

"""
    struct DCM{T}

Store a Direction Cosine Matrix (DCM) whose nine elements have type `T`.

# Fields

- `data::NTuple{9, T}`: Matrix elements in column-major order.

# Examples

```jldoctest
julia> DCM(1.0I)
DCM{Float64}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0

julia> DCM([1 0 0; 0 -1 0; 0 0 -1])
DCM{Int64}:
 1   0   0
 0  -1   0
 0   0  -1
```
"""
struct DCM{T} <: StaticMatrix{3, 3, T}
    data::NTuple{9, T}

    function DCM(x::NTuple{9, T}) where {T}
        return new{T}(x)
    end

    function DCM(x::NTuple{9, Any})
        T = StaticArrays.promote_tuple_eltype(x)
        return new{T}(StaticArrays.convert_ntuple(T, x))
    end

    function DCM{T}(x::NTuple{9, T}) where {T}
        return new{T}(x)
    end

    function DCM{T}(x::NTuple{9, Any}) where {T}
        return new{T}(StaticArrays.convert_ntuple(T, x))
    end
end

"""
    struct EulerAngles{T}

Store three Euler angles `a1`, `a2`, and `a3`
together with a rotation sequence `rot_seq`.

# Fields

- `a1::T`: First rotation [rad].
- `a2::T`: Second rotation [rad].
- `a3::T`: Third rotation [rad].
- `rot_seq::Symbol`: Rotation sequence.

!!! info

    `rot_seq` is provided by a symbol with three characters, each one indicating the
    rotation axis of the corresponding angle, *e.g.* `:ZYX`. The valid values for `rot_seq`
    are:

    - `:XYX`, `:XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`,
        `:ZXZ`, `:ZYX`, and `:ZYZ`.

# Examples

```jldoctest
julia> EulerAngles(pi / 2, pi / 4, -pi, :XYZ)
EulerAngles{Float64}:
  R(X) :  1.5708   rad  ( 90.0°)
  R(Y) :  0.785398 rad  ( 45.0°)
  R(Z) : -3.14159  rad  (-180.0°)
```
"""
struct EulerAngles{T}
    a1::T
    a2::T
    a3::T
    rot_seq::Symbol
end

"""
    EulerAngles(a1::Any, a2::Any, a3::Any, rot_seq::Symbol = :ZYX) -> EulerAngles

Construct Euler angles `a1`, `a2`, and `a3` [rad] with rotation sequence `rot_seq`.

!!! note

    This constructor does not validate `rot_seq`. Conversions require it to be one of the
    supported rotation sequences listed for [`EulerAngles`](@ref); otherwise, they throw an
    `ArgumentError`.
"""
function EulerAngles(a1::T1, a2::T2, a3::T3, rot_seq::Symbol = :ZYX) where {T1, T2, T3}
    T = promote_type(T1, T2, T3)

    return EulerAngles(T(a1), T(a2), T(a3), rot_seq)
end

"""
    struct EulerAngleConversion{R}

Enable conversion to Euler angles using the Julia API.
"""
struct EulerAngleConversion{R} end

function EulerAngles(rot_seq::Symbol)
    return EulerAngleConversion{rot_seq}
end

"""
    struct EulerAngleAxis{T}

Represent a 3D rotation with an Euler angle and axis.

# Fields

- `a::T`: The Euler angle [rad].
- `v::SVector{3, T}`: Vector aligned with the Euler axis; callers must provide a unit
    vector.

# Examples

```jldoctest
julia> EulerAngleAxis(pi / 3, [sqrt(2) / 2, sqrt(2) / 2, 0])
EulerAngleAxis{Float64}:
  Euler angle : 1.0472 rad  (60.0°)
  Euler axis  : [0.707107, 0.707107, 0.0]
```
"""
struct EulerAngleAxis{T}
    a::T
    v::SVector{3, T}

    EulerAngleAxis(a::T, v::SVector{3, T}) where {T <: Number} = new{T}(a, v)
end

"""
    EulerAngleAxis(a::Any, v::AbstractVector) -> EulerAngleAxis

Construct an Euler angle and axis from `a` [rad] and the three-component vector `v`.
Do not assume that `v` is normalized; this constructor does not normalize it, so callers
must provide a unit axis when a valid rotation representation is required.
"""
function EulerAngleAxis(a::T1, v::AbstractVector{T2}) where {T1, T2}
    (length(v) != 3) && error("The vector `v` must have 3 dimensions.")
    T = promote_type(T1, T2)

    return EulerAngleAxis(T(a), SVector{3, T}(v))
end

"""
    struct Quaternion{T}

Represent a quaternion with scalar-first components.

# Fields

- `q0::T`: Quaternion real part.
- `q1::T`: X component of the quaternion imaginary part.
- `q2::T`: Y component of the quaternion imaginary part.
- `q3::T`: Z component of the quaternion imaginary part.

!!! note

    The quaternion `q` in this structure is represented by:

        q = q0 + q1.i + q2.j + q3.k

# Example

```jldoctest
julia> Quaternion(cosd(45), sind(45), 0, 0)
Quaternion{Float64}:
  + 0.707107 + 0.707107⋅i + 0.0⋅j + 0.0⋅k
```
"""
struct Quaternion{T}
    q0::T
    q1::T
    q2::T
    q3::T
end

"""
    struct CRP{T}

Represent Classical Rodrigues Parameters (CRP).

# Fields

- `q1::T`: First dimensionless CRP component [-].
- `q2::T`: Second dimensionless CRP component [-].
- `q3::T`: Third dimensionless CRP component [-].

"""
struct CRP{T}
    q1::T
    q2::T
    q3::T
end

"""
    CRP(q1::Any, q2::Any, q3::Any) -> CRP

Construct CRP coordinates `q1`, `q2`, and `q3` [-] after promoting their types.
"""
function CRP(q1::T1, q2::T2, q3::T3) where {T1, T2, T3}
    T = promote_type(T1, T2, T3)
    return CRP{T}(T(q1), T(q2), T(q3))
end

"""
    struct MRP{T}

Represent Modified Rodrigues Parameters (MRP).

# Fields

- `q1::T`: First dimensionless MRP component [-].
- `q2::T`: Second dimensionless MRP component [-].
- `q3::T`: Third dimensionless MRP component [-].

"""
struct MRP{T}
    q1::T
    q2::T
    q3::T
end

"""
    MRP(q1::Any, q2::Any, q3::Any) -> MRP

Construct MRP coordinates `q1`, `q2`, and `q3` [-] after promoting their types.
"""
function MRP(q1::T1, q2::T2, q3::T3) where {T1, T2, T3}
    T = promote_type(T1, T2, T3)
    return MRP{T}(T(q1), T(q2), T(q3))
end

"""
    ReferenceFrameRotation

Represent the union of all supported rotation types.
"""
const ReferenceFrameRotation = Union{DCM, EulerAngles, EulerAngleAxis, Quaternion, CRP, MRP}
