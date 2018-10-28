################################################################################
#                          Direction Cosine Matrices
################################################################################

export create_rotation_matrix
export ddcm, dcm_to_angle, dcm_to_quat

################################################################################
#                                  Functions
################################################################################

"""
    function create_rotation_matrix(angle::Number, axis::Symbol = :X)

Compute a rotation matrix that rotates a coordinate frame about the axis `axis`
by the angle `angle`. The `axis` must be one of the following symbols: `:X`,
`:Y`, or `:Z`.

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
    sin_angle, cos_angle = sincos(angle)

    if axis == :X
        return DCM(1,      0,          0,
                   0, +cos_angle, +sin_angle,
                   0, -sin_angle, +cos_angle)'
    elseif axis == :Y
        return DCM(+cos_angle, 0, -sin_angle,
                        0,     1,      0,
                   +sin_angle, 0, +cos_angle)'
    elseif axis == :Z
        return DCM(+cos_angle, +sin_angle, 0,
                   -sin_angle, +cos_angle, 0,
                        0,          0,     1)'
    else
        error("axis must be :X, :Y, or :Z");
    end
end

################################################################################
#                                 Conversions
################################################################################

# Euler Angles
# ==============================================================================

# This modified function computes exactly what `atan(y,x)` computes except that
# it will neglect signed zeros. Hence:
#
#   _mod_atan(0.0, -0.0) = _mod_atan(-0.0, 0.0) = 0.0
#
# The signed zero can lead to problems when converting from DCM to Euler angles.
_mod_atan(y::T,x::T) where T<:Number = atan(y + T(0), x + T(0))

"""
    function dcm_to_angle(dcm::DCM, rot_seq::Symbol=:ZYX)

Convert the DCM `dcm` to Euler Angles (see `EulerAngles`) given a rotation
sequence `rot_seq`.

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`. If no value is specified, then it defaults to `:ZYX`.

# Example

```julia-repl
julia> D = DCM([1. 0. 0.; 0. 0. -1; 0. -1 0.]);

julia> dcm_to_angle(D,:XYZ)
ReferenceFrameRotations.EulerAngles{Float64}(1.5707963267948966, 0.0, -0.0, :XYZ)
```

"""
function dcm_to_angle(dcm::DCM, rot_seq::Symbol=:ZYX)
    if rot_seq == :ZYX

        return EulerAngles(_mod_atan(+dcm[1,2],+dcm[1,1]),
                           asin(-dcm[1,3]),
                           _mod_atan(+dcm[2,3],+dcm[3,3]),
                           rot_seq)

    elseif rot_seq == :XYX

        return EulerAngles(_mod_atan(+dcm[1,2],-dcm[1,3]),
                           acos(+dcm[1,1]),
                           _mod_atan(+dcm[2,1],+dcm[3,1]),
                           rot_seq)

    elseif rot_seq == :XYZ

        return EulerAngles(_mod_atan(-dcm[3,2],+dcm[3,3]),
                           asin(+dcm[3,1]),
                           _mod_atan(-dcm[2,1],+dcm[1,1]),
                           rot_seq)

    elseif rot_seq == :XZX

        return EulerAngles(_mod_atan(+dcm[1,3],+dcm[1,2]),
                           acos(+dcm[1,1]),
                           _mod_atan(+dcm[3,1],-dcm[2,1]),
                           rot_seq)

    elseif rot_seq == :XZY

        return EulerAngles(_mod_atan(+dcm[2,3],+dcm[2,2]),
                           asin(-dcm[2,1]),
                           _mod_atan(+dcm[3,1],+dcm[1,1]),
                           rot_seq)

    elseif rot_seq == :YXY

        return EulerAngles(_mod_atan(+dcm[2,1],+dcm[2,3]),
                           acos(+dcm[2,2]),
                           _mod_atan(+dcm[1,2],-dcm[3,2]),
                           rot_seq)

    elseif rot_seq == :YXZ

        return EulerAngles(_mod_atan(+dcm[3,1],+dcm[3,3]),
                           asin(-dcm[3,2]),
                           _mod_atan(+dcm[1,2],+dcm[2,2]),
                           rot_seq)

    elseif rot_seq == :YZX

        return EulerAngles(_mod_atan(-dcm[1,3],+dcm[1,1]),
                           asin(+dcm[1,2]),
                           _mod_atan(-dcm[3,2],+dcm[2,2]),
                           rot_seq)

    elseif rot_seq == :YZY

        return EulerAngles(_mod_atan(+dcm[2,3],-dcm[2,1]),
                           acos(+dcm[2,2]),
                           _mod_atan(+dcm[3,2],+dcm[1,2]),
                           rot_seq)

    elseif rot_seq == :ZXY

        return EulerAngles(_mod_atan(-dcm[2,1],+dcm[2,2]),
                           asin(+dcm[2,3]),
                           _mod_atan(-dcm[1,3],+dcm[3,3]),
                           rot_seq)

    elseif rot_seq == :ZXZ

        return EulerAngles(_mod_atan(+dcm[3,1],-dcm[3,2]),
                           acos(+dcm[3,3]),
                           _mod_atan(+dcm[1,3],+dcm[2,3]),
                           rot_seq)

    elseif rot_seq == :ZYZ

        return EulerAngles(_mod_atan(+dcm[3,2],+dcm[3,1]),
                           acos(+dcm[3,3]),
                           _mod_atan(+dcm[2,3],-dcm[1,3]),
                           rot_seq)

    else
        throw(ArgumentError("The rotation sequence :$rot_seq is not valid."))
    end
end

# Quaternions
# ==============================================================================

"""
    function dcm_to_quat(dcm::DCM)

Convert the DCM `dcm` to a quaternion. The type of the quaternion will be
automatically selected by the constructor `Quaternion` to avoid `InexactError`.

# Remarks

By convention, the real part of the quaternion will always be positive.
Moreover, the function does not check if `dcm` is a valid direction cosine
matrix. This must be handle by the user.

This algorithm was obtained from:

    http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/

# Example

```julia-repl
julia> dcm = angle_to_dcm(pi/2,0.0,0.0,:XYZ);

