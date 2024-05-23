## Description #############################################################################
#
# Functions related to the quaternions.
#
############################################################################################

export dquat, norm, vect

############################################################################################
#                                       Constructors                                       #
############################################################################################

"""
    Quaternion(q0::T0, q1::T1, q2::T2, q3::T3) where {T0, T1, T2, T3}

Create the following quaternion:

    q0 + q1.i + q2.j + q3.k

in which:

- `q0` is the real part of the quaternion.
- `q1` is the X component of the quaternion vectorial part.
- `q2` is the Y component of the quaternion vectorial part.
- `q3` is the Z component of the quaternion vectorial part.

!!! note

    The quaternion type is obtained by promoting `T0`, `T1`, `T2`, and `T3`.

# Examples

```jldoctest
julia> Quaternion(1, 0, 0, 0)
Quaternion{Int64}:
  + 1 + 0⋅i + 0⋅j + 0⋅k

julia> Quaternion(1, 0, 0, 0.0)
Quaternion{Float64}:
  + 1.0 + 0.0⋅i + 0.0⋅j + 0.0⋅k
```

---

    Quaternion(v::AbstractVector)

If the vector `v` has 3 components, then create a quaternion in which the real part is `0`
and the vectorial or imaginary part has the same components of the vector `v`. In other
words:

    q = 0 + v[1].i + v[2].j + v[3].k

Otherwise, if the vector `v` has 4 components, then create a quaternion in which the
elements match those of the input vector:

    q = v[1] + v[2].i + v[3].j + v[4].k

!!! note

    If the length of `v` is not 3 or 4, then an error is thrown.

# Examples

```jldoctest
julia> Quaternion([0, cosd(45), sind(45)])
Quaternion{Float64}:
  + 0.0 + 0.0⋅i + 0.707107⋅j + 0.707107⋅k

julia> Quaternion([cosd(45), 0, sind(45), 0])
Quaternion{Float64}:
  + 0.707107 + 0.0⋅i + 0.707107⋅j + 0.0⋅k
```

---

    Quaternion(r::Number, v::AbstractVector)

Create a quaternion with real part `r` and vectorial or imaginary part `v`:

    r + v[1].i + v[2].j + v[3].k

!!! note

    The quaternion type is obtained by promoting the type of `r` and the elements of `v`.

# Examples

```jldoctest
julia> Quaternion(cosd(45), [0, sind(45), 0])
Quaternion{Float64}:
  + 0.707107 + 0.0⋅i + 0.707107⋅j + 0.0⋅k
```

---

    Quaternion(u::UniformScaling{T}) where T
    Quaternion{T}(u::UniformScaling) where T
    Quaternion(u::UniformScaling, Q::Quaternion{T}) where T

Create the quaternion `u.λ + 0.i + 0.j + 0.k`.

If a quaternion is passed as in the third signature, then the new quaternion will have the
same type.

# Examples

```jldoctest
julia> Quaternion(I)
Quaternion{Bool}:
  + true + false⋅i + false⋅j + false⋅k

julia> Quaternion(1.0I)
Quaternion{Float64}:
  + 1.0 + 0.0⋅i + 0.0⋅j + 0.0⋅k

julia> q = Quaternion{Float32}(I)
Quaternion{Float32}:
  + 1.0 + 0.0⋅i + 0.0⋅j + 0.0⋅k

julia> Quaternion(I, q)
Quaternion{Float32}:
  + 1.0 + 0.0⋅i + 0.0⋅j + 0.0⋅k
```
"""
function Quaternion(q0::T0, q1::T1, q2::T2, q3::T3) where {T0, T1, T2, T3}
    T = promote_type(T0, T1, T2, T3)
    return Quaternion{T}(q0, q1, q2, q3)
end

function Quaternion(v::AbstractVector)
    # The vector must have 3 or 4 components.
    if (length(v) != 3) && (length(v) != 4)
        throw(ArgumentError("The input vector must have 3 or 4 components."))
    end

    if length(v) == 3
        return Quaternion(0, v[1], v[2], v[3])
    else
        return Quaternion(v[1], v[2], v[3], v[4])
    end
end

