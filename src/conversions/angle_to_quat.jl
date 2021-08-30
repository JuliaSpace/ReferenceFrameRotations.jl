# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the conversion from DCM to quaternion.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export angle_to_quat

"""
    angle_to_quat(θ::Number, axis::Symbol)

Create a quaternion that rotates the reference frame about `axis` by an angle
`θ` [rad]. `axis` can be `:X`, `:Y`, or `:Z`.

# Example

```jldocstest
julia> angle_to_quat(pi / 2, :Y)
Quaternion{Float64}:
  + 0.707107 + 0.0⋅i + 0.707107⋅j + 0.0⋅k
```
"""
function angle_to_quat(θ::Number, axis::Symbol)
    # Compute the sines and cosines of half angle.
    s, c = sincos(θ / 2)

    # Make sure that the real part is always positive.
    if c < 0
        c = -c
        s = -s
    end

    if axis == :X
        return Quaternion(c, s, 0, 0)
    elseif axis == :Y
        return Quaternion(c, 0, s, 0)
    elseif axis == :Z
        return Quaternion(c, 0, 0, s)
    else
        throw(ArgumentError("Axis must be :X, :Y, or :Z"))
    end
end

"""
    angle_to_quat(θ₁::T1, θ₂::T2, θ₃::T3, rot_seq::Symbol = :ZYX) where {T1<:Number, T2<:Number, T3<:Number}
    angle_to_quat(eulerang::EulerAngles)

Convert the Euler angles `θ₁`, `θ₂`, and `θ₃` [rad] with the rotation sequence
`rot_seq` to a quaternion.

The input values of the origin Euler angles can also be passed inside the
structure `Θ` (see [`EulerAngles`](@ref)).

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`. If no value is specified, then it defaults to `:ZYX`.

!!! note
    The type of the new quaternion will be obtained by promiting `T1`, `T2`, and
    `T3`.

# Remarks

This function assigns `q = q1 * q2 * q3` in which `qi` is the quaternion related
with the *i*-th rotation, `i Є [1,2,3]`.

# Example

```jldoctest
julia> angle_to_quat(pi / 2, pi / 3, pi / 4, :ZYX)
Quaternion{Float64}:
  + 0.701057 - 0.092296⋅i + 0.560986⋅j + 0.560986⋅k
```
"""
function angle_to_quat(
    θ₁::T1,
    θ₂::T2,
    θ₃::T3,
    rot_seq::Symbol = :ZYX
) where {T1<:Number, T2<:Number, T3<:Number}
    T = promote_type(T1, T2, T3)

    # Compute the sines and cosines of half angle.
    s₁, c₁ = sincos(T(θ₁) / 2)
    s₂, c₂ = sincos(T(θ₂) / 2)
    s₃, c₃ = sincos(T(θ₃) / 2)

    if rot_seq == :ZYX
        q0 = c₁ * c₂ * c₃ + s₁ * s₂ * s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(
            s * q0,
            s * (c₁ * c₂ * s₃ - s₁ * s₂ * c₃),
            s * (c₁ * s₂ * c₃ + s₁ * c₂ * s₃),
            s * (s₁ * c₂ * c₃ - c₁ * s₂ * s₃)
        )
    elseif rot_seq == :XYX
        q0 = c₁ * c₂ * c₃ - s₁ * c₂ * s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(
            s * q0,
            s * (c₁ * c₂ * s₃ + s₁ * c₂ * c₃),
            s * (c₁ * s₂ * c₃ + s₁ * s₂ * s₃),
            s * (s₁ * s₂ * c₃ - c₁ * s₂ * s₃)
        )
    elseif rot_seq == :XYZ
        q0 = c₁ * c₂ * c₃ - s₁ * s₂ * s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(
            s * q0,
            s * (s₁ * c₂ * c₃ + c₁ * s₂ * s₃),
            s * (c₁ * s₂ * c₃ - s₁ * c₂ * s₃),
            s * (c₁ * c₂ * s₃ + s₁ * s₂ * c₃)
        )
    elseif rot_seq == :XZX
        q0 = c₁ * c₂ * c₃ - s₁ * c₂ * s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(
            s * q0,
            s * (c₁ * c₂ * s₃ + s₁ * c₂ * c₃),
            s * (c₁ * s₂ * s₃ - s₁ * s₂ * c₃),
            s * (c₁ * s₂ * c₃ + s₁ * s₂ * s₃)
        )
    elseif rot_seq == :XZY
        q0 = c₁ * c₂ * c₃ + s₁ * s₂ * s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(
            s * q0,
            s * (s₁ * c₂ * c₃ - c₁ * s₂ * s₃),
            s * (c₁ * c₂ * s₃ - s₁ * s₂ * c₃),
            s * (c₁ * s₂ * c₃ + s₁ * c₂ * s₃)
        )
    elseif rot_seq == :YXY
        q0 = c₁ * c₂ * c₃ - s₁ * c₂ * s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(
            s * q0,
            s * (c₁ * s₂ * c₃ + s₁ * s₂ * s₃),
            s * (c₁ * c₂ * s₃ + s₁ * c₂ * c₃),
            s * (c₁ * s₂ * s₃ - s₁ * s₂ * c₃)
        )
    elseif rot_seq == :YXZ
        q0 = c₁ * c₂ * c₃ + s₁ * s₂ * s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(
            s * q0,
            s * (c₁ * s₂ * c₃ + s₁ * c₂ * s₃),
            s * (s₁ * c₂ * c₃ - c₁ * s₂ * s₃),
            s * (c₁ * c₂ * s₃ - s₁ * s₂ * c₃)
        )
    elseif rot_seq == :YZX
        q0 = c₁ * c₂ * c₃ - s₁ * s₂ * s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(
            s * q0,
            s * (c₁ * c₂ * s₃ + s₁ * s₂ * c₃),
            s * (s₁ * c₂ * c₃ + c₁ * s₂ * s₃),
            s * (c₁ * s₂ * c₃ - s₁ * c₂ * s₃)
        )
    elseif rot_seq == :YZY
        q0 = c₁ * c₂ * c₃ - s₁ * c₂ * s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(
            s * q0,
            s * (s₁ * s₂ * c₃ - c₁ * s₂ * s₃),
            s * (c₁ * c₂ * s₃ + s₁ * c₂ * c₃),
            s * (c₁ * s₂ * c₃ + s₁ * s₂ * s₃)
        )
    elseif rot_seq == :ZXY
        q0 = c₁ * c₂ * c₃ - s₁ * s₂ * s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(
            s * q0,
            s * (c₁ * s₂ * c₃ - s₁ * c₂ * s₃),
            s * (c₁ * c₂ * s₃ + s₁ * s₂ * c₃),
            s * (s₁ * c₂ * c₃ + c₁ * s₂ * s₃)
        )
    elseif rot_seq == :ZXZ
        q0 = c₁ * c₂ * c₃ - s₁ * c₂ * s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(
            s * q0,
            s * (c₁ * s₂ * c₃ + s₁ * s₂ * s₃),
            s * (s₁ * s₂ * c₃ - c₁ * s₂ * s₃),
            s * (c₁ * c₂ * s₃ + s₁ * c₂ * c₃)
        )
    elseif rot_seq == :ZYZ
        q0 = c₁ * c₂ * c₃ - s₁ * c₂ * s₃

        s = (q0 < 0) ? -1 : +1

        return Quaternion(
            s * q0,
            s * (c₁ * s₂ * s₃ - s₁ * s₂ * c₃),
            s * (c₁ * s₂ * c₃ + s₁ * s₂ * s₃),
            s * (c₁ * c₂ * s₃ + s₁ * c₂ * c₃)
        )
    else
        throw(ArgumentError("The rotation sequence :$rot_seq is not valid."))
    end
end

angle_to_quat(Θ::EulerAngles) = angle_to_quat(Θ.a1, Θ.a2, Θ.a3, Θ.rot_seq)
