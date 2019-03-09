################################################################################
#                                 Quaternions
################################################################################

export dquat, eye, norm, quat_to_angle, quat_to_angleaxis, quat_to_dcm, vect

################################################################################
#                                 Initializers
################################################################################

"""
    function Quaternion(q0::T0, q1::T1, q2::T2, q3::T3) where {T0,T1,T2,T3}

Create the following quaternion:

    q0 + q1.i + q2.j + q3.k

in which:

* `q0` is the real part of the quaternion.
* `q1` is the X component of the quaternion vectorial part.
* `q2` is the Y component of the quaternion vectorial part.
* `q3` is the Z component of the quaternion vectorial part.

"""
function Quaternion(q0::T0, q1::T1, q2::T2, q3::T3) where {T0,T1,T2,T3}
    T = promote_type(T0,T1,T2,T3)
    Quaternion{T}(q0,q1,q2,q3)
end

"""
    function Quaternion(v::AbstractVector)

If the vector `v` has 3 components, then create a quaternion in which the real
part is `0` and the vectorial or imaginary part has the same components of the
vector `v`. In other words:

    q = 0 + v[1].i + v[2].j + v[3].k

Otherwise, if the vector `v` has 4 components, then create a quaternion in which
the elements match those of the input vector:

    q = v[1] + v[2].i + v[3].j + v[4].k

"""
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

"""
    function Quaternion(r::Number, v::AbstractVector)

Create a quaternion with real part `r` and vectorial or imaginary part `v`:

    r + v[1].i + v[2].j + v[3].k

"""
Quaternion(r::Number, v::AbstractVector) = Quaternion(r, v[1], v[2], v[3])

"""
    function Quaternion(u::UniformScaling{T}) where T
    function Quaternion{T}(u::UniformScaling) where T

Create the quaternion `u.λ + 0.i + 0.j + 0.k`.

"""
Quaternion(u::UniformScaling{T}) where T = Quaternion{T}(T(u.λ), T(0), T(0), T(0))
Quaternion{T}(u::UniformScaling) where T = Quaternion{T}(T(u.λ), T(0), T(0), T(0))

"""
    function Quaternion(::UniformScaling,::Quaternion{T}) where T

Create an identity quaternion of type `T`:

    T(1) + T(0).i + T(0).j + T(0).k

"""
Quaternion(::UniformScaling,::Quaternion{T}) where T = Quaternion{T}(I)

################################################################################
#                                  Operations
################################################################################

# Operation: +
# ==============================================================================

"""
    @inline function +(qa::Quaternion, qb::Quaternion)

Compute `qa + qb`.

"""
@inline +(qa::Quaternion, qb::Quaternion) =
    Quaternion(qa.q0 + qb.q0, qa.q1 + qb.q1, qa.q2 + qb.q2, qa.q3 + qb.q3)

"""
    @inline function +(u::UniformScaling, q::Quaternion)
    @inline function +(q::Quaternion, u::UniformScaling)

Compute `qu + q` or `q + qu`, in which `qu` is the scaled identity quaternion
`qu = u.λ * I`.

"""
@inline +(u::UniformScaling, q::Quaternion) =
    Quaternion(u.λ + q.q0, q.q1, q.q2, q.q3)

@inline +(q::Quaternion, u::UniformScaling) = u+q

# Operation: -
# ==============================================================================

"""
    @inline function -(qa::Quaternion, qb::Quaternion)

Compute `qa - qb`.

"""
@inline -(qa::Quaternion, qb::Quaternion) =
    Quaternion(qa.q0 - qb.q0, qa.q1 - qb.q1, qa.q2 - qb.q2, qa.q3 - qb.q3)

"""
    @inline function -(u::UniformScaling, q::Quaternion)
    @inline function -(q::Quaternion, u::UniformScaling)

Compute `qu - q` or `q - qu`, in which `qu` is the scaled identity quaternion
`qu = u.λ * I`.

"""
@inline -(u::UniformScaling, q::Quaternion) =
    Quaternion{T}(u.λ - q.q0, -q.q1, -q.q2, -q.q3)

@inline -(q::Quaternion, u::UniformScaling) = (-u)+q

# Operation: *
# ==============================================================================

"""
    @inline function *(λ::Number, q::Quaternion)
    @inline function *(q::Quaternion, λ::Number)

Compute `λ*q` or `q*λ`, in which `λ` is a scalar.

"""
@inline *(λ::Number, q::Quaternion) = Quaternion(λ*q.q0, λ*q.q1, λ*q.q2, λ*q.q3)
@inline *(q::Quaternion, λ::Number) = Quaternion(λ*q.q0, λ*q.q1, λ*q.q2, λ*q.q3)

