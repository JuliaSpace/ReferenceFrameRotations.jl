################################################################################
#                                 Euler Angles
################################################################################

export angle2dcm,  angle2dcm!
export angle2quat, angle2quat!

################################################################################
#                                 Conversions
################################################################################

# Direction Cosine Matrix
# ==============================================================================

"""
### function angle2dcm!(dcm::Matrix{T}, angle_r1::Number, angle_r2::Number, angle_r3::Number, rot_seq::AbstractString="ZYX") where T<:Real

Convert the Euler angles `angle_r1`, `angle_r2`, and `angle_r3` with the
rotation sequence `rot_seq` to a direction cosine matrix that will be stored in
`dcm`.

##### Args

* dcm: Pre-allocated direction cosine matrix.
* angle_r1: Angle of the first rotation [rad].
* angle_r2: Angle of the second rotation [rad].
* angle_r3: Angle of the third rotation [rad].
* rot_set: Rotation sequence.

##### Remarks

This function assigns `dcm = A3 * A2 * A1` in which `Ai` is the DCM related with
the *i*-th rotation, `i Є [1,2,3]`.

##### Example

    dcm = Array{Float64}(3,3)
    angle2dcm!(dcm, pi/2, pi/3, pi/4, "ZYX")

"""

function angle2dcm!(dcm::Matrix{T},
                    angle_r1::Number,
                    angle_r2::Number,
                    angle_r3::Number,
                    rot_seq::AbstractString="ZYX") where T<:Real
    # Check if rot_seq has at least three characters.
    if (length(rot_seq) < 3)
        throw(ArgumentError)
    end

    # Compute the sines and cosines.
    c1 = cos(angle_r1)
    s1 = sin(angle_r1)

    c2 = cos(angle_r2)
    s2 = sin(angle_r2)

    c3 = cos(angle_r3)
    s3 = sin(angle_r3)

    # Check the rotation sequence and compute the DCM.
    rot_seq = uppercase(rot_seq)

    if ( startswith(rot_seq, "ZYX") )
        dcm[1,1] = c2*c1;
        dcm[1,2] = c2*s1;
        dcm[1,3] = -s2;

        dcm[2,1] = s3*s2*c1 - c3*s1;
        dcm[2,2] = s3*s2*s1 + c3*c1;
        dcm[2,3] = s3*c2;

        dcm[3,1] = c3*s2*c1 + s3*s1;
        dcm[3,2] = c3*s2*s1 - s3*c1;
        dcm[3,3] = c3*c2;
    elseif ( startswith(rot_seq, "XYX") )
        dcm[1,1] = c2;
        dcm[1,2] = s1*s2;
        dcm[1,3] = -c1*s2;

        dcm[2,1] = s2*s3;
        dcm[2,2] = -s1*c2*s3 + c1*c3;
        dcm[2,3] = c1*c2*s3 + s1*c3;

        dcm[3,1] = s2*c3;
        dcm[3,2] = -s1*c3*c2 - c1*s3;
        dcm[3,3] = c1*c3*c2 - s1*s3;
    elseif ( startswith(rot_seq, "XYZ") )
        dcm[1,1] = c2*c3;
        dcm[1,2] = s1*s2*c3 + c1*s3;
        dcm[1,3] = -c1*s2*c3 + s1*s3;

        dcm[2,1] = -c2*s3;
        dcm[2,2] = -s1*s2*s3 + c1*c3;
        dcm[2,3] = c1*s2*s3 + s1*c3;

        dcm[3,1] = s2;
        dcm[3,2] = -s1*c2;
        dcm[3,3] = c1*c2;
    elseif ( startswith(rot_seq, "XZX") )
        dcm[1,1] = c2;
        dcm[1,2] = c1*s2;
        dcm[1,3] = s1*s2;

        dcm[2,1] = -s2*c3;
        dcm[2,2] = c1*c3*c2 - s1*s3;
        dcm[2,3] = s1*c3*c2 + c1*s3;

        dcm[3,1] = s2*s3;
        dcm[3,2] = -c1*c2*s3 - s1*c3;
        dcm[3,3] = -s1*c2*s3 + c1*c3;
    elseif ( startswith(rot_seq, "XZY") )
        dcm[1,1] = c3*c2;
        dcm[1,2] = c1*c3*s2 + s1*s3;
        dcm[1,3] = s1*c3*s2 - c1*s3;

        dcm[2,1] = -s2;
        dcm[2,2] = c1*c2;
        dcm[2,3] = s1*c2;

        dcm[3,1] = s3*c2;
        dcm[3,2] = c1*s2*s3 - s1*c3;
        dcm[3,3] = s1*s2*s3 + c1*c3;
    elseif ( startswith(rot_seq, "YXY") )
        dcm[1,1] = -s1*c2*s3 + c1*c3;
        dcm[1,2] = s2*s3;
        dcm[1,3] = -c1*c2*s3 - s1*c3;

        dcm[2,1] = s1*s2;
        dcm[2,2] = c2;
        dcm[2,3] = c1*s2;

        dcm[3,1] = s1*c3*c2 + c1*s3;
        dcm[3,2] = -s2*c3;
        dcm[3,3] = c1*c3*c2 - s1*s3;
    elseif ( startswith(rot_seq, "YXZ") )
        dcm[1,1] = c1*c3 + s2*s1*s3;
        dcm[1,2] = c2*s3;
        dcm[1,3] = -s1*c3 + s2*c1*s3;

        dcm[2,1] = -c1*s3 + s2*s1*c3;
        dcm[2,2] = c2*c3;
        dcm[2,3] = s1*s3 + s2*c1*c3;

        dcm[3,1] = s1*c2;
        dcm[3,2] = -s2;
        dcm[3,3] = c2*c1;
    elseif ( startswith(rot_seq, "YZX") )
        dcm[1,1] = c1*c2;
        dcm[1,2] = s2;
        dcm[1,3] = -s1*c2;

        dcm[2,1] = -c3*c1*s2 + s3*s1;
        dcm[2,2] = c2*c3;
        dcm[2,3] = c3*s1*s2 + s3*c1;

        dcm[3,1] = s3*c1*s2 + c3*s1;
        dcm[3,2] = -s3*c2;
        dcm[3,3] = -s3*s1*s2 + c3*c1;
    elseif ( startswith(rot_seq, "YZY") )
        dcm[1,1] = c1*c3*c2 - s1*s3;
        dcm[1,2] = s2*c3;
        dcm[1,3] = -s1*c3*c2 - c1*s3;

        dcm[2,1] = -c1*s2;
        dcm[2,2] = c2;
        dcm[2,3] = s1*s2;

        dcm[3,1] = c1*c2*s3 + s1*c3;
        dcm[3,2] = s2*s3;
        dcm[3,3] = -s1*c2*s3 + c1*c3;
    elseif ( startswith(rot_seq, "ZXY") )
        dcm[1,1] = c3*c1 - s2*s3*s1;
        dcm[1,2] = c3*s1 + s2*s3*c1;
        dcm[1,3] = -s3*c2;

        dcm[2,1] = -c2*s1;
        dcm[2,2] = c2*c1;
        dcm[2,3] = s2;

        dcm[3,1] = s3*c1 + s2*c3*s1;
        dcm[3,2] = s3*s1 - s2*c3*c1;
        dcm[3,3] = c2*c3;
    elseif ( startswith(rot_seq, "ZXZ") )
        dcm[1,1] = -s1*c2*s3 + c1*c3;
        dcm[1,2] = c1*c2*s3 + s1*c3;
        dcm[1,3] = s2*s3;

        dcm[2,1] = -s1*c3*c2 - c1*s3;
        dcm[2,2] = c1*c3*c2 - s1*s3;
        dcm[2,3] = s2*c3;

        dcm[3,1] = s1*s2;
        dcm[3,2] = -c1*s2;
        dcm[3,3] = c2;
    elseif ( startswith(rot_seq, "ZYZ") )
        dcm[1,1] = c1*c3*c2 - s1*s3;
        dcm[1,2] = s1*c3*c2 + c1*s3;
        dcm[1,3] = -s2*c3;

        dcm[2,1] = -c1*c2*s3 - s1*c3;
        dcm[2,2] = -s1*c2*s3 + c1*c3;
        dcm[2,3] = s2*s3;

        dcm[3,1] = c1*s2;
        dcm[3,2] = s1*s2;
        dcm[3,3] = c2;
    else
        throw(RotationSequenceError)
    end

    nothing