Quaternion(r::Number, v::AbstractVector) = Quaternion(r, v[1], v[2], v[3])
Quaternion(u::UniformScaling{T}) where T = Quaternion{T}(T(u.λ), T(0), T(0), T(0))
Quaternion{T}(u::UniformScaling) where T = Quaternion{T}(T(u.λ), T(0), T(0), T(0))
Quaternion(::UniformScaling, ::Quaternion{T}) where T = Quaternion{T}(I)

############################################################################################
#                                        Operations                                        #
############################################################################################

# == Operation: + ==========================================================================

"""
    +(qa::Quaternion, qb::Quaternion) -> Quaternion

Compute `qa + qb`.

If one of the operands is a `UniformScaling`:

    +(u::UniformScaling, q::Quaternion)
    +(q::Quaternion, u::UniformScaling)

then it is considered as the quaternion `u.λ + 0 ⋅ i + 0 ⋅ j + 0 ⋅ k`.

# Examples

```jldoctest
julia> q1 = Quaternion(1, 0, 0, 0)
Quaternion{Int64}:
  + 1 + 0⋅i + 0⋅j + 0⋅k

julia> q2 = Quaternion(0, cosd(45), 0, sind(45))
Quaternion{Float64}:
  + 0.0 + 0.707107⋅i + 0.0⋅j + 0.707107⋅k

julia> q1 + q2
Quaternion{Float64}:
  + 1.0 + 0.707107⋅i + 0.0⋅j + 0.707107⋅k

julia> q1 + I
Quaternion{Int64}:
  + 2 + 0⋅i + 0⋅j + 0⋅k
```
"""
@inline function +(qa::Quaternion, qb::Quaternion)
    return Quaternion(qa.q0 + qb.q0, qa.q1 + qb.q1, qa.q2 + qb.q2, qa.q3 + qb.q3)
end

@inline +(u::UniformScaling, q::Quaternion) = Quaternion(u.λ + q.q0, q.q1, q.q2, q.q3)
@inline +(q::Quaternion, u::UniformScaling) = u + q

# == Operation: - ==========================================================================

"""
    -(q::Quaternion) -> Quaternion

Return the quaterion `-q`.

# Examples

```jldoctest
julia> q = Quaternion(1, 0, 0, 0)
Quaternion{Int64}:
  + 1 + 0⋅i + 0⋅j + 0⋅k

julia> -q
Quaternion{Int64}:
  - 1 + 0⋅i + 0⋅j + 0⋅k
```
"""
@inline -(q::Quaternion) = -1 * q

"""
    -(qa::Quaternion, qb::Quaternion) -> Quaternion

Compute `qa - qb`.

If one of the operands is a `UniformScaling`:

    -(u::UniformScaling, q::Quaternion)
    -(q::Quaternion, u::UniformScaling)

then it is considered as the quaternion `u.λ + 0 ⋅ i + 0 ⋅ j + 0 ⋅ k`.

# Examples

```jldoctest
julia> q1 = Quaternion(1, 0, 0, 0)
Quaternion{Int64}:
  + 1 + 0⋅i + 0⋅j + 0⋅k

julia> q2 = Quaternion(0, cosd(45), 0, sind(45))
Quaternion{Float64}:
  + 0.0 + 0.707107⋅i + 0.0⋅j + 0.707107⋅k

julia> q1 - q2
Quaternion{Float64}:
  + 1.0 - 0.707107⋅i + 0.0⋅j - 0.707107⋅k

julia> q1 - I
Quaternion{Int64}:
  + 0 + 0⋅i + 0⋅j + 0⋅k
```
"""
@inline function -(qa::Quaternion, qb::Quaternion)
    return Quaternion(qa.q0 - qb.q0, qa.q1 - qb.q1, qa.q2 - qb.q2, qa.q3 - qb.q3)
end

@inline -(u::UniformScaling, q::Quaternion) = Quaternion(u.λ - q.q0, -q.q1, -q.q2, -q.q3)
@inline -(q::Quaternion, u::UniformScaling) = (-u) + q

# == Operation: * ==========================================================================

