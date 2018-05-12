################################################################################
#                                 Euler Angles
################################################################################

export angle2dcm,      angle2quat
export smallangle2dcm, smallangle2quat

################################################################################
#                                 Conversions
################################################################################

# Direction Cosine Matrix
# ==============================================================================

"""
### function angle2dcm(angle_r1::Number, angle_r2::Number, angle_r3::Number, rot_seq::Symbol = :ZYX)

Convert the Euler angles `angle_r1`, `angle_r2`, and `angle_r3` with the
rotation sequence `rot_seq` to a direction cosine matrix.

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`.

##### Args

* angle_r1: Angle of the first rotation [rad].
* angle_r2: Angle of the second rotation [rad].
* angle_r3: Angle of the third rotation [rad].
* rot_seq: (OPTIONAL) Rotation sequence (**Default** = `:ZYX`).

##### Returns

The direction cosine matrix.

##### Remarks

This function assigns `dcm = A3 * A2 * A1` in which `Ai` is the DCM related with
the *i*-th rotation, `i Є [1,2,3]`.

##### Example

    dcm = angle2dcm(pi/2, pi/3, pi/4, "ZYX")

"""

function angle2dcm(angle_r1::Number,
                   angle_r2::Number,
                   angle_r3::Number,
                   rot_seq::Symbol = :ZYX)
    # Compute the sines and cosines.
    c1 = cos(angle_r1)
    s1 = sin(angle_r1)

    c2 = cos(angle_r2)
    s2 = sin(angle_r2)

    c3 = cos(angle_r3)
    s3 = sin(angle_r3)

    if rot_seq == :ZYX
        dcm = SMatrix{3,3}(       c2*c1    ,        c2*s1    , -s2  ,
                           s3*s2*c1 - c3*s1, s3*s2*s1 + c3*c1, s3*c2,
                           c3*s2*c1 + s3*s1, c3*s2*s1 - s3*c1, c3*c2)'
        return dcm

    elseif rot_seq == :XYX
        dcm = SMatrix{3,3}( c2  ,         s1*s2    ,       -c1*s2    ,
                           s2*s3, -s1*c2*s3 + c1*c3, c1*c2*s3 + s1*c3,
                           s2*c3, -s1*c3*c2 - c1*s3, c1*c3*c2 - s1*s3)'
        return dcm

    elseif rot_seq == :XYZ
        dcm = SMatrix{3,3}( c2*c3,  s1*s2*c3 + c1*s3, -c1*s2*c3 + s1*s3,
                           -c2*s3, -s1*s2*s3 + c1*c3,  c1*s2*s3 + s1*c3,
                              s2 ,        -s1*c2    ,       c1*c2)'
        return dcm

    elseif rot_seq == :XZX
        dcm = SMatrix{3,3}(   c2 ,         c1*s2    ,         s1*s2    ,
                           -s2*c3,  c1*c3*c2 - s1*s3,  s1*c3*c2 + c1*s3,
                            s2*s3, -c1*c2*s3 - s1*c3, -s1*c2*s3 + c1*c3)'
        return dcm

    elseif rot_seq == :XZY
        dcm = SMatrix{3,3}(c3*c2, c1*c3*s2 + s1*s3, s1*c3*s2 - c1*s3,
                            -s2 ,        c1*c2    ,        s1*c2    ,
                           s3*c2, c1*s2*s3 - s1*c3, s1*s2*s3 + c1*c3)'
        return dcm

    elseif rot_seq == :YXY
        dcm = SMatrix{3,3}(-s1*c2*s3 + c1*c3, s2*s3 , -c1*c2*s3 - s1*c3,
                                   s1*s2    ,   c2  ,         c1*s2    ,
                            s1*c3*c2 + c1*s3, -s2*c3,  c1*c3*c2 - s1*s3)'
        return dcm

    elseif rot_seq == :YXZ
        dcm = SMatrix{3,3}( c1*c3 + s2*s1*s3, c2*s3, -s1*c3 + s2*c1*s3,
                           -c1*s3 + s2*s1*c3, c2*c3,  s1*s3 + s2*c1*c3,
                                s1*c2       ,  -s2 ,      c2*c1       )'
        return dcm

    elseif rot_seq == :YZX
        dcm = SMatrix{3,3}(        c1*c2    ,    s2 ,        -s1*c2    ,
                           -c3*c1*s2 + s3*s1,  c2*c3,  c3*s1*s2 + s3*c1,
                            s3*c1*s2 + c3*s1, -s3*c2, -s3*s1*s2 + c3*c1)'
        return dcm

    elseif rot_seq == :YZY
        dcm = SMatrix{3,3}(c1*c3*c2 - s1*s3, s2*c3, -s1*c3*c2 - c1*s3,
                                 -c1*s2    ,   c2 ,         s1*s2    ,
                           c1*c2*s3 + s1*c3, s2*s3, -s1*c2*s3 + c1*c3)'
        return dcm

    elseif rot_seq == :ZXY
        dcm = SMatrix{3,3}(c3*c1 - s2*s3*s1, c3*s1 + s2*s3*c1, -s3*c2,
                              -c2*s1       ,     c2*c1       ,    s2 ,
                           s3*c1 + s2*c3*s1, s3*s1 - s2*c3*c1,  c2*c3)'
        return dcm

    elseif rot_seq == :ZXZ
        dcm = SMatrix{3,3}(-s1*c2*s3 + c1*c3, c1*c2*s3 + s1*c3, s2*s3,
                           -s1*c3*c2 - c1*s3, c1*c3*c2 - s1*s3, s2*c3,
                                   s1*s2    ,       -c1*s2    ,  c2)'
        return dcm

    elseif rot_seq == :ZYZ
        dcm = SMatrix{3,3}( c1*c3*c2 - s1*s3,  s1*c3*c2 + c1*s3, -s2*c3,
                           -c1*c2*s3 - s1*c3, -s1*c2*s3 + c1*c3,  s2*s3,
                                   c1*s2    ,         s1*s2    ,    c2)'
        return dcm
    else
        throw(RotationSequenceError)
    end
