################################################################################
#                                 Euler Angles
################################################################################

export angle_to_dcm,      angle_to_quat,      angle_to_rot
export smallangle_to_dcm, smallangle_to_quat, smallangle_to_rot
export inv

################################################################################
#                                  Operations
################################################################################

"""
    function *(Θ₂::EulerAngles, Θ₁::EulerAngles)

Compute the composed rotation of `Θ₁ -> Θ₂`. Notice that the rotation will be
represented by Euler angles (see `EulerAngles`) with the same rotation sequence
as `Θ₂`.

"""
@inline function *(Θ₂::EulerAngles, Θ₁::EulerAngles)
    # Convert to quaternions, compute the composition, and convert back to Euler
    # angles.
    q₁ = angle_to_quat(Θ₁)
    q₂ = angle_to_quat(Θ₂)

    quat_to_angle(q₁*q₂, Θ₂.rot_seq)
end

"""
    function inv(Θ::EulerAngles)

Return the Euler angles that represent the inverse rotation of `Θ`. Notice that
the rotation sequence of the result will be the inverse of the input. Hence, if
the input rotation sequence is, for example, `:XYZ`, then the result will be
represented using `:ZYX`.

"""
function inv(Θ::EulerAngles)
    # Check what will be the inverse rotation.
    if Θ.rot_seq == :XYZ
        inv_rot_seq = :ZYX
    elseif Θ.rot_seq == :XZY
        inv_rot_seq = :YZX
    elseif Θ.rot_seq == :YXZ
        inv_rot_seq = :ZXY
    elseif Θ.rot_seq == :YZX
        inv_rot_seq = :XZY
    elseif Θ.rot_seq == :ZXY
        inv_rot_seq = :YXZ
    elseif Θ.rot_seq == :ZYX
        inv_rot_seq = :XYZ
    else
        inv_rot_seq = Θ.rot_seq
    end

    # Return the Euler angle that represented the inverse rotation.
    EulerAngles(-Θ.a3, -Θ.a2, -Θ.a1, inv_rot_seq)
end

################################################################################
#                                 Conversions
################################################################################

# Direction Cosine Matrix
# ==============================================================================

