################################################################################
#                             Euler Angle and Axis
################################################################################

export angleaxis_to_angle, angleaxis_to_dcm, angleaxis_to_quat

################################################################################
#                                  Operations
################################################################################

"""
    function *(ea₂::EulerAngleAxis{T1}, ea₁::EulerAngleAxis{T2}) where {T1,T2}

Compute the composed rotation of `ea₁ -> ea₂`. Notice that the rotation will be
represented by a Euler angle and axis (see `EulerAngleAxis`). By convention, the
output angle will always be in the range [0, π] [rad].

Notice that the vector representing the axis in `ea₁` and `ea₂` must be unitary.
This function neither verifies this nor normalizes the vector.

"""
function *(ea₂::EulerAngleAxis{T1}, ea₁::EulerAngleAxis{T2}) where {T1,T2}
    # Auxiliary variables.
    sθ₁o2, cθ₁o2 = sincos(ea₁.a/2)
    sθ₂o2, cθ₂o2 = sincos(ea₂.a/2)

    v₁ = ea₁.v
    v₂ = ea₂.v

    # Compute `cos(θ/2)` in which `θ` is the new Euler angle.
    cθo2 = cθ₁o2*cθ₂o2 - sθ₁o2*sθ₂o2 * dot(v₁, v₂)

    T = promote_type( T1, T2, typeof(sθ₁o2), typeof(sθ₂o2), typeof(cθo2) )

    if abs(cθo2) >= 1-eps()
        # In this case, the rotation is the identity.
        return EulerAngleAxis( T(0), SVector{3,T}(0,0,0) )
    else
        # Compute `sin(θ/2)` in which `θ` is the new Euler angle.
        sθo2 = sqrt(1 - cθo2*cθo2)

        # Compute the θ angle between [0, 2π].
        θ = 2acos(cθo2)

        # Keep the angle between [0, π].
        s = +1
        if θ > π
            θ = T(2)*π - θ
            s = -1
        end

        v = s*( sθ₁o2*cθ₂o2*v₁ + cθ₁o2*sθ₂o2*v₂ + sθ₁o2*sθ₂o2*(v₁ × v₂) )/sθo2

        return EulerAngleAxis(θ, v)
    end
end

"""
    @inline function inv(ea::EulerAngleAxis)

Compute the inverse rotation of `ea`. The Euler angle returned by this function
will always be in the interval [0, π].

"""
@inline function inv(ea::EulerAngleAxis{T}) where T<:Number
    # Make sure that the Euler angle is always in the inverval [0,π]
    s = -1
    θ = mod(ea.a, T(2)*π)

    if θ > π
        s = 1
        θ = T(2)π - θ
    end

    EulerAngleAxis(θ, s*ea.v)
end

################################################################################
#                                      IO
################################################################################

"""
    function display(ea::EulerAngleAxis{T}) where T
    function show(io::IO, mime::MIME"text/plain", ea::EulerAngleAxis{T}) where T

Display in `stdout` the Euler angle and axis `ea`.

"""
function show(io::IO, ea::EulerAngleAxis{T}) where T
    θ   = ea.a
    v   = ea.v
    str = @sprintf "%8.4f rad, [%8.4f, %8.4f, %8.4f]" ea.a v[1] v[2] v[3]

    print(io, "EulerAngleAxis{$T}: $str")

    nothing
end

function show(io::IO, mime::MIME"text/plain", ea::EulerAngleAxis{T}) where T
    # Check if the user wants colors.
    color = get(io, :color, false)

    y = (color) ? _y : ""
    d = (color) ? _d : ""

    str_a = @sprintf "%8.4f rad (%8.4f deg)" ea.a rad2deg(ea.a)
    str_v = @sprintf "[%8.4f, %8.4f, %8.4f]" ea.v[1] ea.v[2] ea.v[3]

    println(io, "EulerAngleAxis{$T}:")
    println(io, "$y  Euler angle: $d" * str_a)
      print(io, "$y   Euler axis: $d" * str_v)

    nothing
end

################################################################################
#                                 Conversions
################################################################################

# Euler Angles
# ==============================================================================