end

"""
### function angle2dcm(angle_r1::Number, angle_r2::Number, angle_r3::Number, rot_seq::AbstractString="ZYX")

Convert the Euler angles `angle_r1`, `angle_r2`, and `angle_r3` with the
rotation sequence `rot_seq` to a direction cosine matrix.

##### Args

* angle_r1: Angle of the first rotation [rad].
* angle_r2: Angle of the second rotation [rad].
* angle_r3: Angle of the third rotation [rad].
* rot_seq: Rotation sequence.

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
                   rot_seq::AbstractString="ZYX")

    # Check if rot_seq has at least three characters.
    if (length(rot_seq) < 3)
        throw(ArgumentError)
    end

    # Allocate the output matrix.
    dcm = Array{Float64}(3,3)

    # Fill the DCM.
    angle2dcm!(dcm, angle_r1, angle_r2, angle_r3, rot_seq)

    # Return the DCM.
    dcm
end


"""
### function angle2dcm!(dcm::Matrix{T}, eulerang::EulerAngles) where T<:Real

Convert the Euler angles `eulerang` (see `EulerAngles`) to a direction cosine
matrix that will be stored in `dcm`.

##### Args

* dcm: Pre-allocated direction cosine matrix.
* eulerang: Euler angles (see `EulerAngles`).

