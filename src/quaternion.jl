# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the quaternions.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export dquat, eye, norm, quat_to_angle, quat_to_angleaxis, quat_to_dcm, vect

################################################################################
#                                 Constructors
################################################################################

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

```julia-repl
julia> Quaternion(1, 0, 0, 0)
Quaternion{Int64}:
  + 1 + 0.i + 0.j + 0.k

julia> Quaternion(1, 0, 0, 0.0)
Quaternion{Float64}:
  + 1.0 + 0.0.i + 0.0.j + 0.0.k
```

---

    Quaternion(v::AbstractVector)

If the vector `v` has 3 components, then create a quaternion in which the real
part is `0` and the vectorial or imaginary part has the same components of the
vector `v`. In other words:

    q = 0 + v[1].i + v[2].j + v[3].k

Otherwise, if the vector `v` has 4 components, then create a quaternion in which
the elements match those of the input vector:

    q = v[1] + v[2].i + v[3].j + v[4].k

!!! note
    If the length of `v` is not 3 or 4, then an error is thrown.

# Examples

```julia-repl
julia> Quaternion([0, cosd(45), sind(45)])
Quaternion{Float64}:
  + 0.0 + 0.0.i + 0.7071067811865476.j + 0.7071067811865476.k

julia> Quaternion([cosd(45), 0, sind(45), 0])
Quaternion{Float64}:
  + 0.7071067811865476 + 0.0.i + 0.7071067811865476.j + 0.0.k
```

---

    Quaternion(r::Number, v::AbstractVector)

Create a quaternion with real part `r` and vectorial or imaginary part `v`:

    r + v[1].i + v[2].j + v[3].k

!!! note
    The quaternion type is obtained by promoting the type of `r` and the
    elements of `v`.

# Examples

```julia-repl
julia> Quaternion(cosd(45), [0, sind(45), 0])
Quaternion{Float64}:
  + 0.7071067811865476 + 0.0.i + 0.7071067811865476.j + 0.0.k
```

---

    Quaternion(u::UniformScaling{T}) where T
    Quaternion{T}(u::UniformScaling) where T
    Quaternion(u::UniformScaling, Q::Quaternion{T}) where T

Create the quaternion `u.λ + 0.i + 0.j + 0.k`.

If a quaternion is passed as in the third signature, then the new quaternion
will have the same type.

# Examples

```julia-repl
julia> Quaternion(I)
Quaternion{Bool}:
  + true + false.i + false.j + false.k

julia> Quaternion(1.0I)
Quaternion{Float64}:
  + 1.0 + 0.0.i + 0.0.j + 0.0.k

julia> q = Quaternion{Float32}(I)
Quaternion{Float32}:
  + 1.0 + 0.0.i + 0.0.j + 0.0.k

julia> Quaternion(I, q)
Quaternion{Float32}:
  + 1.0 + 0.0.i + 0.0.j + 0.0.k
```
"""
function Quaternion(q0::T0, q1::T1, q2::T2, q3::T3) where {T0, T1, T2, T3}
    T = promote_type(T0, T1, T2, T3)
    return Quaternion{T}(q0, q1, q2, q3)
end

function Quaternion(v::AbstractVector)
    # The vector must have 3 or 4 components.
    if length(v) != 3 && length(v) != 4
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

################################################################################
#                                  Operations
################################################################################

# Operation: +
# ==============================================================================

"""
    +(qa::Quaternion, qb::Quaternion)

Compute `qa + qb`.

If one of the operands is a `UniformScaling`:

    +(u::UniformScaling, q::Quaternion)
    +(q::Quaternion, u::UniformScaling)

then it is considered as the quaternion `u.λ + 0 ⋅ i + 0 ⋅ j + 0 ⋅ k`.

# Examples