"""
    function angle_to_dcm(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol = :ZYX)

Convert the Euler angles `θ₁`, `θ₂`, and `θ₃` [rad] with the rotation sequence
`rot_seq` to a direction cosine matrix.

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`. If no value is specified, then it defaults to `:ZYX`.

# Remarks

This function assigns `dcm = A3 * A2 * A1` in which `Ai` is the DCM related with
the *i*-th rotation, `i Є [1,2,3]`.

# Example

```julia-repl
dcm = angle_to_dcm(pi/2, pi/3, pi/4, :ZYX)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  3.06162e-17  0.5       -0.866025
 -0.707107     0.612372   0.353553
  0.707107     0.612372   0.353553
```

"""
function angle_to_dcm(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol = :ZYX)

    # Compute the sines and cosines.
    s₁, c₁ = sincos(θ₁)
    s₂, c₂ = sincos(θ₂)
    s₃, c₃ = sincos(θ₃)

    if rot_seq == :ZYX
        return DCM(       c₂*c₁    ,        c₂*s₁    , -s₂  ,
                   s₃*s₂*c₁ - c₃*s₁, s₃*s₂*s₁ + c₃*c₁, s₃*c₂,
                   c₃*s₂*c₁ + s₃*s₁, c₃*s₂*s₁ - s₃*c₁, c₃*c₂)'

    elseif rot_seq == :XYX
        return DCM( c₂  ,         s₁*s₂    ,       -c₁*s₂    ,
                   s₂*s₃, -s₁*c₂*s₃ + c₁*c₃, c₁*c₂*s₃ + s₁*c₃,
                   s₂*c₃, -s₁*c₃*c₂ - c₁*s₃, c₁*c₃*c₂ - s₁*s₃)'

    elseif rot_seq == :XYZ
        return DCM( c₂*c₃,  s₁*s₂*c₃ + c₁*s₃, -c₁*s₂*c₃ + s₁*s₃,
                   -c₂*s₃, -s₁*s₂*s₃ + c₁*c₃,  c₁*s₂*s₃ + s₁*c₃,
                      s₂ ,        -s₁*c₂    ,       c₁*c₂)'

    elseif rot_seq == :XZX
        return DCM(   c₂ ,         c₁*s₂    ,         s₁*s₂    ,
                   -s₂*c₃,  c₁*c₃*c₂ - s₁*s₃,  s₁*c₃*c₂ + c₁*s₃,
                    s₂*s₃, -c₁*c₂*s₃ - s₁*c₃, -s₁*c₂*s₃ + c₁*c₃)'

    elseif rot_seq == :XZY
        return DCM(c₃*c₂, c₁*c₃*s₂ + s₁*s₃, s₁*c₃*s₂ - c₁*s₃,
                    -s₂ ,        c₁*c₂    ,        s₁*c₂    ,
                   s₃*c₂, c₁*s₂*s₃ - s₁*c₃, s₁*s₂*s₃ + c₁*c₃)'

    elseif rot_seq == :YXY
        return DCM(-s₁*c₂*s₃ + c₁*c₃, s₂*s₃ , -c₁*c₂*s₃ - s₁*c₃,
                          s₁*s₂    ,   c₂  ,         c₁*s₂    ,
                   s₁*c₃*c₂ + c₁*s₃, -s₂*c₃,  c₁*c₃*c₂ - s₁*s₃)'

    elseif rot_seq == :YXZ
        return DCM( c₁*c₃ + s₂*s₁*s₃, c₂*s₃, -s₁*c₃ + s₂*c₁*s₃,
                   -c₁*s₃ + s₂*s₁*c₃, c₂*c₃,  s₁*s₃ + s₂*c₁*c₃,
                        s₁*c₂       ,  -s₂ ,      c₂*c₁       )'

    elseif rot_seq == :YZX
        return DCM(        c₁*c₂    ,    s₂ ,        -s₁*c₂    ,
                   -c₃*c₁*s₂ + s₃*s₁,  c₂*c₃,  c₃*s₁*s₂ + s₃*c₁,
                    s₃*c₁*s₂ + c₃*s₁, -s₃*c₂, -s₃*s₁*s₂ + c₃*c₁)'

    elseif rot_seq == :YZY
        return DCM(c₁*c₃*c₂ - s₁*s₃, s₂*c₃, -s₁*c₃*c₂ - c₁*s₃,
                         -c₁*s₂    ,   c₂ ,         s₁*s₂    ,
                   c₁*c₂*s₃ + s₁*c₃, s₂*s₃, -s₁*c₂*s₃ + c₁*c₃)'

    elseif rot_seq == :ZXY
        return DCM(c₃*c₁ - s₂*s₃*s₁, c₃*s₁ + s₂*s₃*c₁, -s₃*c₂,
                      -c₂*s₁       ,     c₂*c₁       ,    s₂ ,
                   s₃*c₁ + s₂*c₃*s₁, s₃*s₁ - s₂*c₃*c₁,  c₂*c₃)'

    elseif rot_seq == :ZXZ
        return DCM(-s₁*c₂*s₃ + c₁*c₃, c₁*c₂*s₃ + s₁*c₃, s₂*s₃,
                   -s₁*c₃*c₂ - c₁*s₃, c₁*c₃*c₂ - s₁*s₃, s₂*c₃,
                           s₁*s₂    ,       -c₁*s₂    ,  c₂)'

    elseif rot_seq == :ZYZ
        return DCM( c₁*c₃*c₂ - s₁*s₃,  s₁*c₃*c₂ + c₁*s₃, -s₂*c₃,
                   -c₁*c₂*s₃ - s₁*c₃, -s₁*c₂*s₃ + c₁*c₃,  s₂*s₃,
                           c₁*s₂    ,         s₁*s₂    ,    c₂)'
    else
        throw(ArgumentError("The rotation sequence :$rot_seq is not valid."))
    end
end

"""
    function angle_to_dcm(Θ::EulerAngles)

Convert the Euler angles `Θ` (see `EulerAngles`) to a direction cosine matrix.

# Returns

The direction cosine matrix.

# Remarks

This function assigns `dcm = A3 * A2 * A1` in which `Ai` is the DCM related with
the *i*-th rotation, `i Є [1,2,3]`.

# Example

```julia-repl
julia> angle_to_dcm(EulerAngles(pi/2, pi/3, pi/4, :ZYX))
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  3.06162e-17  0.5       -0.866025
 -0.707107     0.612372   0.353553
  0.707107     0.612372   0.353553
```

"""
angle_to_dcm(Θ::EulerAngles) = angle_to_dcm(Θ.a1, Θ.a2, Θ.a3, Θ.rot_seq)

