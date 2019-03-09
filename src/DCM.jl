################################################################################
#                          Direction Cosine Matrices
################################################################################

export create_rotation_matrix
export ddcm, dcm_to_angle, dcm_to_angleaxis, dcm_to_quat, orthonormalize

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

"""
    function orthonormalize(dcm::DCM)

Perform the Gram-Schmidt orthonormalization process in the DCM `dcm` and return
the new matrix.

**Warning**: This function does not check if the columns of the input matrix
span a three-dimensional space. If not, then the returned matrix should have
`NaN`. Notice, however, that such input matrix is not a valid direction cosine
matrix.

# Example

```julia-repl
julia> D = DCM(3I)

julia> orthonormalize(D)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0
```
"""
function orthonormalize(dcm::DCM)
    e₁ = dcm[:,1]
    e₂ = dcm[:,2]
    e₃ = dcm[:,3]

    en₁  = e₁/norm(e₁)
    enj₂ =   e₂ - (en₁⋅e₂)*en₁
    en₂  = enj₂ / norm(enj₂)
    enj₃ =   e₃ - (en₁⋅e₃)*en₁
    enj₃ = enj₃ - (en₂⋅enj₃)*en₂
    en₃  = enj₃ / norm(enj₃)

    [en₁ en₂ en₃]
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

# This modified function computes the `acos(x)` if `|x| <= 1` and computes
# `acos( sign(x) )`  if `|x| > 1` to avoid numerical errors when converting DCM
# to  Euler Angles.
function _mod_acos(x::T) where T<:Number
    if x > 1
        return T(0)
    elseif x < -1
        return T(π)
    else
        return acos(x)
    end
end

# This modified function computes the `asin(x)` if `|x| <= 1` and computes
# `asin( sign(x) )`  if `|x| > 1` to avoid numerical errors when converting DCM
# to  Euler Angles.
function _mod_asin(x::T) where T<:Number
    if x > 1
        return +T(π/2)
    elseif x < -1
        return -T(π/2)
    else
        return asin(x)
    end
end