```julia-repl
julia> q1 = Quaternion(1, 0, 0, 0)
Quaternion{Int64}:
  + 1 + 0.i + 0.j + 0.k

julia> q2 = Quaternion(0, cosd(45), 0, sind(45))
Quaternion{Float64}:
  + 0.0 + 0.7071067811865476.i + 0.0.j + 0.7071067811865476.k

julia> q1 + q2
Quaternion{Float64}:
  + 1.0 + 0.7071067811865476.i + 0.0.j + 0.7071067811865476.k

julia> q1 + I
Quaternion{Int64}:
  + 2 + 0.i + 0.j + 0.k
```
"""
@inline function +(qa::Quaternion, qb::Quaternion)
    return Quaternion(qa.q0 + qb.q0, qa.q1 + qb.q1, qa.q2 + qb.q2, qa.q3 + qb.q3)
end

@inline +(u::UniformScaling, q::Quaternion) = Quaternion(u.λ + q.q0, q.q1, q.q2, q.q3)
@inline +(q::Quaternion, u::UniformScaling) = u+q

# Operation: -
# ==============================================================================

"""
    -(q::Quaternion)

Return the quaterion `-q`.

# Examples

```julia-repl
julia> q = Quaternion(1, 0, 0, 0)
Quaternion{Int64}:
  + 1 + 0.i + 0.j + 0.k

julia> -q
Quaternion{Int64}:
  - 1 + 0.i + 0.j + 0.k
```
"""
@inline -(q::Quaternion) = -1*q

"""
    -(qa::Quaternion, qb::Quaternion)

Compute `qa - qb`.

If one of the operands is a `UniformScaling`:

    -(u::UniformScaling, q::Quaternion)
    -(q::Quaternion, u::UniformScaling)

then it is considered as the quaternion `u.λ + 0 ⋅ i + 0 ⋅ j + 0 ⋅ k`.

# Examples

```julia-repl
julia> q1 = Quaternion(1, 0, 0, 0)
Quaternion{Int64}:
  + 1 + 0.i + 0.j + 0.k

julia> q2 = Quaternion(0, cosd(45), 0, sind(45))
Quaternion{Float64}:
  + 0.0 + 0.7071067811865476.i + 0.0.j + 0.7071067811865476.k

julia> q1 - q2
Quaternion{Float64}:
  + 1.0 - 0.7071067811865476.i + 0.0.j - 0.7071067811865476.k

julia> q1 - I
Quaternion{Int64}:
  + 0 + 0.i + 0.j + 0.k
```
"""
@inline function -(qa::Quaternion, qb::Quaternion)
    return Quaternion(qa.q0 - qb.q0, qa.q1 - qb.q1, qa.q2 - qb.q2, qa.q3 - qb.q3)
end

@inline -(u::UniformScaling, q::Quaternion) = Quaternion(u.λ - q.q0, -q.q1, -q.q2, -q.q3)
@inline -(q::Quaternion, u::UniformScaling) = (-u) + q

# Operation: *
# ==============================================================================

"""
    *(λ::Number, q::Quaternion)
    *(q::Quaternion, λ::Number)

Compute `λ * q` or `q * λ`, in which `λ` is a scalar.

# Examples

```julia-repl
julia> q = Quaternion(1, 0, 0, 0)
Quaternion{Int64}:
  + 1 + 0.i + 0.j + 0.k

julia> 2 * q
Quaternion{Int64}:
  + 2 + 0.i + 0.j + 0.k
```
"""
@inline *(λ::Number, q::Quaternion) = Quaternion(λ * q.q0, λ * q.q1, λ * q.q2, λ * q.q3)
@inline *(q::Quaternion, λ::Number) = Quaternion(λ * q.q0, λ * q.q1, λ * q.q2, λ * q.q3)

"""
    *(q1::Quaternion, q2::Quaternion)

Compute the quaternion multiplication `q1 * q2` (Hamilton product).

If one of the operands is a `UniformScaling`:

    *(u::UniformScaling, q::Quaternion)
    *(q::Quaternion, u::UniformScaling)

then it is considered as the quaternion `u.λ + 0 ⋅ i + 0 ⋅ j + 0 ⋅ k`.

# Examples