"""
    *(λ::Number, q::Quaternion) -> Quaternion
    *(q::Quaternion, λ::Number) -> Quaternion

Compute `λ * q` or `q * λ`, in which `λ` is a scalar.

# Examples

```jldoctest
julia> q = Quaternion(1, 0, 0, 0)
Quaternion{Int64}:
  + 1 + 0⋅i + 0⋅j + 0⋅k

julia> 2 * q
Quaternion{Int64}:
  + 2 + 0⋅i + 0⋅j + 0⋅k
```
"""
@inline *(λ::Number, q::Quaternion) = Quaternion(λ * q.q0, λ * q.q1, λ * q.q2, λ * q.q3)
@inline *(q::Quaternion, λ::Number) = Quaternion(λ * q.q0, λ * q.q1, λ * q.q2, λ * q.q3)

"""
    *(q1::Quaternion, q2::Quaternion) -> Quaternion

Compute the quaternion multiplication `q1 * q2` (Hamilton product).

If one of the operands is a `UniformScaling`:

    *(u::UniformScaling, q::Quaternion)
    *(q::Quaternion, u::UniformScaling)

then it is considered as the quaternion `u.λ + 0 ⋅ i + 0 ⋅ j + 0 ⋅ k`.

# Examples

```jldoctest
julia> q1 = Quaternion(cosd(30), 0, sind(30), 0)
Quaternion{Float64}:
  + 0.866025 + 0.0⋅i + 0.5⋅j + 0.0⋅k

julia> q2 = Quaternion(cosd(60), 0, sind(60), 0)
Quaternion{Float64}:
  + 0.5 + 0.0⋅i + 0.866025⋅j + 0.0⋅k

julia> q1 * q2
Quaternion{Float64}:
  + 0.0 + 0.0⋅i + 1.0⋅j + 0.0⋅k

julia> I * q1
Quaternion{Float64}:
  + 0.866025 + 0.0⋅i + 0.5⋅j + 0.0⋅k
```
"""
@inline function *(q1::Quaternion, q2::Quaternion)
    return Quaternion(
        q1.q0 * q2.q0 - q1.q1 * q2.q1 - q1.q2 * q2.q2 - q1.q3 * q2.q3,
        q1.q0 * q2.q1 + q1.q1 * q2.q0 + q1.q2 * q2.q3 - q1.q3 * q2.q2,
        q1.q0 * q2.q2 - q1.q1 * q2.q3 + q1.q2 * q2.q0 + q1.q3 * q2.q1,
        q1.q0 * q2.q3 + q1.q1 * q2.q2 - q1.q2 * q2.q1 + q1.q3 * q2.q0
    )
end

@inline *(u::UniformScaling, q::Quaternion) = Quaternion(u) * q
@inline *(q::Quaternion, u::UniformScaling) = q * Quaternion(u)

"""
    *(v::AbstractVector, q::Quaternion) -> Quaternion
    *(q::Quaternion, v::AbstractVector) -> Quaternion

Compute the multiplication `qv * q` or `q * qv` in which `qv` is a quaternion with real part
`0` and vectorial/imaginary part `v` (Hamilton product).

# Examples

```jldoctest
julia> q = Quaternion(1, 0, 0, 0)
Quaternion{Int64}:
  + 1 + 0⋅i + 0⋅j + 0⋅k

julia> v = [0, cosd(60), sind(60)]
3-element Vector{Float64}:
 0.0
 0.5
 0.8660254037844386

julia> q * v
Quaternion{Float64}:
  + 0.0 + 0.0⋅i + 0.5⋅j + 0.866025⋅k
```
"""
@inline function *(v::AbstractVector, q::Quaternion)
    return Quaternion(
        -v[1] * q.q1 - v[2] * q.q2 - v[3] * q.q3,
        +v[1] * q.q0 + v[2] * q.q3 - v[3] * q.q2,
        -v[1] * q.q3 + v[2] * q.q0 + v[3] * q.q1,
        +v[1] * q.q2 - v[2] * q.q1 + v[3] * q.q0
    )
end

@inline function *(q::Quaternion, v::AbstractVector)
    return Quaternion(
        - q.q1 * v[1] - q.q2 * v[2] - q.q3 * v[3],
        + q.q0 * v[1] + q.q2 * v[3] - q.q3 * v[2],
        + q.q0 * v[2] - q.q1 * v[3] + q.q3 * v[1],
        + q.q0 * v[3] + q.q1 * v[2] - q.q2 * v[1]
    )
