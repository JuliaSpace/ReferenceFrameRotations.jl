################################################################################
#                                 Quaternions
################################################################################

import Base: +, -, *, /, ctranspose, conj, copy, inv, imag, norm, real, show

export quat2angle, quat2dcm, quat2dcm!, vect

################################################################################
#                                 Initializers
################################################################################

"""
### function Quaternion(v::Vector{T}) where T<:Real

Create a quaternion in which the real part is `0` and the vectorial or imaginary
part has the same components of the vector `v`. In other words:

   q = 0 + v[1].i + v[2].j + v[3].k

##### Args

* v: Input vector. It must have three components.

##### Returns

* The quaternion in which the real part is `0` and the imaginary part is `v`.

"""

function Quaternion(v::Vector{T}) where T<:Real
    # The vector must have 3 components.
    if length(v) != 3
        throw(ArgumentError("The input vector must have 3 components."))
    end

    Quaternion{T}(T(0), v[1], v[2], v[3])
end

"""
### function Quaternion(r::T, v::Vector{T}) where T<:Real

Create a quaternion with real part `r` and vectorial or imaginary part `v`.

##### Args

* r: Real part.
* v: Vectorial or imaginary part.

##### Returns

* The new quaternion that represents `r + v[1].i + v[2].j + v[3].k`.

"""

function Quaternion(r::T, v::Vector{T}) where T<:Real
    q    = Quaternion(v)
    q.q0 = r

    q
end

################################################################################
#                                  Operations
################################################################################

# Operation: +
# ==============================================================================

"""
### function +(qa::Quaternion{T1}, qb::Quaternion{T2}) where T1<:Real where T2<:Real

Sum quaternion `qa` with quaternion `qb`.

##### Args

* qa: First operator of the sum.
* qb: Second operator of the sum.

##### Returns

* A new quaternion that represents `qa + qb`.

"""

function +(qa::Quaternion{T1}, qb::Quaternion{T2}) where T1<:Real where T2<:Real
    # Sum `qa` and `qb`.
    Quaternion(qa.q0 + qb.q0, qa.q1 + qb.q1, qa.q2 + qb.q2, qa.q3 + qb.q3)
end

# Operation: -
# ==============================================================================

"""
### function -(qa::Quaternion{T1}, qb::Quaternion{T2}) where T1<:Real where T2<:Real

Subtract quaternion `qb` from quaternion `qa`.

##### Args

* qa: First operator of the subtraction.
* qb: Second operator of the subtraction.

##### Returns

* A new quaternion that represents `qa - qb`.

"""

function -(qa::Quaternion{T1}, qb::Quaternion{T2}) where T1<:Real where T2<:Real
    # Subtract `qb` from `qa`.
    Quaternion(qa.q0 - qb.q0, qa.q1 - qb.q1, qa.q2 - qb.q2, qa.q3 - qb.q3)
end

# Operation: *
# ==============================================================================

"""
### function *(λ::T1, q::Quaternion{T2}) where T1<:Real where T2

Multiply the quaternion `q` by the scalar `λ`.

##### Args

* λ: Scalar.
* q: Quaternion.

##### Returns

* A new quaternion that represents `λ.q`.

"""

function *(λ::T1, q::Quaternion{T2}) where T1<:Real where T2<:Real
    # Multiply all the components by the scalar λ.
    Quaternion(λ*q.q0, λ*q.q1, λ*q.q2, λ*q.q3)
end

"""
### function *(q::Quaternion{T1}, λ::T1) where T1<:Real where T2<:Real

Multiply the quaternion `q` by the scalar `λ`.

##### Args

* q: Quaternion.
* λ: Scalar.

##### Returns

* A new quaternion that represents `q.λ`.

"""

function *(q::Quaternion{T1}, λ::T2) where T1<:Real where T2<:Real
    λ*q
end

"""
### function *(q1::Quaternion{T1}, q2::Quaternion{T2}) where T1<:Real where T2<:Real

Compute the multiplication `q1.q2`.

##### Args

* q1: Quaternion (first operand).
* q2: Quaternion (second operand).

##### Returns

* A new quaternion that represents `q1.q2`.

"""