```julia-repl
julia> q1 = Quaternion(cosd(30), 0, sind(30), 0)
Quaternion{Float64}:
  + 0.8660254037844386 + 0.0.i + 0.5.j + 0.0.k

julia> q2 = Quaternion(cosd(60), 0, sind(60), 0)
Quaternion{Float64}:
  + 0.5 + 0.0.i + 0.8660254037844386.j + 0.0.k

julia> q1 * q2
Quaternion{Float64}:
  + 0.0 + 0.0.i + 0.9999999999999999.j + 0.0.k

julia> I * q1
Quaternion{Float64}:
  + 0.8660254037844386 + 0.0.i + 0.5.j + 0.0.k
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

@inline *(u::UniformScaling, q::Quaternion) = Quaternion(u)*q
@inline *(q::Quaternion, u::UniformScaling) = q*Quaternion(u)

"""
    *(v::AbstractVector, q::Quaternion)
    *(q::Quaternion, v::AbstractVector)

Compute the multiplication `qv * q` or `q * qv` in which `qv` is a quaternion
with real part `0` and vectorial/imaginary part `v` (Hamilton product).

# Examples

```julia-repl
julia> q = Quaternion(1, 0, 0, 0)
Quaternion{Int64}:
  + 1 + 0.i + 0.j + 0.k

julia> v = [0, cosd(60), sind(60)]
3-element Vector{Float64}:
 0.0
 0.5
 0.8660254037844386

julia> q * v
Quaternion{Float64}:
  + 0.0 + 0.0.i + 0.5.j + 0.8660254037844386.k
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

# Operation: /
# ==============================================================================

"""
    /(λ::Number, q::Quaternion)
    /(q::Quaternion, λ::Number)

Compute the division `λ / q` or `q / λ`, in which `λ` is a scalar.

# Examples

```julia-repl
julia> q = Quaternion(2, 0, 0, 0)
Quaternion{Int64}:
  + 2 + 0.i + 0.j + 0.k

julia> q / 2
Quaternion{Float64}:
  + 1.0 + 0.0.i + 0.0.j + 0.0.k
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
    /(q1::Quaternion, q2::Quaternion)

Compute `q1 * inv(q2)` (Hamilton product).

If one of the operands is a `UniformScaling`:

    /(u::UniformScaling, q::Quaternion)
    /(q::Quaternion, u::UniformScaling)

then it is considered as the quaternion `u.λ + 0 ⋅ i + 0 ⋅ j + 0 ⋅ k`.

# Examples

```julia-repl
julia> q1 = Quaternion(cosd(75), 0, sind(75), 0)
Quaternion{Float64}:
  + 0.25881904510252074 + 0.0.i + 0.9659258262890683.j + 0.0.k

julia> q2 = Quaternion(cosd(30), 0, sind(30), 0)
Quaternion{Float64}:
  + 0.8660254037844386 + 0.0.i + 0.5.j + 0.0.k

julia> q1 / q2
Quaternion{Float64}:
  + 0.7071067811865477 + 0.0.i + 0.7071067811865476.j + 0.0.k

julia> q1 / (2 * I)
Quaternion{Float64}:
  + 0.12940952255126037 + 0.0.i + 0.48296291314453416.j + 0.0.k
```
"""
@inline /(q1::Quaternion, q2::Quaternion) = q1 * inv(q2)
@inline /(u::UniformScaling, q::Quaternion) = Quaternion(u) / q
@inline /(q::Quaternion, u::UniformScaling) = q / Quaternion(u)

# Operation: \
# ==============================================================================

"""
    \\(q1::Quaternion, q2::Quaternion)

Compute `inv(q1) * q2`.

If one of the operands is a `UniformScaling`:

    \\(u::UniformScaling, q::Quaternion)
    \\(q::Quaternion, u::UniformScaling)

then it is considered as the quaternion `u.λ + 0 ⋅ i + 0 ⋅ j + 0 ⋅ k`.

# Examples

```julia-repl
julia> q1 = Quaternion(cosd(75), 0, sind(75), 0)
Quaternion{Float64}:
  + 0.25881904510252074 + 0.0.i + 0.9659258262890683.j + 0.0.k

julia> q2 = Quaternion(cosd(30), 0, sind(30), 0)
Quaternion{Float64}:
  + 0.8660254037844386 + 0.0.i + 0.5.j + 0.0.k

julia> q2 \\ q1
Quaternion{Float64}:
  + 0.7071067811865477 + 0.0.i + 0.7071067811865476.j + 0.0.k
```
"""
@inline \(q1::Quaternion, q2::Quaternion) = inv(q1) * q2
@inline \(u::UniformScaling, q::Quaternion) = inv(Quaternion(u)) * q
@inline \(q::Quaternion, u::UniformScaling) = inv(q) * Quaternion(u)

