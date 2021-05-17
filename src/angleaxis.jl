# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the Euler angle and axis.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export angleaxis_to_angle, angleaxis_to_dcm, angleaxis_to_quat

################################################################################
#                                  Operations
################################################################################

"""
    *(av₂::EulerAngleAxis{T1}, av₁::EulerAngleAxis{T2}) where {T1,T2}

Compute the composed rotation of `av₁ -> av₂`.

The rotation will be represented by a Euler angle and axis (see
[`EulerAngleAxis`](@ref)). By convention, the output angle will always be in the
range `[0, π] rad`.

Notice that the vector representing the axis in `av₁` and `av₂` must be unitary.
This function neither verifies this nor normalizes the vector.

# Examples

```julia-repl
julia> av1 = EulerAngleAxis(deg2rad(45), [sqrt(2)/2, sqrt(2)/2, 0])
EulerAngleAxis{Float64}:
  Euler angle:   0.7854 rad ( 45.0000 deg)
   Euler axis: [  0.7071,   0.7071,   0.0000]

julia> av2 = EulerAngleAxis(deg2rad(22.5), [sqrt(2)/2, sqrt(2)/2, 0])
EulerAngleAxis{Float64}:
  Euler angle:   0.3927 rad ( 22.5000 deg)
   Euler axis: [  0.7071,   0.7071,   0.0000]

julia> av1 * av2
EulerAngleAxis{Float64}:
  Euler angle:   1.1781 rad ( 67.5000 deg)
   Euler axis: [  0.7071,   0.7071,   0.0000]
```
"""
function *(av₂::EulerAngleAxis{T1}, av₁::EulerAngleAxis{T2}) where {T1, T2}
    # Auxiliary variables.
    sθ₁o2, cθ₁o2 = sincos(av₁.a / 2)
    sθ₂o2, cθ₂o2 = sincos(av₂.a / 2)

    v₁ = av₁.v
    v₂ = av₂.v

    # Compute `cos(θ/2)` in which `θ` is the new Euler angle.
    cθo2 = cθ₁o2 * cθ₂o2 - sθ₁o2 * sθ₂o2 * dot(v₁, v₂)

    T = promote_type(T1, T2, typeof(sθ₁o2), typeof(sθ₂o2), typeof(cθo2))

    if abs(cθo2) >= 1 - eps()
        # In this case, the rotation is the identity.
        return EulerAngleAxis(T(0), SVector{3,T}(0, 0, 0))
    else
        # Compute `sin(θ/2)` in which `θ` is the new Euler angle.
        sθo2 = √(1 - cθo2 * cθo2)

        # Compute the θ angle between [0, 2π].
        θ = 2acos(cθo2)

        # Keep the angle between [0, π].
        s = +1
        if θ > π
            θ = T(2π) - θ
            s = -1
        end

        v = s * (sθ₁o2 * cθ₂o2 * v₁ + cθ₁o2 * sθ₂o2 * v₂ + sθ₁o2 * sθ₂o2 * (v₁ × v₂)) / sθo2

        return EulerAngleAxis(θ, v)
    end
end

"""
    inv(av::EulerAngleAxis)

Compute the inverse rotation of the Euler angle and axis `av`.

The Euler angle returned by this function will always be in the interval `[0, π]
rad`.

# Examples

```julia-repl
julia> av = EulerAngleAxis(deg2rad(20), [sqrt(2)/2, 0, sqrt(2)/2])
EulerAngleAxis{Float64}:
  Euler angle:   0.3491 rad ( 20.0000 deg)
   Euler axis: [  0.7071,   0.0000,   0.7071]

julia> inv(av)
EulerAngleAxis{Float64}:
  Euler angle:   0.3491 rad ( 20.0000 deg)
   Euler axis: [ -0.7071,  -0.0000,  -0.7071]

julia> av = EulerAngleAxis(deg2rad(-20), [sqrt(2)/2, 0, sqrt(2)/2])
EulerAngleAxis{Float64}:
  Euler angle:  -0.3491 rad (-20.0000 deg)
   Euler axis: [  0.7071,   0.0000,   0.7071]

julia> inv(av)
EulerAngleAxis{Float64}:
  Euler angle:   0.3491 rad ( 20.0000 deg)
   Euler axis: [  0.7071,   0.0000,   0.7071]
```
"""
@inline function inv(av::EulerAngleAxis{T}) where T<:Number
    # Make sure that the Euler angle is always in the inverval [0,π]
    s = -1
    θ = mod(av.a, T(2π))

    if θ > π
        s = 1
        θ = T(2π) - θ
    end

    return EulerAngleAxis(θ, s*av.v)
end

################################################################################
#                                      IO
################################################################################

function show(io::IO, av::EulerAngleAxis{T}) where T
    θ   = av.a
    v   = av.v
    str = @sprintf "%8.4f rad, [%8.4f, %8.4f, %8.4f]" av.a v[1] v[2] v[3]

    print(io, "EulerAngleAxis{$T}: $str")

    return nothing
end

function show(io::IO, mime::MIME"text/plain", av::EulerAngleAxis{T}) where T
    # Check if the user wants colors.
    color = get(io, :color, false)

    y = (color) ? _y : ""
    d = (color) ? _d : ""

    str_a = @sprintf "%8.4f rad (%8.4f deg)" av.a rad2deg(av.a)
    str_v = @sprintf "[%8.4f, %8.4f, %8.4f]" av.v[1] av.v[2] av.v[3]

    println(io, "EulerAngleAxis{$T}:")
    println(io, "$y  Euler angle: $d" * str_a)
      print(io, "$y   Euler axis: $d" * str_v)

    return nothing