julia> q   = dcm_to_quat(dcm)
Quaternion{Float64}:
  + 0.7071067811865476 + 0.7071067811865475.i + 0.0.j + 0.0.k
```

"""
function dcm_to_quat(dcm::DCM)
    if  tr(dcm) > 0
        # f = 4*q0
        f = 2sqrt(tr(dcm)+1)

        return Quaternion(f/4,
                          (dcm[2,3]-dcm[3,2])/f,
                          (dcm[3,1]-dcm[1,3])/f,
                          (dcm[1,2]-dcm[2,1])/f)

    elseif (dcm[1,1] > dcm[2,2]) && (dcm[1,1] > dcm[3,3])
        # f = 4*q1
        f = 2sqrt(1 + dcm[1,1] - dcm[2,2] - dcm[3,3])

        # Real part.
        q0 = (dcm[2,3]-dcm[3,2])/f

        # Make sure that the real part is always positive.
        s = (q0 > 0) ? +1 : -1

        return Quaternion(s*q0,
                          s*f/4,
                          s*(dcm[1,2]+dcm[2,1])/f,
                          s*(dcm[3,1]+dcm[1,3])/f)

    elseif (dcm[2,2] > dcm[3,3])
        # f = 4*q2
        f = 2sqrt(1 + dcm[2,2] - dcm[1,1] - dcm[3,3])

        # Real part.
        q0 = (dcm[3,1]-dcm[1,3])/f

        # Make sure that the real part is always positive.
        s = (q0 > 0) ? +1 : -1

        return Quaternion(s*q0,
                          s*(dcm[1,2]+dcm[2,1])/f,
                          s*f/4,
                          s*(dcm[3,2]+dcm[2,3])/f)

    else
        # f = 4*q3
        f = 2sqrt(1 + dcm[3,3] - dcm[1,1] - dcm[2,2])

        # Real part.
        q0 = (dcm[1,2]-dcm[2,1])/f

        # Make sure that the real part is always positive.
        s = (q0 > 0) ? +1 : -1

        return Quaternion(s*q0,
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
    (length(wba_b) != 3) && throw(ArgumentError("The angular velocity vector must have three components."))

    wx = SMatrix{3,3}(  0  , -w[3], +w[2],
                      +w[3],   0  , -w[1],
                      -w[2], +w[1],   0  )'

    # Return the time-derivative.
    -wx*Dba
end