"""
    \\(v::AbstractVector, q::Quaternion)
    \\(q::Quaternion, v::AbstractVector)

Compute the division `qv \\ q` or `q \\ qv` in which `qv` is a quaternion with
real part `0` and vectorial/imaginary part `v` (Hamilton product).

# Examples

```julia-repl
julia> q = Quaternion(1, 0, 0, 0)
Quaternion{Int64}:
  + 1 + 0.i + 0.j + 0.k

julia> v = [0, cosd(60), sind(60)]
3-element Vector{Float64}:
 0.0
 0.5
 0.8660254037844386

julia> v \\ q
Quaternion{Float64}:
  + 0.0 + 0.0.i - 0.5000000000000001.j - 0.8660254037844387.k
```
"""
@inline \(q::Quaternion, v::AbstractVector) = inv(q)*v
@inline \(v::AbstractVector, q::Quaternion) = inv(Quaternion(v))*q

################################################################################
#                                  Functions
################################################################################

"""
    conj(q::Quaternion)

Compute the complex conjugate of the quaternion `q`:

    q0 - q1.i - q2.j - q3.k

See also: [`inv`](@ref)

# Examples

```julia-repl
julia> q = Quaternion(1, cosd(75), 0, sind(75))
Quaternion{Float64}:
  + 1.0 + 0.25881904510252074.i + 0.0.j + 0.9659258262890683.k

julia> conj(q)
Quaternion{Float64}:
  + 1.0 - 0.25881904510252074.i + 0.0.j - 0.9659258262890683.k
```
"""
@inline conj(q::Quaternion) = Quaternion(q.q0, -q.q1, -q.q2, -q.q3)

"""
    copy(q::Quaternion{T}) where T

Create a copy of the quaternion `q`.

"""
@inline copy(q::Quaternion{T}) where T = Quaternion{T}(q.q0, q.q1, q.q2, q.q3)
# TODO: Do we really need a copy functions since Quaternion is not mutable?
# Maybe it is necessary for DifferentialEquations.jl

"""
    imag(q::Quaternion)

Return the vectorial or imaginary part of the quaternion `q` represented by a
3 × 1 vector of type `SVector{3}`.

See also: [`real`](@ref), [`vect`](@ref)

# Examples

```julia-repl
julia> q = Quaternion(cosd(75), 0, sind(75), 0)
Quaternion{Float64}:
  + 0.25881904510252074 + 0.0.i + 0.9659258262890683.j + 0.0.k

julia> imag(q)
3-element StaticArrays.SVector{3, Float64} with indices SOneTo(3):
 0.0
 0.9659258262890683
 0.0
```
"""
@inline imag(q::Quaternion) = SVector{3}(q.q1, q.q2, q.q3)

"""
    inv(q::Quaternion)

Compute the inverse of the quaternion `q`:

    conj(q)
    -------
      |q|²

See also: [`conj`](@ref)

# Examples

```julia-repl
julia> q = Quaternion(1, 0, cosd(75), sind(75))
Quaternion{Float64}:
  + 1.0 + 0.0.i + 0.25881904510252074.j + 0.9659258262890683.k

julia> inv(q)
Quaternion{Float64}:
  + 0.5 + 0.0.i - 0.12940952255126037.j - 0.48296291314453416.k
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
    norm(q::Quaternion)

Compute the Euclidean norm of the quaternion `q`:

    √(q0² + q1² + q2² + q3²)

# Examples

```julia-repl
julia> q = Quaternion(cosd(75), 0, sind(75), 0)
Quaternion{Float64}:
  + 0.25881904510252074 + 0.0.i + 0.9659258262890683.j + 0.0.k

julia> norm(q)
1.0
```
"""
@inline norm(q::Quaternion) = √(q.q0 * q.q0 + q.q1 * q.q1 + q.q2 * q.q2 + q.q3 * q.q3)

"""
    real(q::Quaternion)

Return the real part of the quaternion `q`: `q0`.

See also: [`imag`](@ref), [`vect`](@ref)

# Examples

```julia-repl
julia> q = Quaternion(cosd(75), 0, sind(75), 0)
Quaternion{Float64}:
  + 0.25881904510252074 + 0.0.i + 0.9659258262890683.j + 0.0.k

julia> real(q)
0.25881904510252074
```
"""
@inline real(q::Quaternion) = q.q0