end

################################################################################
#                                 Conversions
################################################################################

# Euler Angles
# ==============================================================================

"""
    angleaxis_to_angle(θ::Number, v::AbstractVector, rot_seq::Symbol)
    angleaxis_to_angle(av::EulerAngleAxis, rot_seq::Symbol)

Convert the Euler angle `θ` [rad]  and Euler axis `v` to Euler angles with
rotation sequence `rot_seq`.

Those values can also be passed inside the structure `av` (see
[`EulerAngleAxis`](@ref)).

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`. If no value is specified, then it defaults to `:ZYX`.

!!! warning
    It is expected that the vector `v` is unitary. However, no verification is
    performed inside the function. The user must handle this situation.

# Example

```julia-repl
julia> av = EulerAngleAxis(deg2rad(45), [1, 0, 0])
EulerAngleAxis{Float64}:
  Euler angle:   0.7854 rad ( 45.0000 deg)
   Euler axis: [  1.0000,   0.0000,   0.0000]

julia> angleaxis_to_angle(av, :ZXY)
EulerAngles{Float64}:
  R(Z):   0.0000 rad (   0.0000 deg)
  R(X):   0.7854 rad (  45.0000 deg)
  R(Y):   0.0000 rad (   0.0000 deg)
```
"""
@inline function angleaxis_to_angle(θ::Number, v::AbstractVector, rot_seq::Symbol)
    # Check the arguments.
    (length(v) ≠ 3) && throw(ArgumentError("The provided vector for the Euler axis must have 3 elements."))

    # First we convert to DCM then to Euler angles.
    return dcm_to_angle(angleaxis_to_dcm(θ, v), rot_seq)
end

@inline function angleaxis_to_angle(av::EulerAngleAxis, rot_seq::Symbol)
    return angleaxis_to_angle(av.a, av.v, rot_seq)
end

# DCM
# ==============================================================================

"""
    angleaxis_to_dcm(a::Number, v::AbstractVector)
    angleaxis_to_dcm(av::EulerAngleAxis)

Convert the Euler angle `a` [rad] and Euler axis `v` to a DCM.

Those values can also be passed inside the structure `ea` (see
[`EulerAngleAxis`](@ref)).

!!! warning
    It is expected that the vector `v` is unitary. However, no verification is
    performed inside the function. The user must handle this situation.

# Example

```julia-repl
julia> v = [1, 1, 1];

julia> v /= norm(v);

julia> angleaxis_to_dcm(pi / 2, v)
3×3 StaticArrays.SMatrix{3, 3, Float64, 9} with indices SOneTo(3)×SOneTo(3):
  0.333333   0.910684  -0.244017
 -0.244017   0.333333   0.910684
  0.910684  -0.244017   0.333333

julia> ea = EulerAngleAxis(pi / 2, v);

julia> angleaxis_to_dcm(ea)
3×3 StaticArrays.SMatrix{3, 3, Float64, 9} with indices SOneTo(3)×SOneTo(3):
  0.333333   0.910684  -0.244017
 -0.244017   0.333333   0.910684
  0.910684  -0.244017   0.333333
```
"""
@inline function angleaxis_to_dcm(a::Number, v::AbstractVector)
    # Check the arguments.
    (length(v) ≠ 3) && throw(ArgumentError("The provided vector for the Euler axis must have 3 elements."))

    sθ, cθ = sincos(a)
    aux    = 1 - cθ

    return DCM(
          cθ + v[1] * v[1] * aux,      v[1] * v[2] * aux + v[3] * sθ, v[1] * v[3] * aux - v[2] * sθ,
        v[1] * v[2] * aux - v[3] * sθ,   cθ + v[2] * v[2] * aux,      v[2] * v[3] * aux + v[1] * sθ,
        v[1] * v[3] * aux + v[2] * sθ, v[2] * v[3] * aux - v[1] * sθ,   cθ + v[3] * v[3] * aux
    )'
end

@inline angleaxis_to_dcm(av::EulerAngleAxis) = angleaxis_to_dcm(av.a, av.v)

# Quaternions
# ==============================================================================

"""
    angleaxis_to_quat(θ::Number, v::AbstractVector)
    angleaxis_to_quat(angleaxis::EulerAngleAxis)

Convert the Euler angle `θ` [rad] and Euler axis `v` to a quaternion.

Those values can also be passed inside the structure `ea` (see
[`EulerAngleAxis`](@ref)).

!!! warning
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
@inline function angleaxis_to_quat(θ::Number, v::AbstractVector)
    # Check the arguments.
    (length(v) ≠ 3) && throw(ArgumentError("The provided vector for the Euler axis must have 3 elements."))

    sθo2, cθo2 = sincos(θ / 2)

    # Keep `q0` positive.
    s = (cθo2 < 0) ? -1 : +1

    # Create the quaternion.
    return Quaternion(s * cθo2, s * sθo2 * v)
end

@inline angleaxis_to_quat(av::EulerAngleAxis) = angleaxis_to_quat(av.a, av.v)
