################################################################################
#                                 Quaternions
################################################################################

import Base: +, -, *, /, conj, copy, eye, getindex, inv, imag, norm, real, show
import Base: zeros

export dquat, quat2angle, quat2angleaxis, quat2dcm, vect

################################################################################
#                                 Initializers
################################################################################

"""
### function Quaternion(q0::Number, q1::Number, q2::Number, q3::Number)

Create the following quaternion:

    q0 + q1.i + q2.j + q3.k

##### Args

* q0: Real part of the quaternion.
* q1: X component of the quaternion vectorial part.
* q2: Y component of the quaternion vectorial part.
* q3: Z component of the quaternion vectorial part.

##### Returns

The new quaternion.

"""

function Quaternion(q0::Number, q1::Number, q2::Number, q3::Number)
    (q0p, q1p, q2p, q3p) = promote(q0,q1,q2,q3)
    Quaternion(q0p,q1p,q2p,q3p)
end

"""
### function Quaternion(v::Vector{T}) where T<:Real

If the vector `v` has 3 components, then create a quaternion in which the real
part is `0` and the vectorial or imaginary part has the same components of the
vector `v`. In other words:

    q = 0 + v[1].i + v[2].j + v[3].k

Otherwise, if the vector `v` has 4 components, then create a quaternion in which
the elements match those of the input vector:

    q = v[1] + v[2].i + v[3].j + v[4].k

##### Args

* v: Input vector. It must have three or four components.

##### Returns

If `v` has three components, then it returns the quaternion in which the real
part is `0` and the imaginary part is `v`. Otherwise, it returns the quaternion
with real part `v[1]` and imaginary part `v[2:4]`.

"""

function Quaternion(v::Vector{T}) where T<:Real
    # The vector must have 3 or 4 components.
    if length(v) != 3 && length(v) != 4
        throw(ArgumentError("The input vector must have 3 or 4 components."))
    end

    if length(v) == 3
        Quaternion{T}(zero(T), v[1], v[2], v[3])
    else
        Quaternion{T}(v[1], v[2], v[3], v[4])
    end
end

"""
### function Quaternion(r::T, v::Vector{T}) where T<:Real

Create a quaternion with real part `r` and vectorial or imaginary part `v`.

##### Args

* r: Real part.
* v: Vectorial or imaginary part.

##### Returns

The quaternion `r + v[1].i + v[2].j + v[3].k`.

"""

function Quaternion(r::T, v::Vector{T}) where T<:Real
    Quaternion(r, v[1], v[2], v[3])
end

################################################################################
#                                  Operations
################################################################################

# Operation: +
# ==============================================================================

"""
### @inline function +(qa::Quaternion, qb::Quaternion)

Sum the quaternion `qa` with the quaternion `qb`.

##### Args

* qa: First operand of the sum.
* qb: Second operand of the sum.

##### Returns

The quaternion `qa + qb`.

"""

@inline function +(qa::Quaternion, qb::Quaternion)
    Quaternion(qa.q0 + qb.q0, qa.q1 + qb.q1, qa.q2 + qb.q2, qa.q3 + qb.q3)
end

# Operation: -
# ==============================================================================

"""
### @inline function -(qa::Quaternion, qb::Quaternion)

Subtract quaternion `qb` from quaternion `qa`.

##### Args

* qa: First operand of the subtraction.
* qb: Second operand of the subtraction.

##### Returns

The quaternion `qa - qb`.

"""

@inline function -(qa::Quaternion, qb::Quaternion)
    Quaternion(qa.q0 - qb.q0, qa.q1 - qb.q1, qa.q2 - qb.q2, qa.q3 - qb.q3)
end

# Operation: *
# ==============================================================================

"""
### @inline function *(λ::Number, q::Quaternion{T2})

Multiply the quaternion `q` by the scalar `λ`.

##### Args

* λ: Scalar.
* q: Quaternion.

##### Returns

The quaternion `λ*q`.

"""

@inline function *(λ::Number, q::Quaternion)
    Quaternion(λ*q.q0, λ*q.q1, λ*q.q2, λ*q.q3)
end

"""
### @inline function *(q::Quaternion, λ::Number)

Multiply the quaternion `q` by the scalar `λ`.

##### Args

* q: Quaternion.
* λ: Scalar.

##### Returns

The quaternion `q*λ`.

"""

@inline function *(q::Quaternion, λ::Number)
    Quaternion(λ*q.q0, λ*q.q1, λ*q.q2, λ*q.q3)
end

"""
### @inline function *(q1::Quaternion, q2::Quaternion)

Compute the multiplication `q1*q2`.

##### Args

* q1: First operand of the multiplication.
* q2: Second operand of the multiplication.

##### Returns

The quaternion `q1*q2`.

"""