"""
    vect(q::Quaternion)

Return the vectorial or imaginary part of the quaternion `q` represented by a
3 × 1 vector of type `SVector{3}`.

See also: [`imag`](@ref), [`real`](@ref)

# Examples

```julia-repl
julia> q = Quaternion(cosd(75), 0, sind(75), 0)
Quaternion{Float64}:
  + 0.25881904510252074 + 0.0.i + 0.9659258262890683.j + 0.0.k

julia> vect(q)
3-element StaticArrays.SVector{3, Float64} with indices SOneTo(3):
 0.0
 0.9659258262890683
 0.0
```
"""
@inline vect(q::Quaternion) = SVector{3}(q.q1, q.q2, q.q3)

"""
    zeros(::Type{Quaternion{T}}) where T

Create the null quaternion: `0 + 0 ⋅ i + 0 ⋅ j + 0 ⋅ k`.

The type of the new quaternion will be `T`. If the type `T` is omitted, then it
defaults to `Float64`.

# Example

```julia-repl
julia> zeros(Quaternion{Float32})
Quaternion{Float32}:
  + 0.0 + 0.0.i + 0.0.j + 0.0.k

julia> zeros(Quaternion)
Quaternion{Float64}:
  + 0.0 + 0.0.i + 0.0.j + 0.0.k
```

---

    zeros(q::Quaternion{T}) where T

Create the null quaternion with the same type `T` of another quaternion `q`.

# Examples

```julia-repl
julia> q = Quaternion{Float32}(1, 0, 0, 0)
Quaternion{Float32}:
  + 0.0 + 0.0.i + 0.0.j + 0.0.k

julia> zeros(q)
Quaternion{Float32}:
  + 0.0 + 0.0.i + 0.0.j + 0.0.k
```
"""
@inline zeros(::Type{Quaternion{T}}) where T = Quaternion{T}(T(0), T(0), T(0), T(0))
@inline zeros(::Type{Quaternion}) = Quaternion{Float64}(0, 0, 0, 0)
@inline zeros(q::Quaternion{T}) where T = zeros(Quaternion{T})

# The following functions make sure that a quaternion is an iterable object.
# This allows broadcasting without allocations.
Base.IndexStyle(::Type{<:Quaternion}) = IndexLinear()
@inline Base.size(::Quaternion) = (4,)

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
        throw(BoundsError(q,i))
    end
end

################################################################################
#                                      IO
################################################################################

# TODO: Add support to compact printing.
function show(io::IO, q::Quaternion{T}) where T
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

    print(io, "Quaternion{$(T)}:")
    print(io, " $(sq0) $(aq0) $(sq1) $(aq1).i $(sq2) $(aq2).j $(sq3) $(aq3).k")

    return nothing
end

function show(io::IO, mime::MIME"text/plain", q::Quaternion{T}) where T
    # Check if the user wants colors.
    color = get(io, :color, false)

    b = (color) ? _b : ""
    d = (color) ? _d : ""

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

    # Unitary vectors.
    i = "$(b)i$d"
    j = "$(b)j$d"
    k = "$(b)k$d"

    println(io, "Quaternion{$(T)}:")
    print(io, "  $(sq0) $(aq0) $(sq1) $(aq1).$i $(sq2) $(aq2).$j $(sq3) $(aq3).$k")

    return nothing
end

################################################################################
#                                 Conversions
################################################################################

# Direction Cosine Matrix
# ==============================================================================

"""
    quat_to_dcm(q::Quaternion)

Convert the quaternion `q` to a Direction Cosine Matrix (DCM).

# Examples

```julia-repl
julia> q = Quaternion(cosd(45/2), sind(45/2), 0, 0);

julia> quat_to_dcm(q)
3×3 StaticArrays.SMatrix{3, 3, Float64, 9} with indices SOneTo(3)×SOneTo(3):
 1.0   0.0       0.0
 0.0   0.707107  0.707107
 0.0  -0.707107  0.707107
```
"""
function quat_to_dcm(q::Quaternion)
    # Auxiliary variables.
    q0 = q.q0
    q1 = q.q1
    q2 = q.q2
    q3 = q.q3

    return DCM(
        q0^2+q1^2-q2^2-q3^2,   2(q1*q2+q0*q3)   ,   2(q1*q3-q0*q2),
          2(q1*q2-q0*q3)   , q0^2-q1^2+q2^2-q3^2,   2(q2*q3+q0*q1),
          2(q1*q3+q0*q2)   ,   2(q2*q3-q0*q1)   , q0^2-q1^2-q2^2+q3^2
    )'