"""
    @inline function *(q1::Quaternion, q2::Quaternion)

Compute the quaternion multiplication `q1*q2` (Hamilton product).

"""
@inline *(q1::Quaternion, q2::Quaternion) =
    Quaternion(q1.q0*q2.q0 - q1.q1*q2.q1 - q1.q2*q2.q2 - q1.q3*q2.q3,
               q1.q0*q2.q1 + q1.q1*q2.q0 + q1.q2*q2.q3 - q1.q3*q2.q2,
               q1.q0*q2.q2 - q1.q1*q2.q3 + q1.q2*q2.q0 + q1.q3*q2.q1,
               q1.q0*q2.q3 + q1.q1*q2.q2 - q1.q2*q2.q1 + q1.q3*q2.q0)

"""
    @inline function *(v::AbstractVector, q::Quaternion)
    @inline function *(q::Quaternion, v::AbstractVector)

Compute the multiplication `qv*q` or `q*qv` in which `qv` is a quaternion with
real part `0` and vectorial/imaginary part `v` (Hamilton product).

"""
@inline *(v::AbstractVector, q::Quaternion) =
    Quaternion(-v[1]*q.q1 - v[2]*q.q2 - v[3]*q.q3,
               +v[1]*q.q0 + v[2]*q.q3 - v[3]*q.q2,
               -v[1]*q.q3 + v[2]*q.q0 + v[3]*q.q1,
               +v[1]*q.q2 - v[2]*q.q1 + v[3]*q.q0)

@inline *(q::Quaternion, v::AbstractVector) =
    Quaternion(           - q.q1*v[1] - q.q2*v[2] - q.q3*v[3],
               q.q0*v[1]              + q.q2*v[3] - q.q3*v[2],
               q.q0*v[2] - q.q1*v[3]              + q.q3*v[1],
               q.q0*v[3] + q.q1*v[2] - q.q2*v[1]             )

"""
    @inline function *(u::UniformScaling, q::Quaternion)
    @inline function *(q::Quaternion, u::UniformScaling)

Compute `qu*q` or `q*qu` (Hamilton product), in which `qu` is the scaled
identity quaternion `qu = u.λ * I`.

"""
@inline *(u::UniformScaling, q::Quaternion) = Quaternion(u)*q
@inline *(q::Quaternion, u::UniformScaling) = q*Quaternion(u)

# Operation: /
# ==============================================================================

"""
    @inline function /(λ::Number, q::Quaternion)
    @inline function /(q::Quaternion, λ::Number)

Compute the division `λ/q` or `q/λ`, in which `λ` is a scalar.

"""
@inline function /(λ::Number, q::Quaternion)
    # Compute `λ*(1/q)`.
    norm_q² = q.q0*q.q0 + q.q1*q.q1 + q.q2*q.q2 + q.q3*q.q3
    Quaternion(λ*q.q0/norm_q², -λ*q.q1/norm_q², -λ*q.q2/norm_q², -λ*q.q3/norm_q²)
end

@inline /(q::Quaternion, λ::Number) = q*(1/λ)

"""
    @inline /(q1::Quaternion, q2::Quaternion) = q1*inv(q2)

Compute `q1*inv(q2)` (Hamilton product).

"""
@inline /(q1::Quaternion, q2::Quaternion) = q1*inv(q2)

"""
    @inline function /(u::UniformScaling, q::Quaternion)
    @inline function /(q::Quaternion, u::UniformScaling)

Compute `qu/q` or `q/qu` (Hamilton product), in which `qu` is the scaled
identity quaternion `qu = u.λ * I`.

"""
@inline /(u::UniformScaling, q::Quaternion) = Quaternion(u)/q
@inline /(q::Quaternion, u::UniformScaling) = q/Quaternion(u)

# Operation: \
# ==============================================================================

"""
    @inline \\(q1::Quaternion, q2::Quaternion) = inv(q1)*q2

Compute `inv(q1)*q2`.

"""
@inline \(q1::Quaternion, q2::Quaternion) = inv(q1)*q2