function *(q1::Quaternion{T1}, q2::Quaternion{T2}) where T1<:Real where T2<:Real
    # Get the real part of the quaternions.
    r1 = real(q1)
    r2 = real(q2)

    # Get the vectorial/imaginary part of the quaternions.
    v1 = vect(q1)
    v2 = vect(q2)

    # Obtain the new real part of the quaternion `q1*q2`.
    rr = r1*r2-dot(v1,v2)

    # Obtain the new vectorial/imaginary part of the quaternion `q1*q2`.
    vr = r1*v2 + r2*v1 + cross(v1,v2)

    # Create the new quaternion.
    Quaternion(rr,vr)
end

"""
### function *(v::Vector{T1}, q::Quaternion{T2}) where T1<:Real where T2<:Real

Compute the multiplication `v.q` in which `v` is a quaternion with real part
`0` and vectorial/imaginary part `v`.

##### Args

* v: Vector (first operand).
* q: Quaternion (second operand).

##### Returns

* A new quaternion that represents `v.q`.

"""

function *(v::Vector{T1}, q::Quaternion{T2}) where T1<:Real where T2<:Real
    Quaternion(v)*q
end

"""
### function *(q::Quaternion{T1}, v::Vector{T2}) where T1<:Real where T2<:Real

Compute the multiplication `q.v` in which `v` is a quaternion with real part
`0` and vectorial/imaginary part `v`.

##### Args

* q: Quaternion (first operand).
* v: Vector (second operand).

##### Returns

* A new quaternion that represents `q.v`.

"""
function *(q::Quaternion{T1}, v::Vector{T2}) where T1<:Real where T2<:Real
    q*Quaternion(v)
end

# Operation: /
# ==============================================================================

"""
### function /(λ::T1, q::Quaternion{T2}) where T1<:Real where T2

Compute the division `λ/q`.

##### Args

* λ: Scalar (first operand).
* q: Quaternion (second operand).

##### Returns

* A new quaternion that represents `λ/q`.

"""

function /(λ::T1, q::Quaternion{T2}) where T1<:Real where T2<:Real
    λ*inv(q)
end

"""
### function /(q::Quaternion{T1}, λ::T1) where T1<:Real where T2<:Real

Compute the division `q/λ`.

##### Args

* q: Quaternion (first operand).
* λ: Scalar (second operand).

##### Returns

* A new quaternion that represents `q/λ`.

"""

function /(q::Quaternion{T1}, λ::T2) where T1<:Real where T2<:Real
    q*(1/λ)
end

# Operation: ' (ctranspose)
# ==============================================================================

"""
### function transpose(q::Quaternion{T}) where T<:Real

For quaternions, the transpose operation will be defined as the inverse
operation. Hence, `q' = inv(q)`.

##### Args

* q: Quaternion.

##### Returns

* The inverse of the quaternion.

"""

function ctranspose(q::Quaternion{T}) where T<:Real
    inv(q)
end

################################################################################
#                                  Functions
################################################################################

"""
### function conj(q::Quaternion{T}) where T<:Real

Compute the complex conjugate of the quaternion `q`.

##### Args

* q: Quaternion.

##### Returns

* The complex conjugate of the quaternion `q`: `q0 - q1.i - q2.j - q3.k`.

"""

function conj(q::Quaternion{T}) where T<:Real
    # Compute the complex conjugate of the quaternion.
    Quaternion(q.q0, -q.q1, -q.q2, -q.q3)
end

"""
### function copy(q::Quaternion{T}) where T<:Real

Create a copy of the quaternion `q`.

##### Args

* q: Quaternion that will be copied.

##### Returns

* The copy of the quaternion.

"""

function copy(q::Quaternion{T}) where T<:Real
    Quaternion{T}(q.q0, q.q1, q.q2, q.q3)
end