end

"""
### function angle2dcm(eulerang::EulerAngles{T}) where T<:Real

Convert the Euler angles `eulerang` (see `EulerAngles`) to a direction cosine
matrix.

##### Args

* eulerang: Euler angles (see `EulerAngles`).

##### Returns

The direction cosine matrix.

##### Remarks

This function assigns `dcm = A3 * A2 * A1` in which `Ai` is the DCM related with
the *i*-th rotation, `i Є [1,2,3]`.

##### Example

    dcm = angle2dcm(EulerAngles(pi/2, pi, pi/4, "ZYX"))

"""

function angle2dcm(eulerang::EulerAngles{T}) where T<:Real
    angle2dcm(eulerang.a1,
              eulerang.a2,
              eulerang.a3,
              eulerang.rot_seq)
end

"""
### function smallangle2dcm(θx::Number, θy::Number, θz::Number) where T<:Real

Create a direction cosine matrix from three small rotations of angles `θx`,
`θy`, and `θz` about the axes X, Y, and Z, respectively.

##### Args

* θx: Angle of the rotation about the X-axis [rad].
* θy: Angle of the rotation about the Y-axis [rad].
* θz: Angle of the rotation about the Z-axis [rad].

##### Returns

The direction cosine matrix.

##### Remarks

No process of ortho-normalization is performed with the computed DCM.

##### Example

    dcm = smallangle2dcm(+0.01, -0.01, +0.01)

"""
function smallangle2dcm( θx::Number, θy::Number, θz::Number)
    SMatrix{3,3}(  1, +θz, -θy,
                 -θz,   1, +θx,
                 +θy, -θx,   1)'
end

# Quaternion
# ==============================================================================

"""
### function angle2quat(angle_r1::Number, angle_r2::Number, angle_r3::Number, rot_seq::AbstractString="ZYX")

Convert the Euler angles `angle_r1`, `angle_r2`, and `angle_r3` with the
rotation sequence `rot_seq` to a quaternion.

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`.

##### Args

* angle_r1: Angle of the first rotation [rad].
* angle_r2: Angle of the second rotation [rad].
* angle_r3: Angle of the third rotation [rad].
* rot_seq: (OPTIONAL) Rotation sequence (**Default** = `:ZYX`).

##### Returns

The quaternion.

##### Remarks

This function assigns `q = q1 * q2 * q3` in which `qi` is the quaternion related
with the *i*-th rotation, `i Є [1,2,3]`.

##### Example

    q = angle2quat(pi/2, pi/3, pi/4, "ZYX")

"""

