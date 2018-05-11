################################################################################
#                          Direction Cosine Matrices
################################################################################

export create_rotation_matrix, create_rotation_matrix!
export ddcm, dcm2angle, dcm2quat, dcm2quat!

################################################################################
#                                  Functions
################################################################################

"""
### function create_rotation_matrix!(dcm::Matrix{T}, angle::Number, axis::Char) where T<:Real

Create a rotation matrix that rotates a coordinate frame about a specified axis.

##### Args

* dcm: (OUTPUT) Pre-allocated matrix in which the rotation matrix that rotates
the coordinate frame about 'axis' will be written.
* angle: Angle.
* axis: Axis, must be 'x', 'X', 'y', 'Y', 'z', or 'Z'.

"""

function create_rotation_matrix!(dcm::Matrix{T},
                                 angle::Number,
                                 axis::Char) where T<:Real
    cos_angle = cos(angle)
    sin_angle = sin(angle)

    if (axis == 'x') || (axis == 'X')
        dcm[1,1] = 1
        dcm[1,2] = 0
        dcm[1,3] = 0

        dcm[2,1] = 0
        dcm[2,2] = cos_angle
        dcm[2,3] = sin_angle

        dcm[3,1] = 0
        dcm[3,2] = -sin_angle
        dcm[3,3] = cos_angle
    elseif (axis == 'y') || (axis == 'Y')
        dcm[1,1] = cos_angle
        dcm[1,2] = 0
        dcm[1,3] = -sin_angle

        dcm[2,1] = 0
        dcm[2,2] = 1
        dcm[2,3] = 0

        dcm[3,1] = sin_angle
        dcm[3,2] = 0
        dcm[3,3] = cos_angle
    elseif (axis == 'z') || (axis == 'Z')
        dcm[1,1] = cos_angle
        dcm[1,2] = sin_angle
        dcm[1,3] = 0

        dcm[2,1] = -sin_angle
        dcm[2,2] = cos_angle
        dcm[2,3] = 0

        dcm[3,1] = 0
        dcm[3,2] = 0
        dcm[3,3] = 1
    else
        error("axis must be X, Y, or Z");
    end

    nothing
end

"""
### function create_rotation_matrix(angle::T, axis::Char) where T<:Real

Create a rotation matrix that rotates a coordinate frame about a specified axis.

##### Args

* angle: Angle.

* axis: Axis, must be 'x', 'X', 'y', 'Y', 'z', or 'Z'.

##### Returns

* The rotation matrix that rotates the coordinate frame about 'axis'.

"""

function create_rotation_matrix(angle::T, axis::Char) where T<:Real
    # Allocate the rotation matrix.
    dcm = Array{T}(3,3)

    # Fill the rotation matrix.
    create_rotation_matrix!(dcm, angle, axis)

    # Return the rotation matrix.
    dcm
end

################################################################################
#                                 Conversions
################################################################################

# Euler Angles
# ==============================================================================

"""
### function dcm2angle(dcm::Matrix{T}, rot_seq::AbstractString="ZYX") where T<:Real

Convert a DCM to Euler Angles given a rotation sequence.

##### Args

* DCM: Direction Cosine Matrix.
* rot_seq: Rotation sequence.

##### Returns

* The Euler angles.

"""