end

# == Operation: / ==========================================================================

"""
    /(λ::Number, q::Quaternion) -> Quaternion
    /(q::Quaternion, λ::Number) -> Quaternion

Compute the division `λ / q` or `q / λ`, in which `λ` is a scalar.

# Examples

```jldoctest
julia> q = Quaternion(2, 0, 0, 0)
Quaternion{Int64}:
  + 2 + 0⋅i + 0⋅j + 0⋅k

julia> q / 2
Quaternion{Float64}:
  + 1.0 + 0.0⋅i + 0.0⋅j + 0.0⋅k
```
"""
@inline function /(λ::Number, q::Quaternion)
    # Compute `λ*(1/q)`.
    norm_q² = q.q0 * q.q0 + q.q1 * q.q1 + q.q2 * q.q2 + q.q3 * q.q3

    return Quaternion(
        +λ * q.q0 / norm_q²,
        -λ * q.q1 / norm_q²,
        -λ * q.q2 / norm_q²,
        -λ * q.q3 / norm_q²
    )
end

@inline /(q::Quaternion, λ::Number) = q * (1 / λ)

"""
    /(q1::Quaternion, q2::Quaternion) -> Quaternion

Compute `q1 * inv(q2)` (Hamilton product).

If one of the operands is a `UniformScaling`:

    /(u::UniformScaling, q::Quaternion)
    /(q::Quaternion, u::UniformScaling)

then it is considered as the quaternion `u.λ + 0 ⋅ i + 0 ⋅ j + 0 ⋅ k`.

# Examples

```jldoctest
julia> q1 = Quaternion(cosd(75), 0, sind(75), 0)
Quaternion{Float64}:
  + 0.258819 + 0.0⋅i + 0.965926⋅j + 0.0⋅k

julia> q2 = Quaternion(cosd(30), 0, sind(30), 0)
Quaternion{Float64}:
  + 0.866025 + 0.0⋅i + 0.5⋅j + 0.0⋅k

julia> q1 / q2
Quaternion{Float64}:
  + 0.707107 + 0.0⋅i + 0.707107⋅j + 0.0⋅k

julia> q1 / (2 * I)
Quaternion{Float64}:
  + 0.12941 + 0.0⋅i + 0.482963⋅j + 0.0⋅k
```
"""
@inline /(q1::Quaternion, q2::Quaternion) = q1 * inv(q2)
@inline /(u::UniformScaling, q::Quaternion) = Quaternion(u) / q
@inline /(q::Quaternion, u::UniformScaling) = q / Quaternion(u)

# == Operation: \ ==========================================================================

"""
    \\(q1::Quaternion, q2::Quaternion) -> Quaternion

Compute `inv(q1) * q2`.

If one of the operands is a `UniformScaling`:

    \\(u::UniformScaling, q::Quaternion)
    \\(q::Quaternion, u::UniformScaling)

then it is considered as the quaternion `u.λ + 0 ⋅ i + 0 ⋅ j + 0 ⋅ k`.

# Examples

```jldoctest
julia> q1 = Quaternion(cosd(75), 0, sind(75), 0)
Quaternion{Float64}:
  + 0.258819 + 0.0⋅i + 0.965926⋅j + 0.0⋅k

julia> q2 = Quaternion(cosd(30), 0, sind(30), 0)
Quaternion{Float64}:
  + 0.866025 + 0.0⋅i + 0.5⋅j + 0.0⋅k

julia> q2 \\ q1
Quaternion{Float64}:
  + 0.707107 + 0.0⋅i + 0.707107⋅j + 0.0⋅k
```
"""
@inline \(q1::Quaternion, q2::Quaternion) = inv(q1) * q2
@inline \(u::UniformScaling, q::Quaternion) = inv(Quaternion(u)) * q
@inline \(q::Quaternion, u::UniformScaling) = inv(q) * Quaternion(u)

