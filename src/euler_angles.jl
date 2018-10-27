################################################################################
#                                 Euler Angles
################################################################################

export angle2dcm,      angle2quat,      angle2rot
export smallangle2dcm, smallangle2quat, smallangle2rot

################################################################################
#                                 Conversions
################################################################################

# Direction Cosine Matrix
# ==============================================================================

"""
    function angle2dcm(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol = :ZYX)

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
dcm = angle2dcm(pi/2, pi/3, pi/4, :ZYX)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  3.06162e-17  0.5       -0.866025
 -0.707107     0.612372   0.353553
  0.707107     0.612372   0.353553
```

"""
function angle2dcm(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol = :ZYX)

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
    function angle2dcm(eulerang::EulerAngles)

Convert the Euler angles `eulerang` (see `EulerAngles`) to a direction cosine
matrix.

# Returns

The direction cosine matrix.

# Remarks

This function assigns `dcm = A3 * A2 * A1` in which `Ai` is the DCM related with
the *i*-th rotation, `i Є [1,2,3]`.

# Example

```julia-repl
julia> angle2dcm(EulerAngles(pi/2, pi/3, pi/4, :ZYX))
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  3.06162e-17  0.5       -0.866025
 -0.707107     0.612372   0.353553
  0.707107     0.612372   0.353553
```

"""
angle2dcm(eulerang::EulerAngles) = angle2dcm(eulerang.a1, eulerang.a2,
                                             eulerang.a3, eulerang.rot_seq)

"""
    function smallangle2dcm(θx::Number, θy::Number, θz::Number)

Create a direction cosine matrix from three small rotations of angles `θx`,
`θy`, and `θz` [rad] about the axes X, Y, and Z, respectively.

# Remarks

No process of ortho-normalization is performed with the computed DCM.

# Example

```julia-repl
julia> smallangle2dcm(+0.01, -0.01, +0.01)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  1.0    0.01  0.01
 -0.01   1.0   0.01
 -0.01  -0.01  1.0
```

"""
smallangle2dcm(θx::Number, θy::Number, θz::Number) = DCM(  1, +θz, -θy,
                                                         -θz,   1, +θx,
                                                         +θy, -θx,   1)'

# Quaternion
# ==============================================================================

"""
    function angle2quat(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol = :ZYX)

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
julia> angle2quat(pi/2, pi/3, pi/4, :ZYX)
Quaternion{Float64}:
  + 0.7010573846499779 - 0.09229595564125714.i + 0.5609855267969309.j + 0.43045933457687935.k
```

"""
function angle2quat(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol = :ZYX)

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
    function angle2quat(eulerang::EulerAngles)

Convert the Euler angles `eulerang` (see `EulerAngles`) to a quaternion.

# Remarks

This function assigns `q = q1 * q2 * q3` in which `qi` is the quaternion related
with the *i*-th rotation, `i Є [1,2,3]`.

# Example

```julia-repl
julia> angle2quat(pi/2, pi/3, pi/4, :ZYX)
Quaternion{Float64}:
  + 0.7010573846499779 - 0.09229595564125714.i + 0.5609855267969309.j + 0.43045933457687935.k
```

"""
angle2quat(eulerang::EulerAngles) = angle2quat(eulerang.a1, eulerang.a2,
                                               eulerang.a3, eulerang.rot_seq)

"""
    function smallangle2quat(θx::Number, θy::Number, θz::Number)

Create a quaternion from three small rotations of angles `θx`, `θy`, and `θz`
[rad] about the axes X, Y, and Z, respectively.

# Remarks

The quaternion is normalized.

# Example

```julia-repl
julia> smallangle2quat(+0.01, -0.01, +0.01)
Quaternion{Float64}:
  + 0.9999625021092433 + 0.004999812510546217.i - 0.004999812510546217.j + 0.004999812510546217.k
```

"""
function smallangle2quat(θx::Number, θy::Number, θz::Number)
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
    function angle2rot([T,] angle_r1::Number, angle_r2::Number, angle_r3::Number, rot_seq::Symbol = :ZYX)

Convert the Euler angles `angle_r1`, `angle_r2`, and `angle_r3` [rad] with the
rotation sequence `rot_seq` to a rotation description of type `T`, which can be
`DCM` or `Quaternion`. If the type `T` is not specified, then it defaults to
`DCM`.

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`. If no value is specified, then it defaults to `:ZYX`.

