################################################################################
#                          Direction Cosine Matrices
################################################################################

export create_rotation_matrix
export ddcm, dcm2angle, dcm2quat

################################################################################
#                                  Functions
################################################################################

"""
    function create_rotation_matrix(angle::Number, axis::Symbol = :X) where T<:Real

Compute a rotation matrix that rotates a coordinate frame about the axis `axis`
by the angle `angle`.

# Args

* `angle`: Angle.
* `axis`: Axis, must be 'x', 'X', 'y', 'Y', 'z', or 'Z'.

# Example

```jldocstest
julia> create_rotation_matrix(pi/2, :X)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
 1.0   0.0          0.0
 0.0   6.12323e-17  1.0
 0.0  -1.0          6.12323e-17
```

"""
function create_rotation_matrix(angle::Number, axis::Symbol = :X)
    cos_angle = cos(angle)
    sin_angle = sin(angle)

    if axis == :X
        dcm = DCM(1,      0,          0,
                  0, +cos_angle, +sin_angle,
                  0, -sin_angle, +cos_angle)'
        return dcm
    elseif axis == :Y
        dcm = DCM(+cos_angle, 0, -sin_angle,
                       0,     1,      0,
                  +sin_angle, 0, +cos_angle)'
        return dcm
    elseif axis == :Z
        dcm = DCM(+cos_angle, +sin_angle, 0,
                  -sin_angle, +cos_angle, 0,
                       0,          0,     1)'
        return dcm
    else
        error("axis must be :X, :Y, or :Z");
    end
end

################################################################################
#                                 Conversions
################################################################################

# Euler Angles
# ==============================================================================

"""
    function dcm2angle(dcm::DCM, rot_seq::Symbol=:ZYX)

Convert the DCM `dcm` to Euler Angles given a rotation sequence `rot_seq`.

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`.

# Args

* `DCM`: Direction Cosine Matrix.
* `rot_seq`: (OPTIONAL) Rotation sequence (**Default** = `:ZYX`).

# Returns

The Euler angles (see `EulerAngles`).

# Example

```julia-repl
julia> D = DCM([1. 0. 0.; 0. 0. -1; 0. -1 0.]);

julia> dcm2angle(D,:XYZ)
ReferenceFrameRotations.EulerAngles{Float64}(1.5707963267948966, 0.0, -0.0, :XYZ)
```

"""
function dcm2angle(dcm::DCM, rot_seq::Symbol=:ZYX)
    if rot_seq == :ZYX

        EulerAngles(atan(+dcm[1,2],+dcm[1,1]),
                    asin(-dcm[1,3]),
                    atan(+dcm[2,3],+dcm[3,3]),
                    rot_seq)

    elseif rot_seq == :XYX

        EulerAngles(atan(+dcm[1,2],-dcm[1,3]),
                    acos(+dcm[1,1]),
                    atan(+dcm[2,1],+dcm[3,1]),
                    rot_seq)

    elseif rot_seq == :XYZ

        EulerAngles(atan(-dcm[3,2],+dcm[3,3]),
                    asin(+dcm[3,1]),
                    atan(-dcm[2,1],+dcm[1,1]),
                    rot_seq)

    elseif rot_seq == :XZX

        EulerAngles(atan(+dcm[1,3],+dcm[1,2]),
                    acos(+dcm[1,1]),
                    atan(+dcm[3,1],-dcm[2,1]),
                    rot_seq)

    elseif rot_seq == :XZY

        EulerAngles(atan(+dcm[2,3],+dcm[2,2]),
                    asin(-dcm[2,1]),
                    atan(+dcm[3,1],+dcm[1,1]),
                    rot_seq)

    elseif rot_seq == :YXY

        EulerAngles(atan(+dcm[2,1],+dcm[2,3]),
                    acos(+dcm[2,2]),
                    atan(+dcm[1,2],-dcm[3,2]),
                    rot_seq)

    elseif rot_seq == :YXZ

        EulerAngles(atan(+dcm[3,1],+dcm[3,3]),
                    asin(-dcm[3,2]),
                    atan(+dcm[1,2],+dcm[2,2]),
                    rot_seq)

    elseif rot_seq == :YZX

        EulerAngles(atan(-dcm[1,3],+dcm[1,1]),
                    asin(+dcm[1,2]),
                    atan(-dcm[3,2],+dcm[2,2]),
                    rot_seq)

    elseif rot_seq == :YZY

        EulerAngles(atan(+dcm[2,3],-dcm[2,1]),
                    acos(+dcm[2,2]),
                    atan(+dcm[3,2],+dcm[1,2]),
                    rot_seq)

    elseif rot_seq == :ZXY

        EulerAngles(atan(-dcm[2,1],+dcm[2,2]),
                    asin(+dcm[2,3]),
                    atan(-dcm[1,3],+dcm[3,3]),
                    rot_seq)

    elseif rot_seq == :ZXZ

        EulerAngles(atan(+dcm[3,1],-dcm[3,2]),
                    acos(+dcm[3,3]),
                    atan(+dcm[1,3],+dcm[2,3]),
                    rot_seq)

    elseif rot_seq == :ZYZ

        EulerAngles(atan(+dcm[3,2],+dcm[3,1]),
                    acos(+dcm[3,3]),
                    atan(+dcm[2,3],-dcm[1,3]),
                    rot_seq)

    else
        throw(ArgumentError("The rotation sequence :$rot_seq is not valid."))
    end