##### Returns

The direction cosine matrix.

##### Remarks

This function assigns `dcm = A3 * A2 * A1` in which `Ai` is the DCM related with
the *i*-th rotation, `i Є [1,2,3]`.

##### Example

    dcm = Array{Float64}(3,3)
    dcm = angle2dcm(EulerAngles(pi/2, pi/3, pi/4, "ZYX"))

"""

function angle2dcm!(dcm::Matrix{T}, eulerang::EulerAngles) where T<:Real
    angle2dcm!(dcm,
               eulerang.a1,
               eulerang.a2,
               eulerang.a3,
               eulerang.rot_seq)
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

# Quaternion
# ==============================================================================

"""
### function angle2quat!(q::Quaternion{T}, angle_r1::Number, angle_r2::Number, angle_r3::Number, rot_seq::AbstractString="ZYX") where T<:Real

Convert the Euler angles `angle_r1`, `angle_r2`, and `angle_r3` with the
rotation sequence `rot_seq` to a quaternion that will be stored in `q`.

##### Args

* q: Pre-allocated quaternion.
* angle_r1: Angle of the first rotation [rad].
* angle_r2: Angle of the second rotation [rad].
* angle_r3: Angle of the third rotation [rad].
* rot_seq: Rotation sequence [rad].

##### Remarks

This function assigns `q = q1 * q2 * q3` in which `qi` is the quaternion related
with the *i*-th rotation, `i Є [1,2,3]`.

##### Example

    q = zeros(Quaternion)
    angle2quat!(q, pi/2, pi/3, pi/4, "ZYX")