"""
    \\(v::AbstractVector, q::Quaternion) -> Quaternion
    \\(q::Quaternion, v::AbstractVector) -> Quaternion

Compute the division `qv \\ q` or `q \\ qv` in which `qv` is a quaternion with real part `0`
and vectorial/imaginary part `v` (Hamilton product).

# Examples

```jldoctest
julia> q = Quaternion(1, 0, 0, 0)
Quaternion{Int64}:
  + 1 + 0⋅i + 0⋅j + 0⋅k

julia> v = [0, cosd(60), sind(60)]
3-element Vector{Float64}:
 0.0
 0.5
 0.8660254037844386

julia> v \\ q
Quaternion{Float64}:
  + 0.0 + 0.0⋅i - 0.5⋅j - 0.866025⋅k
```
"""
@inline \(q::Quaternion, v::AbstractVector) = inv(q) * v
@inline \(v::AbstractVector, q::Quaternion) = inv(Quaternion(v)) * q

############################################################################################
#                                        Functions                                         #
############################################################################################

"""
    conj(q::Quaternion) -> Quaternion

Compute the complex conjugate of the quaternion `q`:

    q0 - q1.i - q2.j - q3.k

See also: [`inv`](@ref)

# Examples

```jldoctest
julia> q = Quaternion(1, cosd(75), 0, sind(75))
Quaternion{Float64}:
  + 1.0 + 0.258819⋅i + 0.0⋅j + 0.965926⋅k

julia> conj(q)
Quaternion{Float64}:
  + 1.0 - 0.258819⋅i - 0.0⋅j - 0.965926⋅k
```
"""
@inline conj(q::Quaternion) = Quaternion(q.q0, -q.q1, -q.q2, -q.q3)

"""
    copy(q::Quaternion{T}) where T -> Quaternion

Create a copy of the quaternion `q`.
"""
@inline copy(q::Quaternion{T}) where T = Quaternion{T}(q.q0, q.q1, q.q2, q.q3)
# TODO: Do we really need a copy functions since Quaternion is not mutable?
# Maybe it is necessary for DifferentialEquations.jl

"""
    imag(q::Quaternion{T}) -> SVector{3, T}

Return the vectorial or imaginary part of the quaternion `q` represented by a 3 × 1 vector
of type `SVector{3}`.

See also: [`real`](@ref), [`vect`](@ref)

# Examples

```jldoctest
julia> q = Quaternion(cosd(75), 0, sind(75), 0)
Quaternion{Float64}:
  + 0.258819 + 0.0⋅i + 0.965926⋅j + 0.0⋅k

julia> imag(q)
3-element StaticArraysCore.SVector{3, Float64} with indices SOneTo(3):
 0.0
 0.9659258262890683
 0.0
```
"""
@inline imag(q::Quaternion) = SVector{3}(q.q1, q.q2, q.q3)

"""
    inv(q::Quaternion) -> Quaternion

Compute the inverse of the quaternion `q`:

    conj(q)
    ───────
      |q|²

See also: [`conj`](@ref)

# Examples

```jldoctest
julia> q = Quaternion(1, 0, cosd(75), sind(75))
Quaternion{Float64}:
  + 1.0 + 0.0⋅i + 0.258819⋅j + 0.965926⋅k

julia> inv(q)
Quaternion{Float64}:
  + 0.5 - 0.0⋅i - 0.12941⋅j - 0.482963⋅k
```
"""
@inline function inv(q::Quaternion)
    # Compute the inverse of the quaternion.
    norm_q² = q.q0 * q.q0 + q.q1 * q.q1 + q.q2 * q.q2 + q.q3 * q.q3

    return Quaternion(
        +q.q0 / norm_q²,
        -q.q1 / norm_q²,
        -q.q2 / norm_q²,
        -q.q3 / norm_q²
    )
end

"""
    norm(q::Quaternion{T}) -> float(T)

Compute the Euclidean norm of the quaternion `q`:

    √(q0² + q1² + q2² + q3²)

# Examples

```jldoctest
julia> q = Quaternion(cosd(75), 0, sind(75), 0)
Quaternion{Float64}:
  + 0.258819 + 0.0⋅i + 0.965926⋅j + 0.0⋅k

julia> norm(q)
1.0
```
"""
@inline norm(q::Quaternion) = √(q.q0 * q.q0 + q.q1 * q.q1 + q.q2 * q.q2 + q.q3 * q.q3)

@inline one(::Type{Quaternion{T}}) where T = Quaternion{T}(T(1), T(0), T(0), T(0))
@inline one(::Type{Quaternion}) = Quaternion{Float64}(1, 0, 0, 0)
@inline one(q::Quaternion{T}) where T = one(Quaternion{T})