end

# Quaternions
# ==============================================================================

"""
    function dcm2quat(dcm::DCM{T}) where T<:Real

Convert the DCM `dcm` to a quaternion.

# Args

* `dcm`: Direction Cosine Matrix that will be converted.

# Returns

The quaternion that represents the same rotation of the DCM `dcm`.

# Remarks

By convention, the real part of the quaternion will always be positive.
Moreover, the function does not check if `dcm` is a valid direction cosine
matrix. This must be handle by the user.

This algorithm was obtained from:

    http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/

# Example

```julia-repl
julia> dcm = angle2dcm(pi/2,0.0,0.0,:XYZ);

julia> q   = dcm2quat(dcm)
Quaternion{Float64}:
  + 0.7071067811865476 + 0.7071067811865475.i + 0.0.j + 0.0.k
```

"""
function dcm2quat(dcm::DCM{T}) where T<:Real
    if  tr(dcm) > 0
        # f = 4*q0
        f = sqrt(tr(dcm)+1)*2

        return Quaternion{T}(f/4,
                             (dcm[2,3]-dcm[3,2])/f,
                             (dcm[3,1]-dcm[1,3])/f,
                             (dcm[1,2]-dcm[2,1])/f)
    elseif (dcm[1,1] > dcm[2,2]) && (dcm[1,1] > dcm[3,3])
        # f = 4*q1
        f = sqrt(1 + dcm[1,1] - dcm[2,2] - dcm[3,3])*2

        # Real part.
        q0 = (dcm[2,3]-dcm[3,2])/f

        # Make sure that the real part is always positive.
        s = (q0 > 0) ? +1 : -1

        return Quaternion{T}(s*q0,
                             s*f/4,
                             s*(dcm[1,2]+dcm[2,1])/f,
                             s*(dcm[3,1]+dcm[1,3])/f)
    elseif (dcm[2,2] > dcm[3,3])
        # f = 4*q2
        f = sqrt(1 + dcm[2,2] - dcm[1,1] - dcm[3,3])*2

        # Real part.
        q0 = (dcm[3,1]-dcm[1,3])/f

        # Make sure that the real part is always posiive.
        s = (q0 > 0) ? +1 : -1

        return Quaternion{T}(s*q0,
                             s*(dcm[1,2]+dcm[2,1])/f,
                             s*f/4,
                             s*(dcm[3,2]+dcm[2,3])/f)
    else
        # f = 4*q3
        f = sqrt(1 + dcm[3,3] - dcm[1,1] - dcm[2,2])*2

        # Real part.
        q0 = (dcm[1,2]-dcm[2,1])/f

        # Make sure that the real part is always posiive.
        s = (q0 > 0) ? +1 : -1

        return Quaternion{T}(s*q0,
                             s*(dcm[1,3]+dcm[3,1])/f,
                             s*(dcm[2,3]+dcm[3,2])/f,
                             s*f/4)
    end
end

################################################################################
#                                  Kinematics
################################################################################

"""
    function ddcm(Dba::DCM, wba_b::AbstractArray)

Compute the time-derivative of the DCM `dcm` that rotates a reference frame `a`
into alignment to the reference frame `b` in which the angular velocity of `b`
with respect to `a`, and represented in `b`, is `wba_b`.

# Args

* `Dba`: DCM that rotates the reference frame `a` into alignment with the
         reference frame `b`.
* `wba_b`: Angular velocity of the reference frame `a` with respect to the
           reference frame `b` represented in the reference frame `b`.

# Returns

The time-derivative of the DCM `Dba` (3x3 matrix of type `SMatrix{3,3}`).

# Example

```julia-repl
julia> D = DCM(Matrix{Float64}(I,3,3));

julia> ddcm(D,[1;0;0])
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
 0.0   0.0  0.0
 0.0   0.0  1.0
 0.0  -1.0  0.0
```

"""
function ddcm(Dba::DCM, wba_b::AbstractArray)
    # Auxiliary variable.
    w = wba_b

    # Check the dimensions.
    if length(wba_b) != 3
        throw(ArgumentError("The angular velocity vector must have three components."))
    end

    wx = SMatrix{3,3}(  0  , -w[3], +w[2],
                      +w[3],   0  , -w[1],
                      -w[2], +w[1],   0  )'

    # Return the time-derivative.
    -wx*Dba
end