"""
    function smallangle_to_dcm(θx::Number, θy::Number, θz::Number)

Create a direction cosine matrix from three small rotations of angles `θx`,
`θy`, and `θz` [rad] about the axes X, Y, and Z, respectively.

# Remarks

No process of ortho-normalization is performed with the computed DCM.

# Example

```julia-repl
julia> smallangle_to_dcm(+0.01, -0.01, +0.01)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  1.0    0.01  0.01
 -0.01   1.0   0.01
 -0.01  -0.01  1.0
```

"""
smallangle_to_dcm(θx::Number, θy::Number, θz::Number) = DCM(  1, +θz, -θy,
                                                            -θz,   1, +θx,
                                                            +θy, -θx,   1)'

# Quaternion
# ==============================================================================

"""
    function angle_to_quat(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol = :ZYX)

Convert the Euler angles `θ₁`, `θ₂`, and `θ₃` [rad] with the rotation sequence
`rot_seq` to a quaternion.

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`. If no value is specified, then it defaults to `:ZYX`.

# Remarks

This function assigns `q = q1 * q2 * q3` in which `qi` is the quaternion related
with the *i*-th rotation, `i Є [1,2,3]`.

# Example

```julia-repl
julia> angle_to_quat(pi/2, pi/3, pi/4, :ZYX)
Quaternion{Float64}:
  + 0.7010573846499779 - 0.09229595564125714.i + 0.5609855267969309.j + 0.43045933457687935.k
```

"""
function angle_to_quat(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol = :ZYX)

    # Compute the sines and cosines of half angle.
    s₁, c₁ = sincos(θ₁/2)
    s₂, c₂ = sincos(θ₂/2)
    s₃, c₃ = sincos(θ₃/2)

    if rot_seq == :ZYX
        q0 = c₁*c₂*c₃ + s₁*s₂*s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(s*q0,
                          s*(c₁*c₂*s₃ - s₁*s₂*c₃),
                          s*(c₁*s₂*c₃ + s₁*c₂*s₃),
                          s*(s₁*c₂*c₃ - c₁*s₂*s₃))
    elseif rot_seq == :XYX
        q0 = c₁*c₂*c₃ - s₁*c₂*s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(s*q0,
                          s*(c₁*c₂*s₃ + s₁*c₂*c₃),
                          s*(c₁*s₂*c₃ + s₁*s₂*s₃),
                          s*(s₁*s₂*c₃ - c₁*s₂*s₃))
    elseif rot_seq == :XYZ
        q0 = c₁*c₂*c₃ - s₁*s₂*s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(s*q0,
                          s*(s₁*c₂*c₃ + c₁*s₂*s₃),
                          s*(c₁*s₂*c₃ - s₁*c₂*s₃),
                          s*(c₁*c₂*s₃ + s₁*s₂*c₃))
    elseif rot_seq == :XZX
        q0 = c₁*c₂*c₃ - s₁*c₂*s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(s*q0,
                          s*(c₁*c₂*s₃ + s₁*c₂*c₃),
                          s*(c₁*s₂*s₃ - s₁*s₂*c₃),
                          s*(c₁*s₂*c₃ + s₁*s₂*s₃))
    elseif rot_seq == :XZY
        q0 = c₁*c₂*c₃ + s₁*s₂*s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(s*q0,
                          s*(s₁*c₂*c₃ - c₁*s₂*s₃),
                          s*(c₁*c₂*s₃ - s₁*s₂*c₃),
                          s*(c₁*s₂*c₃ + s₁*c₂*s₃))
    elseif rot_seq == :YXY
        q0 = c₁*c₂*c₃ - s₁*c₂*s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(s*q0,
                          s*(c₁*s₂*c₃ + s₁*s₂*s₃),
                          s*(c₁*c₂*s₃ + s₁*c₂*c₃),
                          s*(c₁*s₂*s₃ - s₁*s₂*c₃))
    elseif rot_seq == :YXZ
        q0 = c₁*c₂*c₃ + s₁*s₂*s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(s*q0,
                          s*(c₁*s₂*c₃ + s₁*c₂*s₃),
                          s*(s₁*c₂*c₃ - c₁*s₂*s₃),
                          s*(c₁*c₂*s₃ - s₁*s₂*c₃))
    elseif rot_seq == :YZX
        q0 = c₁*c₂*c₃ - s₁*s₂*s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(s*q0,
                          s*(c₁*c₂*s₃ + s₁*s₂*c₃),
                          s*(s₁*c₂*c₃ + c₁*s₂*s₃),
                          s*(c₁*s₂*c₃ - s₁*c₂*s₃))
    elseif rot_seq == :YZY
        q0 = c₁*c₂*c₃ - s₁*c₂*s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(s*q0,
                          s*(s₁*s₂*c₃ - c₁*s₂*s₃),
                          s*(c₁*c₂*s₃ + s₁*c₂*c₃),
                          s*(c₁*s₂*c₃ + s₁*s₂*s₃))
    elseif rot_seq == :ZXY
        q0 = c₁*c₂*c₃ - s₁*s₂*s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(s*q0,
                          s*(c₁*s₂*c₃ - s₁*c₂*s₃),
                          s*(c₁*c₂*s₃ + s₁*s₂*c₃),
                          s*(s₁*c₂*c₃ + c₁*s₂*s₃))
    elseif rot_seq == :ZXZ
        q0 = c₁*c₂*c₃ - s₁*c₂*s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(s*q0,
                          s*(c₁*s₂*c₃ + s₁*s₂*s₃),
                          s*(s₁*s₂*c₃ - c₁*s₂*s₃),
                          s*(c₁*c₂*s₃ + s₁*c₂*c₃))
    elseif rot_seq == :ZYZ
        q0 = c₁*c₂*c₃ - s₁*c₂*s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(s*q0,
                          s*(c₁*s₂*s₃ - s₁*s₂*c₃),
                          s*(c₁*s₂*c₃ + s₁*s₂*s₃),
                          s*(c₁*c₂*s₃ + s₁*c₂*c₃))
    else
        throw(ArgumentError("The rotation sequence :$rot_seq is not valid."))
    end