"""
    @inline function angleaxis_to_angle(θ::Number, v::AbstractVector, rot_seq::Symbol)
    @inline function angleaxis_to_angle(ea::EulerAngleAxis, rot_seq::Symbol)

Convert the Euler angle `θ` [rad]  and Euler axis `v`, which must be a unit
vector, to Euler angles with rotation sequence `rot_seq`. Those values can also
be passed inside the structure `ea` (see `EulerAngleAxis`).

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`. If no value is specified, then it defaults to `:ZYX`.

# Example

```julia-repl
julia> ea = EulerAngleAxis(45*pi/180, [1;0;0]);

julia> angleaxis_to_angles(ea, :ZXY)
EulerAngles{Float64}:
  R(Z):   0.0000 rad (   0.0000 deg)
  R(X):   0.7854 rad (  45.0000 deg)
  R(Y):   0.0000 rad (   0.0000 deg)

```
"""
@inline function angleaxis_to_angle(θ::Number, v::AbstractVector, rot_seq::Symbol)
    # First we convert to quaternions then to Euler angles.
    quat_to_angle( angleaxis_to_quat(θ, v), rot_seq )
end

@inline angleaxis_to_angle(ea::EulerAngleAxis, rot_seq::Symbol) =
    angleaxis_to_angle(ea.a, ea.v, rot_seq)


# DCM
# ==============================================================================

"""
    @inline function angleaxis_to_dcm(a::Number, v::AbstractVector)
    @inline function angleaxis_to_dcm(ea::EulerAngleAxis)

Convert the Euler angle `a` [rad] and Euler axis `v`, which must be a unit
vector to a DCM. Those values can also be passed inside the structure `ea` (see
`EulerAngleAxis`).

# Remarks

It is expected that the vector `v` is unitary. However, no verification is
performed inside the function. The user must handle this situation.

# Example

```julia-repl
julia> v = [1;1;1];

julia> v /= norm(v);

julia> angleaxis_to_dcm(pi/2,v)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  0.333333   0.910684  -0.244017
 -0.244017   0.333333   0.910684
  0.910684  -0.244017   0.333333

julia> ea = EulerAngleAxis(pi/2,v);

julia> angleaxis_to_dcm(ea)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  0.333333   0.910684  -0.244017
 -0.244017   0.333333   0.910684
  0.910684  -0.244017   0.333333
```

"""
@inline function angleaxis_to_dcm(a::Number, v::AbstractVector)
    sθ, cθ = sincos(a)
    aux    = 1 - cθ

    DCM(  cθ + v[1]*v[1]*aux   , v[1]*v[2]*aux + v[3]*sθ, v[1]*v[3]*aux - v[2]*sθ,
        v[1]*v[2]*aux - v[3]*sθ,    cθ + v[2]*v[2]*aux  , v[2]*v[3]*aux + v[1]*sθ,
        v[1]*v[3]*aux + v[2]*sθ, v[2]*v[3]*aux - v[1]*sθ,   cθ + v[3]*v[3]*aux)'
end

@inline angleaxis_to_dcm(ea::EulerAngleAxis) = angleaxis_to_dcm(ea.a, ea.v)

# Quaternions
# ==============================================================================

"""
    function angleaxis_to_quat(θ::Number, v::AbstractVector)

Convert the Euler angle `θ` [rad] and Euler axis `v`, which must be a unit
vector, to a quaternion.

# Remarks

It is expected that the vector `v` is unitary. However, no verification is
performed inside the function. The user must handle this situation.

# Example

```julia-repl
julia> v = [1;1;1];

julia> v /= norm(v);

julia> angleaxis_to_quat(pi/2,v)
Quaternion{Float64}:
  + 0.7071067811865476 + 0.408248290463863.i + 0.408248290463863.j + 0.408248290463863.k
```

"""
function angleaxis_to_quat(θ::Number, v::AbstractVector)
    # Check the arguments.
    (length(v) > 3) && throw(ArgumentError("The provided vector for the Euler axis must have 3 elements."))

    cθo2 = cos(θ/2)

    # Keep `q0` positive.
    s = (cθo2 < 0) ? -1 : +1

    # Create the quaternion.
    Quaternion( s*cos(θ/2), s*sin(θ/2)*v )
end

"""
    function angleaxis_to_quat(angleaxis::EulerAngleAxis)

Convert a Euler angle and Euler axis `angleaxis` (see `EulerAngleAxis`) to a
quaternion.

# Remarks

It is expected that the vector `angleaxis.v` is unitary. However, no
verification is performed inside the function. The user must handle this
situation.

# Example

```julia-repl
julia> v = [1;1;1];

julia> v /= norm(v);

julia> angleaxis_to_quat(EulerAngleAxis(pi/2,v))
Quaternion{Float64}:
  + 0.7071067811865476 + 0.408248290463863.i + 0.408248290463863.j + 0.408248290463863.k
```

"""
angleaxis_to_quat(angleaxis::EulerAngleAxis) = angleaxis_to_quat(angleaxis.a,
                                                                 angleaxis.v)