function angle2quat(angle_r1::Number,
                    angle_r2::Number,
                    angle_r3::Number,
                    rot_seq::Symbol = :ZYX)

    # Compute the sines and cosines of half angle.
    c1 = cos(angle_r1/2)
    s1 = sin(angle_r1/2)

    c2 = cos(angle_r2/2)
    s2 = sin(angle_r2/2)

    c3 = cos(angle_r3/2)
    s3 = sin(angle_r3/2)

    if rot_seq == :ZYX
        return Quaternion(c1*c2*c3 + s1*s2*s3,
                          c1*c2*s3 - s1*s2*c3,
                          c1*s2*c3 + s1*c2*s3,
                          s1*c2*c3 - c1*s2*s3)
    elseif rot_seq == :XYX
        return Quaternion(c1*c2*c3 - s1*c2*s3,
                          c1*c2*s3 + s1*c2*c3,
                          c1*s2*c3 + s1*s2*s3,
                          s1*s2*c3 - c1*s2*s3)
    elseif rot_seq == :XYZ
        return Quaternion(c1*c2*c3 - s1*s2*s3,
                          s1*c2*c3 + c1*s2*s3,
                          c1*s2*c3 - s1*c2*s3,
                          c1*c2*s3 + s1*s2*c3)
    elseif rot_seq == :XZX
        return Quaternion(c1*c2*c3 - s1*c2*s3,
                          c1*c2*s3 + s1*c2*c3,
                          c1*s2*s3 - s1*s2*c3,
                          c1*s2*c3 + s1*s2*s3)
    elseif rot_seq == :XZY
        return Quaternion(c1*c2*c3 + s1*s2*s3,
                          s1*c2*c3 - c1*s2*s3,
                          c1*c2*s3 - s1*s2*c3,
                          c1*s2*c3 + s1*c2*s3)
    elseif rot_seq == :YXY
        return Quaternion(c1*c2*c3 - s1*c2*s3,
                          c1*s2*c3 + s1*s2*s3,
                          c1*c2*s3 + s1*c2*c3,
                          c1*s2*s3 - s1*s2*c3)
    elseif rot_seq == :YXZ
        return Quaternion(c1*c2*c3 + s1*s2*s3,
                          c1*s2*c3 + s1*c2*s3,
                          s1*c2*c3 - c1*s2*s3,
                          c1*c2*s3 - s1*s2*c3)
    elseif rot_seq == :YZX
        return Quaternion(c1*c2*c3 - s1*s2*s3,
                          c1*c2*s3 + s1*s2*c3,
                          s1*c2*c3 + c1*s2*s3,
                          c1*s2*c3 - s1*c2*s3)
    elseif rot_seq == :YZY
        return Quaternion(c1*c2*c3 - s1*c2*s3,
                          s1*s2*c3 - c1*s2*s3,
                          c1*c2*s3 + s1*c2*c3,
                          c1*s2*c3 + s1*s2*s3)
    elseif rot_seq == :ZXY
        return Quaternion(c1*c2*c3 - s1*s2*s3,
                          c1*s2*c3 - s1*c2*s3,
                          c1*c2*s3 + s1*s2*c3,
                          s1*c2*c3 + c1*s2*s3)
    elseif rot_seq == :ZXZ
        return Quaternion(c1*c2*c3 - s1*c2*s3,
                          c1*s2*c3 + s1*s2*s3,
                          s1*s2*c3 - c1*s2*s3,
                          c1*c2*s3 + s1*c2*c3)
    elseif rot_seq == :ZYZ
        return Quaternion(c1*c2*c3 - s1*c2*s3,
                          c1*s2*s3 - s1*s2*c3,
                          c1*s2*c3 + s1*s2*s3,
                          c1*c2*s3 + s1*c2*c3)
    else
        throw(RotationSequenceError)
    end
end

"""
### function angle2quat(eulerang::EulerAngles{T}) where T<:Real

Convert the Euler angles `eulerang` (see `EulerAngles`) to a quaternion.

##### Args

* eulerang: Euler angles (see `EulerAngles`).

##### Returns

The quaternion.

##### Remarks

This function assigns `q = q1 * q2 * q3` in which `qi` is the quaternion related
with the *i*-th rotation, `i Є [1,2,3]`.

##### Example

    q = angle2quat(EulerAngles(pi/2, pi/3, pi/4, "ZYX"))

"""

function angle2quat(eulerang::EulerAngles)
    angle2quat(eulerang.a1,
               eulerang.a2,
               eulerang.a3,
               eulerang.rot_seq)
end

"""
### function smallangle2quat(θx::Number, θy::Number, θz::Number)

Create a quaternion from three small rotations of angles `θx`, `θy`, and `θz`
about the axes X, Y, and Z, respectively.

##### Args

* θx: Angle of the rotation about the X-axis [rad].
* θy: Angle of the rotation about the Y-axis [rad].
* θz: Angle of the rotation about the Z-axis [rad].

##### Returns

The quaternion.

##### Remarks

The quaternion is normalized.

##### Example

    q = smallangle2quat(+0.01, -0.01, +0.01)

"""

function smallangle2quat(θx::Number, θy::Number, θz::Number)
    q0     = 1
    q1     = θx/2
    q2     = θy/2
    q3     = θz/2
    norm_q = sqrt(q0^2 + q1^2 + q2^2 + q3^2)

    Quaternion(q0,q1,q2,q3)
end