@inline function *(q1::Quaternion, q2::Quaternion)
    Quaternion(q1.q0*q2.q0 - q1.q1*q2.q1 - q1.q2*q2.q2 - q1.q3*q2.q3,
               q1.q0*q2.q1 + q1.q1*q2.q0 + q1.q2*q2.q3 - q1.q3*q2.q2,
               q1.q0*q2.q2 - q1.q1*q2.q3 + q1.q2*q2.q0 + q1.q3*q2.q1,
               q1.q0*q2.q3 + q1.q1*q2.q2 - q1.q2*q2.q1 + q1.q3*q2.q0)
end

"""
### @inline function *(v::AbstractVector, q::Quaternion)

Compute the multiplication `v*q` in which `v` is a quaternion with real part
`0` and vectorial/imaginary part `v`.

##### Args

* v: Imaginary part of the quaternion that is the first operand of the
     multiplication.
* q: Second operand of the multiplication.

##### Returns

The quaternion `v*q`.

"""

@inline function *(v::AbstractVector, q::Quaternion)
    Quaternion(-v[1]*q.q1 - v[2]*q.q2 - v[3]*q.q3,
               +v[1]*q.q0 + v[2]*q.q3 - v[3]*q.q2,
               -v[1]*q.q3 + v[2]*q.q0 + v[3]*q.q1,
               +v[1]*q.q2 - v[2]*q.q1 + v[3]*q.q0)
end

"""
### @inline function *(q::Quaternion, v::AbstractVector)

Compute the multiplication `q*v` in which `v` is a quaternion with real part
`0` and vectorial/imaginary part `v`.

##### Args

* q: First operand of the multiplication.
* v: Imaginary part of the quaternion that is the second operand of the
     multiplication.

##### Returns

The quaternion `q*v`.

"""
@inline function *(q::Quaternion, v::AbstractVector)
    Quaternion(           - q.q1*v[1] - q.q2*v[2] - q.q3*v[3],
               q.q0*v[1]              + q.q2*v[3] - q.q3*v[2],
               q.q0*v[2] - q.q1*v[3]              + q.q3*v[1],
               q.q0*v[3] + q.q1*v[2] - q.q2*v[1]             )
end

# Operation: /
# ==============================================================================

"""
### @inline function /(λ::Number, q::Quaternion)

Compute the division `λ/q`.

##### Args

* λ: First operand of the division (scalar).
* q: Second operand of the division (quaternion).

##### Returns

The quaternion `λ/q`.

"""

@inline function /(λ::Number, q::Quaternion)
    # Compute `λ*(1/q)`.
    norm_q = q.q0*q.q0 + q.q1*q.q1 + q.q2*q.q2 + q.q3*q.q3
    Quaternion(λ*q.q0/norm_q, -λ*q.q1/norm_q, -λ*q.q2/norm_q, -λ*q.q3/norm_q)
end

"""
### @inline function /(q::Quaternion{T1}, λ::T1) where T1<:Real where T2<:Real

Compute the division `q/λ`.

##### Args

* q: First operand of the division (quaternion).
* λ: Second operand of the division (scalar).

##### Returns

The quaternion `q/λ`.

"""

@inline function /(q::Quaternion{T1}, λ::T2) where T1<:Real where T2<:Real
    q*(1/λ)
end

# Operation: [:]
# ==============================================================================

"""
### @inline function getindex(q::Quaternion{T}, ::Colon) where T<:Real

Transform the quaternion into a 4x1 vector of type `T`.

##### Args

* q: Quaternion.

##### Returns

A 4x1 vector of type `T` with the elements of the quaternion.

"""

@inline function getindex(q::Quaternion{T}, ::Colon) where T<:Real
    [q.q0;q.q1;q.q2;q.q3]
end

################################################################################
#                                  Functions
################################################################################

"""
### @inline function conj(q::Quaternion{T}) where T<:Real

Compute the complex conjugate of the quaternion `q`.

##### Args

* q: Quaternion.

##### Returns

The complex conjugate of the quaternion `q`: `q0 - q1.i - q2.j - q3.k`.

"""

@inline function conj(q::Quaternion)
    # Compute the complex conjugate of the quaternion.
    Quaternion(q.q0, -q.q1, -q.q2, -q.q3)
end

"""
### @inline function copy(q::Quaternion{T}) where T<:Real

Create a copy of the quaternion `q`.

##### Args

* q: Quaternion that will be copied.

##### Returns

The copy of the quaternion.

"""

@inline function copy(q::Quaternion{T}) where T<:Real
    Quaternion{T}(q.q0, q.q1, q.q2, q.q3)
end