"""
    function dcm_to_angle(dcm::DCM, rot_seq::Symbol=:ZYX)

Convert the DCM `dcm` to Euler Angles (see `EulerAngles`) given a rotation
sequence `rot_seq`.

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`. If no value is specified, then it defaults to `:ZYX`.

# Gimbal-lock and special cases

If the rotations are about three different axes, *e.g.* `:XYZ`, `:ZYX`, etc.,
then a second rotation of `±90˚` yields a gimbal-lock. This means that the
rotations between the first and third axes have the same effect. In this case,
the net rotation angle is assigned to the first rotation and the angle of the
third rotation is set to 0.

If the rotations are about two different axes, *e.g.* `:XYX`, `:YXY`, etc., then
a rotation about the duplicated axis yields multiple representations. In this
case, the entire angle is assigned to the first rotation and the third rotation
is set to 0.

# Example

```julia-repl
julia> D = DCM([1. 0. 0.; 0. 0. -1; 0. -1 0.]);

julia> dcm_to_angle(D,:XYZ)
EulerAngles{Float64}:
  R(X):   1.5708 rad (  90.0000 deg)
  R(Y):   0.0000 rad (   0.0000 deg)
  R(Z):   0.0000 rad (   0.0000 deg)

julia> D = angle_to_dcm(1, -pi/2, 2, :ZYX);

julia> dcm_to_angle(D,:ZYX)
EulerAngles{Float64}:
  R(Z):   3.0000 rad ( 171.8873 deg)
  R(Y):  -1.5708 rad ( -90.0000 deg)
  R(X):   0.0000 rad (   0.0000 deg)

julia> D = create_rotation_matrix(1,:X)*create_rotation_matrix(2,:X);

julia> dcm_to_angle(D,:XYX)
EulerAngles{Float64}:
  R(X):   3.0000 rad ( 171.8873 deg)
  R(Y):   0.0000 rad (   0.0000 deg)
  R(X):   0.0000 rad (   0.0000 deg)
```
"""
function dcm_to_angle(dcm::DCM{T}, rot_seq::Symbol=:ZYX) where T<:Number
    if rot_seq == :ZYX

        # Check for singularities.
        if !( abs(dcm[1,3]) >= 1-eps() )
            return EulerAngles(_mod_atan(+dcm[1,2],+dcm[1,1]),
                               asin(-dcm[1,3]),
                               _mod_atan(+dcm[2,3],+dcm[3,3]),
                               rot_seq)
        else
            return EulerAngles(_mod_atan(-dcm[2,1],+dcm[2,2]),
                               _mod_asin(-dcm[1,3]),
                               T(0),
                               rot_seq)
        end

    elseif rot_seq == :XYX

        # Check for singularities.
        if !( abs(dcm[1,1]) >= 1-eps() )
            return EulerAngles(_mod_atan(+dcm[1,2],-dcm[1,3]),
                               acos(+dcm[1,1]),
                               _mod_atan(+dcm[2,1],+dcm[3,1]),
                               rot_seq)
        else
            return EulerAngles(_mod_atan(+dcm[2,3],+dcm[2,2]),
                               _mod_acos(dcm[1,1]),
                               T(0),
                               rot_seq)
        end

    elseif rot_seq == :XYZ

        # Check for singularities.
        if !( abs(dcm[3,1]) >= 1-eps() )
            return EulerAngles(_mod_atan(-dcm[3,2],+dcm[3,3]),
                               asin(+dcm[3,1]),
                               _mod_atan(-dcm[2,1],+dcm[1,1]),
                               rot_seq)
        else
            return EulerAngles(_mod_atan(+dcm[2,3],+dcm[2,2]),
                               _mod_asin(+dcm[3,1]),
                               T(0),
                               rot_seq)
        end

    elseif rot_seq == :XZX

        # Check for singularities.
        if !( abs(dcm[1,1]) >= 1-eps() )
            return EulerAngles(_mod_atan(+dcm[1,3],+dcm[1,2]),
                               acos(+dcm[1,1]),
                               _mod_atan(+dcm[3,1],-dcm[2,1]),
                               rot_seq)
        else
            return EulerAngles(_mod_atan(-dcm[3,2],+dcm[3,3]),
                               _mod_acos(dcm[1,1]),
                               T(0),
                               rot_seq)
        end

    elseif rot_seq == :XZY

        # Check for singularities.
        if !( abs(dcm[2,1]) >= 1-eps() )
            return EulerAngles(_mod_atan(+dcm[2,3],+dcm[2,2]),
                               asin(-dcm[2,1]),
                               _mod_atan(+dcm[3,1],+dcm[1,1]),
                               rot_seq)
        else
            return EulerAngles(_mod_atan(-dcm[3,2],+dcm[3,3]),
                               _mod_asin(-dcm[2,1]),
                               T(0),
                               rot_seq)
        end

    elseif rot_seq == :YXY

        # Check for singularities.
        if !( abs(dcm[2,2]) >= 1-eps() )
            return EulerAngles(_mod_atan(+dcm[2,1],+dcm[2,3]),
                               acos(+dcm[2,2]),
                               _mod_atan(+dcm[1,2],-dcm[3,2]),
                               rot_seq)
        else
            return EulerAngles(_mod_atan(-dcm[1,3],+dcm[1,1]),
                               _mod_acos(dcm[2,2]),
                               T(0),
                               rot_seq)
        end

    elseif rot_seq == :YXZ

        if !( abs(dcm[3,2]) >= 1-eps() )
            return EulerAngles(_mod_atan(+dcm[3,1],+dcm[3,3]),
                               asin(-dcm[3,2]),
                               _mod_atan(+dcm[1,2],+dcm[2,2]),
                               rot_seq)
        else
            return EulerAngles(_mod_atan(-dcm[1,3],+dcm[1,1]),
                               _mod_asin(-dcm[3,2]),
                               T(0),
                               rot_seq)
        end

    elseif rot_seq == :YZX

        # Check for singularities.
        if !( abs(dcm[1,2]) >= 1-eps() )
            return EulerAngles(_mod_atan(-dcm[1,3],+dcm[1,1]),
                               asin(+dcm[1,2]),
                               _mod_atan(-dcm[3,2],+dcm[2,2]),
                               rot_seq)
        else
            return EulerAngles(_mod_atan(+dcm[3,1],+dcm[3,3]),
                               _mod_asin(+dcm[1,2]),
                               T(0),
                               rot_seq)
        end

    elseif rot_seq == :YZY

        # Check for singularities.
        if !( abs(dcm[2,2]) >= 1-eps() )
            return EulerAngles(_mod_atan(+dcm[2,3],-dcm[2,1]),
                               acos(+dcm[2,2]),
                               _mod_atan(+dcm[3,2],+dcm[1,2]),
                               rot_seq)
        else
            return EulerAngles(_mod_atan(dcm[3,1], dcm[3,3]),
                               _mod_acos(dcm[2,2]),
                               T(0),
                               rot_seq)
        end

    elseif rot_seq == :ZXY

        # Check for singularities.
        if !( abs(dcm[2,3]) >= 1-eps() )
            return EulerAngles(_mod_atan(-dcm[2,1],+dcm[2,2]),
                               asin(+dcm[2,3]),
                               _mod_atan(-dcm[1,3],+dcm[3,3]),
                               rot_seq)
        else
            return EulerAngles(_mod_atan(+dcm[1,2],+dcm[1,1]),
                               _mod_asin(+dcm[2,3]),
                               T(0),
                               rot_seq)
        end

    elseif rot_seq == :ZXZ

        # Check for singularities.
        if !( abs(dcm[3,3]) >= 1-eps() )
            return EulerAngles(_mod_atan(+dcm[3,1],-dcm[3,2]),
                               acos(+dcm[3,3]),
                               _mod_atan(+dcm[1,3],+dcm[2,3]),
                               rot_seq)
        else
            return EulerAngles(_mod_atan(dcm[1,2], dcm[1,1]),
                               _mod_acos(dcm[3,3]),
                               T(0),
                               rot_seq)
        end

    elseif rot_seq == :ZYZ

        # Check for singularities.
        if !( abs(dcm[3,3]) >= 1-eps() )
            return EulerAngles(_mod_atan(+dcm[3,2],+dcm[3,1]),
                               acos(+dcm[3,3]),
                               _mod_atan(+dcm[2,3],-dcm[1,3]),
                               rot_seq)
        else
            return EulerAngles(_mod_atan(-dcm[2,1], dcm[2,2]),
                               _mod_acos(dcm[3,3]),
                               T(0),
                               rot_seq)
        end

    else
        throw(ArgumentError("The rotation sequence :$rot_seq is not valid."))
    end