function dcm2angle(dcm::Matrix{T}, rot_seq::AbstractString="ZYX") where T<:Real
    # Check if the dcm is a 3x3 matrix.
    if (size(dcm,1) != 3) || (size(dcm,2) != 3)
        throw(ArgumentError)
    end

    # Check if rot_seq has at least three characters.
    if length(rot_seq) < 3
        throw(RotationSequenceError)
    end

    # For each rotation sequence, compute the euler angles.
    rot_seq = uppercase(rot_seq)

    if( startswith(rot_seq, "ZYX") )

        EulerAngles(atan2(+dcm[1,2],+dcm[1,1]),
                     asin(-dcm[1,3]),
                    atan2(+dcm[2,3],+dcm[3,3]),
                    rot_seq)

    elseif( startswith(rot_seq, "XYX") )

        EulerAngles(atan2(+dcm[1,2],-dcm[1,3]),
                     acos(+dcm[1,1]),
                    atan2(+dcm[2,1],+dcm[3,1]),
                    rot_seq)

    elseif( startswith(rot_seq, "XYZ") )

        EulerAngles(atan2(-dcm[3,2],+dcm[3,3]),
                     asin(+dcm[3,1]),
                    atan2(-dcm[2,1],+dcm[1,1]),
                    rot_seq)

    elseif( startswith(rot_seq, "XZX") )

        EulerAngles(atan2(+dcm[1,3],+dcm[1,2]),
                     acos(+dcm[1,1]),
                    atan2(+dcm[3,1],-dcm[2,1]),
                    rot_seq)

    elseif( startswith(rot_seq, "XZY") )

        EulerAngles(atan2(+dcm[2,3],+dcm[2,2]),
                     asin(-dcm[2,1]),
                    atan2(+dcm[3,1],+dcm[1,1]),
                    rot_seq)

    elseif( startswith(rot_seq, "YXY") )

        EulerAngles(atan2(+dcm[2,1],+dcm[2,3]),
                     acos(+dcm[2,2]),
                    atan2(+dcm[1,2],-dcm[3,2]),
                    rot_seq)

    elseif( startswith(rot_seq, "YXZ") )

        EulerAngles(atan2(+dcm[3,1],+dcm[3,3]),
                     asin(-dcm[3,2]),
                    atan2(+dcm[1,2],+dcm[2,2]),
                    rot_seq)

    elseif( startswith(rot_seq, "YZX") )

        EulerAngles(atan2(-dcm[1,3],+dcm[1,1]),
                     asin(+dcm[1,2]),
                    atan2(-dcm[3,2],+dcm[2,2]),
                    rot_seq)

    elseif( startswith(rot_seq, "YZY") )

        EulerAngles(atan2(+dcm[2,3],-dcm[2,1]),
                     acos(+dcm[2,2]),
                    atan2(+dcm[3,2],+dcm[1,2]),
                    rot_seq)

    elseif( startswith(rot_seq, "ZXY") )

        EulerAngles(atan2(-dcm[2,1],+dcm[2,2]),
                     asin(+dcm[2,3]),
                    atan2(-dcm[1,3],+dcm[3,3]),
                    rot_seq)

    elseif( startswith(rot_seq, "ZXZ") )

        EulerAngles(atan2(+dcm[3,1],-dcm[3,2]),
                     acos(+dcm[3,3]),
                    atan2(+dcm[1,3],+dcm[2,3]),
                    rot_seq)

    elseif( startswith(rot_seq, "ZYZ") )

        EulerAngles(atan2(+dcm[3,2],+dcm[3,1]),
                     acos(+dcm[3,3]),
                    atan2(+dcm[2,3],-dcm[1,3]),
                    rot_seq)

    else
        throw(RotationSequenceError)
    end
end

# Quaternions
# ==============================================================================

"""
### function dcm2quat!(q::Quaternion{T1}, dcm::Matrix{T2}) where T1<:Real where T2<:Real

Convert a quaternion to a Direction Cosine Matrix.

This algorithm was obtained from:

    http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/

##### Args

* q: (OUTPUT) Pre-allocated quaternion.
* dcm: Direction Cosine Matrix that will be converted.

##### Remarks

By convention, the real part of the quaternion will always be positive.
Moreover, the function does not check if `dcm` is a valid direction cosine
matrix. This must be handle by the user.

##### Example

    dcm = angle2dcm(pi/2,0.0,0.0,"XYZ")
    q   = Quaternion(1.0,0.0,0.0,0.0)
    dcm2quat!(q,dcm)

"""