end

# Euler Angle and Axis
# ==============================================================================

"""
    quat_to_angleaxis(q::Quaternion{T}) where T

Convert the quaternion `q` to a Euler angle and axis representation (see
[`EulerAngleAxis`](@ref)). By convention, the Euler angle will be kept between
`[0, π] rad`.

# Remarks

This function will not fail if the quaternion norm is not 1. However, the
meaning of the results will not be defined, because the input quaternion does
not represent a 3D rotation. The user must handle such situations.

# Examples

```julia-repl
julia> q = Quaternion(cosd(45/2), sind(45/2), 0, 0)
Quaternion{Float64}:
  + 0.9238795325112867 + 0.3826834323650898.i + 0.0.j + 0.0.k

julia> quat_to_angleaxis(q)
EulerAngleAxis{Float64}:
  Euler angle:   0.7854 rad ( 45.0000 deg)
   Euler axis: [  1.0000,   0.0000,   0.0000]
```
"""
function quat_to_angleaxis(q::Quaternion{T}) where T
    # If `q0` is 1 or -1, then we have an identity rotation.
    if abs(q.q0) >= 1 - eps()
        return EulerAngleAxis(T(0), SVector{3, T}(0, 0, 0))
    else
        # Compute sin(θ/2).
        sθo2 = √( q.q1 * q.q1 + q.q2 * q.q2 + q.q3 * q.q3 )

        # Compute θ in range [0, 2π].
        θ = 2acos(q.q0)

        # Keep θ between [0, π].
        s = +1
        if θ > π
            θ = T(2π) - θ
            s = -1
        end

        return EulerAngleAxis( θ, s * [q.q1, q.q2, q.q3] / sθo2 )
    end
end

# Euler Angles
# ==============================================================================

"""
    quat_to_angle(q::Quaternion, rot_seq::Symbol = :ZYX)

Convert the quaternion `q` to Euler Angles (see [`EulerAngles`](@ref)) given a
rotation sequence `rot_seq`.

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`. If no value is specified, then it defaults to `:ZYX`.

# Examples

```julia-repl
julia> q = Quaternion(cosd(45/2), sind(45/2), 0, 0)
Quaternion{Float64}:
  + 0.9238795325112867 + 0.3826834323650898.i + 0.0.j + 0.0.k

julia> quat_to_angle(q,:XYZ)
EulerAngles{Float64}:
  R(X):   0.7854 rad (  45.0000 deg)
  R(Y):   0.0000 rad (   0.0000 deg)
  R(Z):   0.0000 rad (   0.0000 deg)
```
"""
function quat_to_angle(q::Quaternion, rot_seq::Symbol = :ZYX)
    # Convert the quaternion to DCM.
    dcm = quat_to_dcm(q)

    # Convert the DCM to the Euler Angles.
    return dcm_to_angle(dcm, rot_seq)
end

################################################################################
#                                  Kinematics
################################################################################

"""
    dquat(qba::Quaternion, wba_b::AbstractVector)

Compute the time-derivative of the quaternion `qba` that rotates a reference
frame `a` into alignment to the reference frame `b` in which the angular
velocity of `b` with respect to `a`, and represented in `b`, is `wba_b`.

# Examples

```julia-repl
julia> q = Quaternion(1.0I);

julia> dquat(q,[1;0;0])
Quaternion{Float64}:
  + 0.0 + 0.5.i + 0.0.j + 0.0.k
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
                       -w[1]/2*qba.q1 -w[2]/2*qba.q2 -w[3]/2*qba.q3,
        +w[1]/2*qba.q0                +w[3]/2*qba.q2 -w[2]/2*qba.q3,
        +w[2]/2*qba.q0 -w[3]/2*qba.q1                +w[1]/2*qba.q3,
        +w[3]/2*qba.q0 +w[2]/2*qba.q1 -w[1]/2*qba.q2
    )
end