"""
    real(q::Quaternion{T}) -> T

Return the real part of the quaternion `q`: `q0`.

See also: [`imag`](@ref), [`vect`](@ref)

# Examples

```jldoctest
julia> q = Quaternion(cosd(75), 0, sind(75), 0)
Quaternion{Float64}:
  + 0.258819 + 0.0⋅i + 0.965926⋅j + 0.0⋅k

julia> real(q)
0.25881904510252074
```
"""
@inline real(q::Quaternion) = q.q0

"""
    vect(q::Quaternion{T}) -> SVector{3, T}

Return the vectorial or imaginary part of the quaternion `q` represented by a 3 × 1 vector
of type `SVector{3, T}`.

See also: [`imag`](@ref), [`real`](@ref)

# Examples

```jldoctest
julia> q = Quaternion(cosd(75), 0, sind(75), 0)
Quaternion{Float64}:
  + 0.258819 + 0.0⋅i + 0.965926⋅j + 0.0⋅k

julia> vect(q)
3-element StaticArraysCore.SVector{3, Float64} with indices SOneTo(3):
 0.0
 0.9659258262890683
 0.0
```
"""
@inline vect(q::Quaternion) = SVector{3}(q.q1, q.q2, q.q3)

@inline zero(::Type{Quaternion{T}}) where T = Quaternion{T}(T(0), T(0), T(0), T(0))
@inline zero(::Type{Quaternion}) = Quaternion{Float64}(0, 0, 0, 0)
@inline zero(q::Quaternion{T}) where T = zero(Quaternion{T})

############################################################################################
#                                        Julia API                                         #
############################################################################################

# The following functions make sure that a quaternion is an iterable object. This allows
# broadcasting without allocations.
Base.IndexStyle(::Type{<:Quaternion}) = IndexLinear()
Base.eltype(::Type{Quaternion{T}}) where T = T
Base.firstindex(q::Quaternion) = 1
Base.lastindex(q::Quaternion) = 4
Base.length(::Quaternion) = 4
Base.ndims(::Type{<:Quaternion}) = 1
Base.ndims(q::Quaternion) = 1
Base.size(::Quaternion) = (4,)
Broadcast.broadcastable(q::Quaternion) = q

function Base.convert(::Type{Quaternion{T}}, q::Quaternion) where T
    return Quaternion{T}(q.q0, q.q1, q.q2, q.q3)
end

@inline function Base.getindex(q::Quaternion, i::Int)
    if i == 1
        return q.q0
    elseif i == 2
        return q.q1
    elseif i == 3
        return q.q2
    elseif i == 4
        return q.q3
    else
        throw(BoundsError(q, i))
    end
end

@inline function Base.getindex(q::Quaternion{T}, ::Colon) where T
    return SVector{4, T}(q.q0, q.q1, q.q2, q.q3)
end

@inline function Base.getindex(q::Quaternion, i::CartesianIndex{1})
    return getindex(q, first(i.I))
end

@inline function Base.iterate(q::Quaternion)
    return iterate(q, 0)
end

@inline function Base.iterate(q::Quaternion, state::Integer)
    state = state + 1

    if state == 1
        return (q.q0, state)
    elseif state == 2
        return (q.q1, state)
    elseif state == 3
        return (q.q2, state)
    elseif state == 4
        return (q.q3, state)
    else
        return nothing
    end
end

# We need to define `setindex!` with respect to vectors to allow operations such as:
#
#     v[4:7] = q
@inline function setindex!(v::Vector{T}, q::Quaternion, I::UnitRange) where T
    # We can use all the funcion in static arrays.
    return setindex!(v, q[:], I)
end

@inline function ≈(q1::Quaternion, q2::Quaternion; kwargs...)
    return ≈(q1.q0, q2.q0; kwargs...) &&
           ≈(q1.q1, q2.q1; kwargs...) &&
           ≈(q1.q2, q2.q2; kwargs...) &&
           ≈(q1.q3, q2.q3; kwargs...)
end