function dcm2quat!(q::Quaternion{T1},
                   dcm::Matrix{T2}) where T1<:Real where T2<:Real

    if  trace(dcm) > 0
        # f = 4*q0
        f = sqrt(trace(dcm)+one(T2))*2

        q.q0 = f/4
        q.q1 = (dcm[2,3]-dcm[3,2])/f
        q.q2 = (dcm[3,1]-dcm[1,3])/f
        q.q3 = (dcm[1,2]-dcm[2,1])/f
    elseif (dcm[1,1] > dcm[2,2]) && (dcm[1,1] > dcm[3,3])
        # f = 4*q1
        f = sqrt(one(T2) + dcm[1,1] - dcm[2,2] - dcm[3,3])*2

        # Real part.
        q.q0 = (dcm[2,3]-dcm[3,2])/f

        # Make sure that the real part is always positive.
        s = (q.q0 > 0) ? one(T2) : -one(T2)

        q.q0 = s*q.q0
        q.q1 = s*f/4
        q.q2 = s*(dcm[1,2]+dcm[2,1])/f
        q.q3 = s*(dcm[3,1]+dcm[1,3])/f
    elseif (dcm[2,2] > dcm[3,3])
        # f = 4*q2
        f = sqrt(one(T2) + dcm[2,2] - dcm[1,1] - dcm[3,3])*2

        # Real part.
        q.q0 = (dcm[3,1]-dcm[1,3])/f

        # Make sure that the real part is always posiive.
        s = (q.q0 > 0) ? one(T2) : -one(T2)

        q.q0 = s*q.q0
        q.q1 = s*(dcm[1,2]+dcm[2,1])/f
        q.q2 = s*f/4
        q.q3 = s*(dcm[3,2]+dcm[2,3])/f
    else
        # f = 4*q3
        f = sqrt(one(T2) + dcm[3,3] - dcm[1,1] - dcm[2,2])*2

        # Real part.
        q.q0 = (dcm[1,2]-dcm[2,1])/f

        # Make sure that the real part is always posiive.
        s = (q.q0 > 0) ? one(T2) : -one(T2)

        q.q0 = s*q.q0
        q.q1 = s*(dcm[1,3]+dcm[3,1])/f
        q.q2 = s*(dcm[2,3]+dcm[3,2])/f
        q.q3 = s*f/4
    end

    nothing
end

"""
### function dcm2quat(dcm::Matrix{T}) where T<:Real

Convert a quaternion to a Direction Cosine Matrix.

This algorithm was obtained from:

    http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/

##### Args

* dcm: Direction Cosine Matrix that will be converted.

##### Returns

* The quaternion that represents the same rotation of the `dcm`.

##### Remarks

By convention, the real part of the quaternion will always be positive.
Moreover, the function does not check if `dcm` is a valid direction cosine
matrix. This must be handle by the user.

##### Example

    dcm = angle2dcm(pi/2,0.0,0.0,"XYZ")
    q   = dcm2quat(dcm)

"""

function dcm2quat(dcm::Matrix{T}) where T<:Real
    q = zeros(Quaternion{T})
    dcm2quat!(q,dcm)
    q
end

################################################################################
#                                  Kinematics
################################################################################

"""
### function ddcm(Dba::Matrix{T1}, wba_b::Vector{T2}) where T1<:Real where T2<:Real

Compute the time-derivative of a DCM that rotates a reference frame `a` into
alignment to the reference frame `b` in which the angular velocity of `b` with
respect to `a` and represented in `b` is `wba_b`.

##### Args

* Dba: DCM that rotates the reference frame `a` into alignment with the
reference frame `b`.
* wba_b: Angular velocity of the reference frame `a` with respect to the
reference frame `b` represented in the reference frame `b`.

##### Returns

* The time-derivative of `Dba` (3x3 matrix).

"""

function ddcm(Dba::Matrix{T1}, wba_b::Vector{T2}) where T1<:Real where T2<:Real
    # Auxiliary variable.
    w = wba_b

    # Check the dimensions.
    if length(wba_b) != 3
        throw(ArgumentError("The angular velocity vector must have three components."))
    end

    wx = T2[ zero(T2)  -w[3]    +w[2];
              +w[3]   zero(T2)  -w[1];
              -w[2]    +w[1]   zero(T2) ]

    # Return the time-derivative.
    -wx*Dba
end