"""

function angle2quat!(q::Quaternion{T},
                     angle_r1::Number,
                     angle_r2::Number,
                     angle_r3::Number,
                     rot_seq::AbstractString="ZYX") where T<:Real
    # Check if rot_seq has at least three characters.
    if (length(rot_seq) < 3)
        throw(ArgumentError)
    end

    # Compute the sines and cosines of half angle.
    c1 = cos(angle_r1/2)
    s1 = sin(angle_r1/2)

    c2 = cos(angle_r2/2)
    s2 = sin(angle_r2/2)

    c3 = cos(angle_r3/2)
    s3 = sin(angle_r3/2)

    # Check the rotation sequence and compute the DCM.
    rot_seq = uppercase(rot_seq)

    if ( startswith(rot_seq, "ZYX") )
        q.q0 = c1*c2*c3 + s1*s2*s3
        q.q1 = c1*c2*s3 - s1*s2*c3
        q.q2 = c1*s2*c3 + s1*c2*s3
        q.q3 = s1*c2*c3 - c1*s2*s3
    elseif ( startswith(rot_seq, "XYX") )
        q.q0 = c1*c2*c3 - s1*c2*s3
        q.q1 = c1*c2*s3 + s1*c2*c3
        q.q2 = c1*s2*c3 + s1*s2*s3
        q.q3 = s1*s2*c3 - c1*s2*s3
    elseif ( startswith(rot_seq, "XYZ") )
        q.q0 = c1*c2*c3 - s1*s2*s3
        q.q1 = s1*c2*c3 + c1*s2*s3
        q.q2 = c1*s2*c3 - s1*c2*s3
        q.q3 = c1*c2*s3 + s1*s2*c3
    elseif ( startswith(rot_seq, "XZX") )
        q.q0 = c1*c2*c3 - s1*c2*s3
        q.q1 = c1*c2*s3 + s1*c2*c3
        q.q2 = c1*s2*s3 - s1*s2*c3
        q.q3 = c1*s2*c3 + s1*s2*s3
    elseif ( startswith(rot_seq, "XZY") )
        q.q0 = c1*c2*c3 + s1*s2*s3
        q.q1 = s1*c2*c3 - c1*s2*s3
        q.q2 = c1*c2*s3 - s1*s2*c3
        q.q3 = c1*s2*c3 + s1*c2*s3
    elseif ( startswith(rot_seq, "YXY") )
        q.q0 = c1*c2*c3 - s1*c2*s3
        q.q1 = c1*s2*c3 + s1*s2*s3
        q.q2 = c1*c2*s3 + s1*c2*c3
        q.q3 = c1*s2*s3 - s1*s2*c3
    elseif ( startswith(rot_seq, "YXZ") )
        q.q0 = c1*c2*c3 + s1*s2*s3
        q.q1 = c1*s2*c3 + s1*c2*s3
        q.q2 = s1*c2*c3 - c1*s2*s3
        q.q3 = c1*c2*s3 - s1*s2*c3
    elseif ( startswith(rot_seq, "YZX") )
        q.q0 = c1*c2*c3 - s1*s2*s3
        q.q1 = c1*c2*s3 + s1*s2*c3
        q.q2 = s1*c2*c3 + c1*s2*s3
        q.q3 = c1*s2*c3 - s1*c2*s3
    elseif ( startswith(rot_seq, "YZY") )
        q.q0 = c1*c2*c3 - s1*c2*s3
        q.q1 = s1*s2*c3 - c1*s2*s3
        q.q2 = c1*c2*s3 + s1*c2*c3
        q.q3 = c1*s2*c3 + s1*s2*s3
    elseif ( startswith(rot_seq, "ZXY") )
        q.q0 = c1*c2*c3 - s1*s2*s3
        q.q1 = c1*s2*c3 - s1*c2*s3
        q.q2 = c1*c2*s3 + s1*s2*c3
        q.q3 = s1*c2*c3 + c1*s2*s3
    elseif ( startswith(rot_seq, "ZXZ") )
        q.q0 = c1*c2*c3 - s1*c2*s3
        q.q1 = c1*s2*c3 + s1*s2*s3
        q.q2 = s1*s2*c3 - c1*s2*s3
        q.q3 = c1*c2*s3 + s1*c2*c3
    elseif ( startswith(rot_seq, "ZYZ") )
        q.q0 = c1*c2*c3 - s1*c2*s3
        q.q1 = c1*s2*s3 - s1*s2*c3
        q.q2 = c1*s2*c3 + s1*s2*s3
        q.q3 = c1*c2*s3 + s1*c2*c3
    else
        throw(RotationSequenceError)
    end

    nothing
end

"""
### function angle2quat(angle_r1::Number, angle_r2::Number, angle_r3::Number, rot_seq::AbstractString="ZYX")

Convert the Euler angles `angle_r1`, `angle_r2`, and `angle_r3` with the
rotation sequence `rot_seq` to a quaternion.

##### Args

* angle_r1: Angle of the first rotation [rad].
* angle_r2: Angle of the second rotation [rad].
* angle_r3: Angle of the third rotation [rad].
* rot_seq: Rotation sequence.

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
                    rot_seq::AbstractString="ZYX")

    # Check if rot_seq has at least three characters.
    if (length(rot_seq) < 3)
        throw(ArgumentError)
    end

    # Allocate the output quaternion.
    q = Quaternion{Float64}(0,0,0,0)

    # Fill the quaternion.
    angle2quat!(q, angle_r1, angle_r2, angle_r3, rot_seq)

    # Return the quaternion.
    q
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

function angle2quat(eulerang::EulerAngles{T}) where T<:Real
    angle2quat(eulerang.a1,
               eulerang.a2,
               eulerang.a3,
               eulerang.rot_seq)
end