"""
    @inline \\(q::Quaternion, v::AbstractVector)
    @inline \\(v::AbstractVector, q::Quaternion)

Compute `inv(q)*qv` or `inv(qv)*q` in which `qv` is a quaternion with real part
`0` and vectorial/imaginary part `v` (Hamilton product).

"""
@inline \(q::Quaternion,     v::AbstractVector) = inv(q)*v
@inline \(v::AbstractVector, q::Quaternion)     = inv(Quaternion(v))*q

"""
    @inline function \\(u::UniformScaling, q::Quaternion)
    @inline function \\(q::Quaternion, u::UniformScaling)

Compute `inv(qu)*q` or `inv(q)*qu` (Hamilton product), in which `qu` is the
scaled identity quaternion `qu = u.λ * I`.

"""
@inline \(u::UniformScaling, q::Quaternion) = inv(Quaternion(u))*q
@inline \(q::Quaternion, u::UniformScaling) = inv(q)*Quaternion(u)

# Operation: [:]
# ==============================================================================

"""
    @inline function getindex(q::Quaternion, ::Colon)

Transform the quaternion into a 4x1 vector of type `T`.

"""
@inline getindex(q::Quaternion, ::Colon) = [q.q0;q.q1;q.q2;q.q3]

################################################################################
#                                  Functions
################################################################################

"""
    @inline function conj(q::Quaternion)

Compute the complex conjugate of the quaternion `q`:

    q0 - q1.i - q2.j - q3.k

"""
@inline conj(q::Quaternion) = Quaternion(q.q0, -q.q1, -q.q2, -q.q3)

"""
    @inline function copy(q::Quaternion{T}) where T

Create a copy of the quaternion `q`.

"""
@inline copy(q::Quaternion{T}) where T = Quaternion{T}(q.q0, q.q1, q.q2, q.q3)

"""
    @inline function imag(q::Quaternion)

Return the vectorial or imaginary part of the quaternion `q` represented by a
3 × 1 vector of type `SVector{3}`.

"""
@inline imag(q::Quaternion) = SVector{3}(q.q1, q.q2, q.q3)

"""
    @inline function inv(q::Quaternion)

Compute the inverse of the quaternion `q`:

    conj(q)
    -------
      |q|²

"""
@inline function inv(q::Quaternion)
    # Compute the inverse of the quaternion.
    norm_q² = q.q0*q.q0 + q.q1*q.q1 + q.q2*q.q2 + q.q3*q.q3
    Quaternion(q.q0/norm_q², -q.q1/norm_q², -q.q2/norm_q², -q.q3/norm_q²)
end

"""
    @inline function norm(q::Quaternion)

Compute the Euclidean norm of the quaternion `q`:

    sqrt(q0² + q1² + q2² + q3²)

"""
@inline norm(q::Quaternion) = sqrt(q.q0*q.q0 + q.q1*q.q1 + q.q2*q.q2 + q.q3*q.q3)

"""
    @inline function real(q::Quaternion)

Return the real part of the quaternion `q`: `q0`.

"""
@inline real(q::Quaternion) = q.q0

"""
    @inline function vect(q::Quaternion)

Return the vectorial or imaginary part of the quaternion `q` represented by a
3 × 1 vector of type `SVector{3}`.

"""
@inline vect(q::Quaternion) = SVector{3}(q.q1, q.q2, q.q3)

"""
    @inline function zeros(::Type{Quaternion{T}}) where T

Create the null quaternion of type `T`:

    T(0) + T(0).i + T(0).j + T(0).k

If the type `T` is omitted, then it defaults to `Float64`.

# Example

```julia-repl
julia> zeros(Quaternion{Float32})
Quaternion{Float32}:
  + 0.0 + 0.0.i + 0.0.j + 0.0.k

julia> zeros(Quaternion)
Quaternion{Float64}:
  + 0.0 + 0.0.i + 0.0.j + 0.0.k
```

"""
@inline zeros(::Type{Quaternion{T}}) where T =
    Quaternion{T}(T(0), T(0), T(0), T(0))

@inline zeros(::Type{Quaternion}) = Quaternion{Float64}(0.0,0.0,0.0,0.0)

"""
    @inline function zeros(q::Quaternion{T}) where T

Create the null quaternion with the same type `T` of another quaternion `q`:

    T(0) + T(0).i + T(0).j + T(0).k

# Example

```julia-repl
julia> q1 = Quaternion{Float32}(cosd(45/2),sind(45/2),0,0);

julia> zeros(q1)
Quaternion{Float32}:
  + 0.0 + 0.0.i + 0.0.j + 0.0.k
```

"""
@inline zeros(q::Quaternion{T}) where T = zeros(Quaternion{T})