"""
### function eye(::Type{Quaternion{T}}) where T<:Real

Create the identity quaternion (`1 + 0.i + 0.j + 0.k`) of type `T`.

##### Args

* Quaternion{T}, where `T` is the desired type.

##### Returns

The identity quaternion of type `T`.

##### Example

    eye(Quaternion{Float64})
    eye(Quaternion{Float32})

"""

function eye(::Type{Quaternion{T}}) where T<:Real
    Quaternion{T}(one(T),zero(T),zero(T),zero(T))
end

"""
### function eye(::Type{Quaternion})

Create the identity quaternion (`1 + 0.i + 0.j + 0.k`) of type `Float64`.

##### Args

* Quaternion (no type specified).

##### Returns

The identity quaternion of type `Float64`.

"""

function eye(::Type{Quaternion})
    Quaternion{Float64}(1.0,0.0,0.0,0.0)
end

"""
### function eye(q::Quaternion{T}) where T<:Real

Create the identity quaternion (`1 + 0.i + 0.j + 0.k`) with the same type of
another quaternion `q`.

##### Args

* q: A quaternion of type `T`.

##### Returns

The identity quaternion of type `T`.

"""

function eye(q::Quaternion{T}) where T<:Real
    eye(Quaternion{T})
end

"""
### @inline function imag(q::Quaternion{T}) where T<:Real

Return the vectorial or imaginary part of the quaternion represented by a 3x1
vector.

##### Args

* q: Quaterion.

##### Returns

The following vector: `[q1; q2; q3]`.

"""

@inline function imag(q::Quaternion{T}) where T<:Real
    Vector{T}([q.q1; q.q2; q.q3])
end

"""
### function inv(q::Quaternion{T}) where T<:Real

Compute the inverse of the quaternion `q`.

##### Args

* q: Quaternion.

##### Returns

Inverse of the quaternion `q`.

"""

@inline function inv(q::Quaternion{T}) where T<:Real
    # Compute the inverse of the quaternion.
    norm_q = q.q0*q.q0 + q.q1*q.q1 + q.q2*q.q2 + q.q3*q.q3
    Quaternion(q.q0/norm_q, -q.q1/norm_q, -q.q2/norm_q, -q.q3/norm_q)
end

"""
### @inline function norm(q::Quaternion)

Compute the Euclidean norm of the quaternion `q`.

##### Args

* q: Quaternion.

##### Returns

The Euclidean norm of `q`.

"""

@inline function norm(q::Quaternion)
    sqrt(q.q0*q.q0 + q.q1*q.q1 + q.q2*q.q2 + q.q3*q.q3)
end

"""
### @inline function real(q::Quaternion)

Return the real part of the quaternion `q`.

##### Args

* q: Quaternion.

##### Returns

The scalar `q0`.

"""

@inline function real(q::Quaternion)
    q.q0
end

"""
### @inline function vect(q::Quaternion{T}) where T<:Real

Return the vectorial or imaginary part of the quaternion represented by a 3x1
vector.

##### Args

* q: Quaterion.

##### Returns

The following vector: `[q1; q2; q3]`.

"""

@inline function vect(q::Quaternion{T}) where T<:Real
    Vector{T}([q.q1; q.q2; q.q3])
end

"""
### function zeros(::Type{Quaternion{T}}) where T<:Real

Create the null quaternion (`0 + 0.i + 0.j + 0.k`) of type `T`.

##### Args

* Quaternion{T}, where `T` is the desired type.

##### Returns

The null quaternion of type `T`.

"""

function zeros(::Type{Quaternion{T}}) where T<:Real
    Quaternion{T}(zero(T),zero(T),zero(T),zero(T))
end

"""
### function zeros(::Type{Quaternion})

Create the null quaternion (`0 + 0.i + 0.j + 0.k`) of type `Float64`.

##### Args

* Quaternion (no type specified).

##### Returns

The null quaternion of type `Float64`.

"""

function zeros(::Type{Quaternion})
    Quaternion{Float64}(0.0,0.0,0.0,0.0)
end

"""
### function zeros(q::Quaternion{T}) where T<:Real

Create the null quaternion (`0 + 0.i + 0.j + 0.k`) with the same type of another
quaternion `q`.

##### Args

* q: A quaternion of type `T`.

##### Returns

The null quaternion of type `T`.

"""

function zeros(q::Quaternion{T}) where T<:Real
    zeros(Quaternion{T})
end

################################################################################
#                                      IO
################################################################################

"""
### function show(io::IO, q::Quaternion{T}) where T<:Real

Print the quaternion `q` to the stream `io`.

##### Args

* io: Stream that will be used to print the quaternion.
* q: The quaternion that will be printed.

"""