# If this function is not defined, then two quaternions are equal if and only if the
# elements and the type are equals.
@inline function ==(q1::Quaternion, q2::Quaternion)
    return (q1.q0 == q2.q0) &&
           (q1.q1 == q2.q1) &&
           (q1.q2 == q2.q2) &&
           (q1.q3 == q2.q3)
end

############################################################################################
#                                            IO                                            #
############################################################################################

function show(io::IO, q::Quaternion{T}) where T
    # Check if the user wants compact printing, defaulting to `true`.
    compact_printing = get(io, :compact, true)::Bool

    # Get the absolute values using `print`.
    aq0 = sprint(print, abs(q.q0), context = :compact => compact_printing)
    aq1 = sprint(print, abs(q.q1), context = :compact => compact_printing)
    aq2 = sprint(print, abs(q.q2), context = :compact => compact_printing)
    aq3 = sprint(print, abs(q.q3), context = :compact => compact_printing)

    # Get the signs.
    sq0 = signbit(q.q0) ? "-" : "+"
    sq1 = signbit(q.q1) ? "-" : "+"
    sq2 = signbit(q.q2) ? "-" : "+"
    sq3 = signbit(q.q3) ? "-" : "+"

    print(io, "Quaternion{$(T)}: ")
    print(io,
        sq0, " ", aq0, " ",
        sq1, " ", aq1, "⋅i ",
        sq2, " ", aq2, "⋅j ",
        sq3, " ", aq3, "⋅k"
    )

    return nothing
end

function show(io::IO, mime::MIME"text/plain", q::Quaternion{T}) where T
    # Check if the user wants colors.
    color = get(io, :color, false)::Bool

    # Check if the user wants compact printing, defaulting to `true`.
    compact_printing = get(io, :compact, true)::Bool

    # Assemble the context.
    context = IOContext(io, :color => color, :compact => compact_printing)

    b = color ? string(_b) : ""
    d = color ? string(_d) : ""

    # Get the absolute values using `print`.
    aq0 = sprint(print, abs(q.q0), context = context)
    aq1 = sprint(print, abs(q.q1), context = context)
    aq2 = sprint(print, abs(q.q2), context = context)
    aq3 = sprint(print, abs(q.q3), context = context)

    # Get the signs.
    sq0 = signbit(q.q0) ? "-" : "+"
    sq1 = signbit(q.q1) ? "-" : "+"
    sq2 = signbit(q.q2) ? "-" : "+"
    sq3 = signbit(q.q3) ? "-" : "+"

    println(io, "Quaternion{$(T)}:")
    print(io,
        "  ",
        sq0, " ", aq0, " ",
        sq1, " ", aq1, "⋅", b, "i", d, " ",
        sq2, " ", aq2, "⋅", b, "j", d, " ",
        sq3, " ", aq3, "⋅", b, "k", d
    )

    return nothing
end

############################################################################################
#                                        Kinematics                                        #
############################################################################################

"""
    dquat(qba::Quaternion, wba_b::AbstractVector) -> Quaternion

Compute the time-derivative of the quaternion `qba` that rotates a reference frame `a` into
alignment to the reference frame `b` in which the angular velocity of `b` with respect to
`a`, and represented in `b`, is `wba_b`.

# Examples

```jldoctest
julia> q = Quaternion(1.0I);

julia> dquat(q,[1;0;0])
Quaternion{Float64}:
  - 0.0 + 0.5⋅i + 0.0⋅j + 0.0⋅k
```
"""
function dquat(qba::Quaternion, wba_b::AbstractVector)
    # Auxiliary variable.
    w = wba_b

    # Check the dimensions.
    if length(wba_b) != 3
        throw(ArgumentError("The angular velocity vector must have three components."))
    end

    # Return the time-derivative.
    #         1         x
    #   dq = --- (wba_b) . q
    #         2

    return Quaternion(
                          - w[1] / 2 * qba.q1 - w[2] / 2 * qba.q2 - w[3] / 2 * qba.q3,
        w[1] / 2 * qba.q0                     + w[3] / 2 * qba.q2 - w[2] / 2 * qba.q3,
        w[2] / 2 * qba.q0 - w[3] / 2 * qba.q1                     + w[1] / 2 * qba.q3,
        w[3] / 2 * qba.q0 + w[2] / 2 * qba.q1 - w[1] / 2 * qba.q2
    )
end