end

"""
    function angle_to_quat(eulerang::EulerAngles)

Convert the Euler angles `eulerang` (see `EulerAngles`) to a quaternion.

# Remarks

This function assigns `q = q1 * q2 * q3` in which `qi` is the quaternion related
with the *i*-th rotation, `i Є [1,2,3]`.

# Example

```julia-repl
julia> angle_to_quat(pi/2, pi/3, pi/4, :ZYX)
Quaternion{Float64}:
  + 0.7010573846499779 - 0.09229595564125714.i + 0.5609855267969309.j + 0.43045933457687935.k
```

"""
angle_to_quat(Θ::EulerAngles) = angle_to_quat(Θ.a1, Θ.a2, Θ.a3, Θ.rot_seq)

"""
    function smallangle_to_quat(θx::Number, θy::Number, θz::Number)

Create a quaternion from three small rotations of angles `θx`, `θy`, and `θz`
[rad] about the axes X, Y, and Z, respectively.

# Remarks

The quaternion is normalized.

# Example

```julia-repl
julia> smallangle_to_quat(+0.01, -0.01, +0.01)
Quaternion{Float64}:
  + 0.9999625021092433 + 0.004999812510546217.i - 0.004999812510546217.j + 0.004999812510546217.k
```

"""
function smallangle_to_quat(θx::Number, θy::Number, θz::Number)
    q0     = 1
    q1     = θx/2
    q2     = θy/2
    q3     = θz/2
    norm_q = sqrt(q0^2 + q1^2 + q2^2 + q3^2)

    Quaternion(q0/norm_q, q1/norm_q, q2/norm_q, q3/norm_q)
end

################################################################################
#                                     API
################################################################################