end

# Euler Angle and Axis
# ==============================================================================

"""
    function dcm_to_angleaxis(dcm::DCM{T}) where T<:Number

Convert the DCM `dcm` to an Euler angle and axis representation. By convention,
the returned Euler angle will always be in the interval [0, π].

"""
function dcm_to_angleaxis(dcm::DCM{T}) where T<:Number
    cθ = (dcm[1,1] + dcm[2,2] + dcm[3,3] - 1)/2

    # Check the undefined case.
    if cθ >= 1 - eps()
        return EulerAngleAxis(T(0), SVector{3,T}(0,0,0))

    elseif cθ <= -1 + eps()
        v₁ = sqrt( (1 + dcm[1,1])/2 )
        v₂ = sqrt( (1 + dcm[2,2])/2 )
        v₃ = sqrt( (1 + dcm[3,3])/2 )

        # Compute the sign of the vector components.
        if dcm[1,2] >= 0
            if dcm[1,3] >= 0
                s₁ = s₂ = s₃ = +1
            else
                s₁ = s₂ = +1
                s₃ = -1
            end
        else
            if dcm[1,3] >= 0
                s₁ = s₃ = +1
                s₂ = -1
            else
                s₁ = +1
                s₂ = s₃ = -1
            end
        end

        return EulerAngleAxis( T(1)*π, [s₁*v₁, s₂*v₂, s₃*v₃ ] )

    else
        sθ2 = 2sqrt(1 - cθ*cθ)

        v₁ = ( dcm[2,3] - dcm[3,2] )/sθ2
        v₂ = ( dcm[3,1] - dcm[1,3] )/sθ2
        v₃ = ( dcm[1,2] - dcm[2,1] )/sθ2

        return EulerAngleAxis( acos(cθ), [v₁, v₂, v₃] )

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