# Example

```julia-repl
julia> dcm = angle2rot(pi/2, pi/3, pi/4, :ZYX)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  3.06162e-17  0.5       -0.866025
 -0.707107     0.612372   0.353553
  0.707107     0.612372   0.353553

julia> q   = angle2rot(Quaternion,pi/2, pi/3, pi/4, :ZYX)
Quaternion{Float64}:
  + 0.7010573846499779 - 0.09229595564125714.i + 0.5609855267969309.j + 0.43045933457687935.k
```

"""
@inline angle2rot(θx::Number, θy::Number, θz::Number, rot_seq::Symbol) =
    angle2dcm(θx, θy, θz, rot_seq)

@inline angle2rot(::Type{DCM},
                  θx::Number,
                  θy::Number,
                  θz::Number,
                  rot_seq::Symbol) =
    angle2dcm(θx, θy, θz, rot_seq)

@inline angle2rot(::Type{Quaternion},
                  θx::Number,
                  θy::Number,
                  θz::Number,
                  rot_seq::Symbol) =
    angle2quat(θx, θy, θz, rot_seq)

"""
    function angle2rot([T,] angle_r1::Number, angle_r2::Number, angle_r3::Number, rot_seq::Symbol = :ZYX)

Convert the Euler angles `eulerang` (see `EulerAngles`) to a rotation
description of type `T`, which can be `DCM` or `Quaternion`. If the type `T` is
not specified, then it defaults to `DCM`.

# Example

```julia-repl
julia> dcm = angle2rot(EulerAngles(pi/2, pi/3, pi/4, :ZYX))
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  3.06162e-17  0.5       -0.866025
 -0.707107     0.612372   0.353553
  0.707107     0.612372   0.353553

julia> q   = angle2rot(Quaternion,EulerAngles(pi/2, pi/3, pi/4, :ZYX))
Quaternion{Float64}:
  + 0.7010573846499779 - 0.09229595564125714.i + 0.5609855267969309.j +
  0.43045933457687935.k
```

"""
@inline angle2rot(eulerang::EulerAngles) =
    angle2dcm(eulerang.a1, eulerang.a2, eulerang.a3, eulerang.rot_seq)

@inline angle2rot(::Type{DCM}, eulerang::EulerAngles) =
    angle2dcm(eulerang.a1, eulerang.a2, eulerang.a3, eulerang.rot_seq)

@inline angle2rot(::Type{Quaternion}, eulerang::EulerAngles) =
    angle2quat(eulerang.a1, eulerang.a2, eulerang.a3, eulerang.rot_seq)

"""
    function smallangle2rot([T,] θx::Number, θy::Number, θz::Number)

Create a rotation description of type `T` from three small rotations of angles
`θx`, `θy`, and `θz` [rad] about the axes X, Y, and Z, respectively.

The type `T` of the rotation description can be `DCM` or `Quaternion`. If the
type `T` is not specified, then if defaults to `DCM`.

# Returns

The rotation description according to the type `T`.

# Example

```julia-repl
julia> dcm = smallangle2rot(+0.01, -0.01, +0.01);

julia> q   = smallangle2rot(Quaternion,+0.01, -0.01, +0.01);

julia> dcm = smallangle2rot(+0.01, -0.01, +0.01)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  1.0    0.01  0.01
 -0.01   1.0   0.01
 -0.01  -0.01  1.0

julia> q   = smallangle2rot(Quaternion,+0.01, -0.01, +0.01)
Quaternion{Float64}:
  + 0.9999625021092433 + 0.004999812510546217.i - 0.004999812510546217.j + 0.004999812510546217.k
```

"""
@inline smallangle2rot(θx::Number, θy::Number, θz::Number) =
    smallangle2dcm(θx, θy, θz)

@inline smallangle2rot(::Type{DCM}, θx::Number, θy::Number, θz::Number) =
    smallangle2dcm(θx, θy, θz)

@inline smallangle2rot(::Type{Quaternion}, θx::Number, θy::Number, θz::Number) =
    smallangle2quat(θx, θy, θz)