"""
    @inline angle_to_rot([T,] θx::Number, θy::Number, θz::Number, rot_seq::Symbol)

Convert the Euler angles `Θx`, `Θy`, and `Θz` [rad] with the rotation sequence
`rot_seq` to a rotation description of type `T`, which can be `DCM` or
`Quaternion`. If the type `T` is not specified, then it defaults to `DCM`.

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`. If no value is specified, then it defaults to `:ZYX`.

# Example

```julia-repl
julia> dcm = angle_to_rot(pi/2, pi/3, pi/4, :ZYX)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  3.06162e-17  0.5       -0.866025
 -0.707107     0.612372   0.353553
  0.707107     0.612372   0.353553

julia> q   = angle_to_rot(Quaternion,pi/2, pi/3, pi/4, :ZYX)
Quaternion{Float64}:
  + 0.7010573846499779 - 0.09229595564125714.i + 0.5609855267969309.j + 0.43045933457687935.k
```

"""
@inline angle_to_rot(θx::Number, θy::Number, θz::Number, rot_seq::Symbol) =
    angle_to_dcm(θx, θy, θz, rot_seq)

@inline angle_to_rot(::Type{DCM},
                     θx::Number, θy::Number, θz::Number, rot_seq::Symbol) =
    angle_to_dcm(θx, θy, θz, rot_seq)

@inline angle_to_rot(::Type{Quaternion},
                     θx::Number, θy::Number, θz::Number, rot_seq::Symbol) =
    angle_to_quat(θx, θy, θz, rot_seq)

"""
    @inline angle_to_rot([T,] Θ::EulerAngles)

Convert the Euler angles `Θ` (see `EulerAngles`) to a rotation description of
type `T`, which can be `DCM` or `Quaternion`. If the type `T` is not specified,
then it defaults to `DCM`.

# Example

```julia-repl
julia> dcm = angle_to_rot(EulerAngles(pi/2, pi/3, pi/4, :ZYX))
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  3.06162e-17  0.5       -0.866025
 -0.707107     0.612372   0.353553
  0.707107     0.612372   0.353553

julia> q   = angle_to_rot(Quaternion,EulerAngles(pi/2, pi/3, pi/4, :ZYX))
Quaternion{Float64}:
  + 0.7010573846499779 - 0.09229595564125714.i + 0.5609855267969309.j +
  0.43045933457687935.k
```

"""
@inline angle_to_rot(Θ::EulerAngles) = angle_to_dcm(Θ.a1, Θ.a2, Θ.a3, Θ.rot_seq)

@inline angle_to_rot(::Type{DCM}, Θ::EulerAngles) =
    angle_to_dcm(Θ.a1, Θ.a2, Θ.a3, Θ.rot_seq)

@inline angle_to_rot(::Type{Quaternion}, Θ::EulerAngles) =
    angle_to_quat(Θ.a1, Θ.a2, Θ.a3, Θ.rot_seq)

"""
    function smallangle_to_rot([T,] θx::Number, θy::Number, θz::Number)

Create a rotation description of type `T` from three small rotations of angles
`θx`, `θy`, and `θz` [rad] about the axes X, Y, and Z, respectively.

The type `T` of the rotation description can be `DCM` or `Quaternion`. If the
type `T` is not specified, then if defaults to `DCM`.

# Returns

The rotation description according to the type `T`.

# Example

```julia-repl
julia> dcm = smallangle_to_rot(+0.01, -0.01, +0.01);

julia> q   = smallangle_to_rot(Quaternion,+0.01, -0.01, +0.01);

julia> dcm = smallangle_to_rot(+0.01, -0.01, +0.01)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  1.0    0.01  0.01
 -0.01   1.0   0.01
 -0.01  -0.01  1.0

julia> q   = smallangle_to_rot(Quaternion,+0.01, -0.01, +0.01)
Quaternion{Float64}:
  + 0.9999625021092433 + 0.004999812510546217.i - 0.004999812510546217.j + 0.004999812510546217.k
```

"""
@inline smallangle_to_rot(θx::Number, θy::Number, θz::Number) =
    smallangle_to_dcm(θx, θy, θz)

@inline smallangle_to_rot(::Type{DCM}, θx::Number, θy::Number, θz::Number) =
    smallangle_to_dcm(θx, θy, θz)

@inline smallangle_to_rot(::Type{Quaternion}, θx::Number, θy::Number, θz::Number) =
    smallangle_to_quat(θx, θy, θz)