################################################################################
#                                      IO
################################################################################

"""
    function show(io::IO, q::Quaternion{T}) where T
    function show(io::IO, mime::MIME"text/plain", q::Quaternion{T}) where T

Print the quaternion `q` to the stream `io`.

"""
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

    nothing
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

    nothing
end

################################################################################
#                                 Conversions
################################################################################

# Direction Cosine Matrix
# ==============================================================================

"""
    function quat_to_dcm(q::Quaternion)

Convert the quaternion `q` to a Direction Cosine Matrix (DCM).

# Example

```julia-repl
julia> q = Quaternion(cosd(45/2), sind(45/2), 0, 0);

julia> quat_to_dcm(q)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
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

    DCM(q0^2+q1^2-q2^2-q3^2,   2(q1*q2+q0*q3)   ,   2(q1*q3-q0*q2),
          2(q1*q2-q0*q3)   , q0^2-q1^2+q2^2-q3^2,   2(q2*q3+q0*q1),
          2(q1*q3+q0*q2)   ,   2(q2*q3-q0*q1)   , q0^2-q1^2-q2^2+q3^2)'
end

# Euler Angle and Axis
# ==============================================================================

"""
    function quat_to_angleaxis(q::Quaternion{T}) where T

Convert the quaternion `q` to a Euler angle and axis representation (see
`EulerAngleAxis`). By convention, the Euler angle will be kept between [0, π]
rad.

# Remarks

This function will not fail if the quaternion norm is not 1. However, the
meaning of the results will not be defined, because the input quaternion does
not represent a 3D rotation. The user must handle such situations.

# Example

```julia-repl
julia> q = Quaternion(cosd(45/2), sind(45/2), 0, 0);

julia> quat_to_angleaxis(q)
EulerAngleAxis{Float64}(0.7853981633974484, [1.0, 0.0, 0.0])
```

"""
function quat_to_angleaxis(q::Quaternion{T}) where T

    # If `q0` is 1 or -1, then we have an identity rotation.
    if abs(q.q0) >= 1 - eps()
        return EulerAngleAxis( T(0), SVector{3,T}(0, 0, 0) )
    else
        # Compute sin(θ/2).
        sθo2 = sqrt( q.q1*q.q1 + q.q2*q.q2 + q.q3*q.q3 )

        # Compute θ in range [0, 2π].
        θ = 2acos(q.q0)

        # Keep θ between [0, π].
        s = +1
        if θ > π
            θ = 2π - θ
            s = -1
        end

        return EulerAngleAxis( θ, s*[q.q1, q.q2, q.q3]/sθo2 )
    end

end

# Euler Angles
# ==============================================================================

"""
    function quat_to_angle(q::Quaternion, rot_seq::Symbol = :ZYX)

Convert the quaternion `q` to Euler Angles (see `EulerAngles`) given a rotation
sequence `rot_seq`.

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`. If no value is specified, then it defaults to `:ZYX`.

# Example

```julia-repl
julia> q = Quaternion(cosd(45/2), sind(45/2), 0, 0);

julia> quat_to_angle(q,:XYZ)
EulerAngles{Float64}(0.7853981633974484, 0.0, -0.0, :XYZ)
```

"""
function quat_to_angle(q::Quaternion, rot_seq::Symbol=:ZYX)
    # TODO: This function calls uses `angle_to_dcm` to convert the quaternion to
    # a Direction Cosine Matrix. It **must** be rewritten to avoid this
    # intermediate step to increase the performance.

    # Convert the quaternion to DCM.
    dcm = quat_to_dcm(q)

    # Convert the DCM to the Euler Angles.
    dcm_to_angle(dcm, rot_seq)
end

################################################################################
#                                  Kinematics
################################################################################

"""
    function dquat(qba::Quaternion, wba_b::AbstractVector)

Compute the time-derivative of the quaternion `qba` that rotates a reference
frame `a` into alignment to the reference frame `b` in which the angular
velocity of `b` with respect to `a`, and represented in `b`, is `wba_b`.

# Example

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

    Quaternion(               -w[1]/2*qba.q1 -w[2]/2*qba.q2 -w[3]/2*qba.q3,
               +w[1]/2*qba.q0                +w[3]/2*qba.q2 -w[2]/2*qba.q3,
               +w[2]/2*qba.q0 -w[3]/2*qba.q1                +w[1]/2*qba.q3,
               +w[3]/2*qba.q0 +w[2]/2*qba.q1 -w[1]/2*qba.q2                )
end