function show(io::IO, q::Quaternion{T}) where T<:Real
    println(io, "Quaternion{$(T)}:")

    # Get the absolute values.
    aq0 = abs(q.q0)
    aq1 = abs(q.q1)
    aq2 = abs(q.q2)
    aq3 = abs(q.q3)

    # Get the signs.
    sq0 = (q.q0 >= 0) ? "+" : "-"
    sq1 = (q.q1 >= 0) ? "+" : "-"
    sq2 = (q.q2 >= 0) ? "+" : "-"
    sq3 = (q.q3 >= 0) ? "+" : "-"

    print(io, "  $(sq0) $(aq0) $(sq1) $(aq1).i $(sq2) $(aq2).j $(sq3) $(aq3).k")

    nothing
end

################################################################################
#                                 Conversions
################################################################################

# Direction Cosine Matrix
# ==============================================================================

"""
### function quat2dcm(q::Quaternion)

Convert the quaternion `q` to a Direction Cosine Matrix.

##### Args

* q: Quaternion.

##### Returns

The Direction Cosine Matrix.

"""

function quat2dcm(q::Quaternion)
    # Auxiliary variables.
    q0 = q.q0
    q1 = q.q1
    q2 = q.q2
    q3 = q.q3

    SMatrix{3,3}(q0^2+q1^2-q2^2-q3^2,   2(q1*q2+q0*q3)   ,   2(q1*q3-q0*q2),
                   2(q1*q2-q0*q3)   , q0^2-q1^2+q2^2-q3^2,   2(q2*q3+q0*q1),
                   2(q1*q3+q0*q2)   ,   2(q2*q3-q0*q1)   , q0^2-q1^2-q2^2+q3^2)'
end

# Euler Angle and Axis
# ==============================================================================

"""
### function quat2angleaxis(q::Quaternion{T}) where T<:Real

Convert the quaternion `q` to a Euler angle and axis representation.

##### Args

* q: The quaternion that will be converted.

##### Returns

The Euler angle and axis (see `EulerAngleAxis`).

##### Remarks

This function will not fail if the quaternion norm is not 1. However, the
meaning of the results will not be defined, because the input quaternion does
not represent a 3D rotation. The user must handle such situations.

"""

function quat2angleaxis(q::Quaternion{T}) where T<:Real
    a = atan2( norm(vect(q)), q.q0 )*2
    v = vect(q)/sin(a/2)

    # TODO: Change this when the functions of Euler Angle and Axis are defined.
    EulerAngleAxis(a, v)
end

# Euler Angles
# ==============================================================================

"""
### function quat2angle(q::Quaternion, rot_seq::AbstractString="ZYX") where T<:Real

Convert the quaternion `q` to Euler Angles given a rotation sequence `rot_seq`.

##### Args

* q: Quaternion.
* rot_seq: Rotation sequence.

##### Returns

The Euler angles (see `EulerAngles`).

"""
function quat2angle(q::Quaternion{T},
                    rot_seq::AbstractString="ZYX") where T<:Real
    # TODO: This function calls uses `angle2dcm` to convert the quaternion to a
    # Direction Cosine Matrix. It **must** be rewritten to avoid this
    # intermediate step to increase the performance.

    # Convert the quaternion to DCM.
    dcm = quat2dcm(q)

    # Convert the DCM to the Euler Angles.
    dcm2angle(dcm, rot_seq)
end

################################################################################
#                                  Kinematics
################################################################################

"""
### function dquat(qba::Quaternion{T1}, wba_b::Vector{T2})

Compute the time-derivative of the quaternion `qba` that rotates a reference
frame `a` into alignment to the reference frame `b` in which the angular
velocity of `b` with respect to `a`, and represented in `b`, is `wba_b`.

##### Args

* qba: Quaternion that rotates the reference frame `a` into alignment with the
       reference frame `b`.
* wba_b: Angular velocity of the reference frame `a` with respect to the
         reference frame `b` represented in the reference frame `b`.

##### Returns

The quaternion with the time-derivative of `qba`.

"""

function dquat(qba::Quaternion{T1},
               wba_b::Vector{T2}) where T1<:Real where T2<:Real
    # Auxiliary variable.
    w = wba_b

    # Check the dimensions.
    if length(wba_b) != 3
        throw(ArgumentError("The angular velocity vector must have three components."))
    end

    Ωba_b = T2[zero(T2)  -w[1]    -w[2]    -w[3]  ;
                +w[1]   zero(T2)  +w[3]    -w[2]  ;
                +w[2]    -w[3]   zero(T2)  +w[1]  ;
                +w[3]    +w[2]    -w[1]   zero(T2);]

    # Return the time-derivative.
    Quaternion((Ωba_b/2)*qba[:])
end