"""
### function imag(q::Quaternion{T}) where T<:Real

Return the vectorial or imaginary part of the quaternion represented by a 3x1
vector.

##### Args

* q: Quaterion.

##### Returns

* The following vector: `[q1; q2; q3]`.

"""

function imag(q::Quaternion{T}) where T<:Real
    vect(q)
end

"""
### function inv(q::Quaternion{T}) where T<:Real

Compute the inverse of the quaternion `q`.

##### Args

* q: Quaternion.

##### Returns

* Inverse of the quaternion `q`.

"""

function inv(q::Quaternion{T}) where T<:Real
    # Compute the norm of the quaternion.
    norm_q = norm(q)

    # Compute the inverse of the quaternion.
    q_conj = conj(q)/norm_q
end

"""
### function norm(q::Quaternion{T}) where T<:Real

Compute the Euclidean norm of the quaternion.

##### Args

* q: Quaternion.

##### Returns

* The Euclidean norm of `q`.

"""

function norm(q::Quaternion{T}) where T<:Real
    sqrt( q.q0*q.q0 + q.q1*q.q1 + q.q2*q.q2 + q.q3*q.q3)
end

"""
### function real(q::Quaternion{T}) where T<:Real

Return the real part of the quaternion.

##### Args

* q: Quaternion.

##### Returns

* The scalar `q0`.

"""

function real(q::Quaternion{T}) where T<:Real
    q.q0
end

"""
### function vect(q::Quaternion{T}) where T<:Real

Return the vectorial or imaginary part of the quaternion represented by a 3x1
vector.

##### Args

* q: Quaterion.

##### Returns

* The following vector: `[q1; q2; q3]`.

"""

function vect(q::Quaternion{T}) where T<:Real
    Vector{T}([q.q1; q.q2; q.q3])
end

################################################################################
#                                      IO
################################################################################

"""
### function show(io::IO, q::Quaternion{T}) where T<:Real

Print the quaternion.

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
### function quat2dcm!(dcm::Matrix{T1}, q::Quaternion{T2})

Convert a quaternion to a Direction Cosine Matrix.

##### Args

* dcm: (OUTPUT) Pre-allocated Direction Cosine Matrix.
* q: Quaternion that will be converted.

##### Example

    q   = Quaternion(sqrt(2)/2, sqrt(2)/2, 0.0, 0.0)
    dcm = zeros(3,3)
    quat2dcm!(dcm,q)

"""

function quat2dcm!(dcm::Matrix{T1},
                   q::Quaternion{T2}) where T1<:Real where T2<:Real

    # Auxiliary variables.
    q0 = q.q0
    q1 = q.q1
    q2 = q.q2
    q3 = q.q3

    dcm[1,1] = q0^2+q1^2-q2^2-q3^2
    dcm[1,2] =   2(q1*q2+q0*q3)
    dcm[1,3] =   2(q1*q3-q0*q2)
    dcm[2,1] =   2(q1*q2-q0*q3)
    dcm[2,2] = q0^2-q1^2+q2^2-q3^2
    dcm[2,3] =   2(q2*q3+q0*q1)
    dcm[3,1] =   2(q1*q3+q0*q2)
    dcm[3,2] =   2(q2*q3-q0*q1)
    dcm[3,3] = q0^2-q1^2-q2^2+q3^2

    nothing
end

"""
### function quat2dcm(q::Quaternion{T}) where T<:Real

Convert a quaternion to a Direction Cosine Matrix.

##### Args

* q: Quaternion.

##### Returns

* The Direction Cosine Matrix.

"""

function quat2dcm(q::Quaternion{T}) where T<:Real
    dcm = zeros(T,3,3)
    quat2dcm!(dcm,q)
    dcm
end

# Euler Angles
# ==============================================================================

"""
### function quat2angle(q::Quaternion, rot_seq::AbstractString="ZYX") where T<:Real

Convert a quaternion to Euler Angles given a rotation sequence.

##### Args

* q: Quaternion.
* rot_seq: Rotation sequence.

##### Returns

* The Euler angles.

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

