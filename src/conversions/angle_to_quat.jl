## Description #############################################################################
#
# Functions related to the conversion from DCM to quaternion.
#
############################################################################################

export angle_to_quat

"""
    angle_to_quat(θ₁::T1[, θ₂::T2[, θ₃::T3]], rot_seq::Symbol = :ZYX) where {T1<:Number, T2<:Number, T3<:Number} -> Quaternion
    angle_to_quat(eulerang::EulerAngles) -> Quaternion

Create a quaternion that perform a set of rotations (`θ₁`, `θ₂`, `θ₃`) about the coordinate
axes specified in `rot_seq`.

The input values of the origin Euler angles can also be passed inside the structure `Θ` (see
[`EulerAngles`](@ref)).

The rotation sequence is defined by a `Symbol` specifing the rotation axes. The possible
values depends on the number of rotations as follows:

- **1 rotation** (`θ₁`): `:X`, `:Y`, or `:Z`.
- **2 rotations** (`θ₁`, `θ₂`): `:XY`, `:XZ`, `:YX`, `:YZ`, `:ZX`, or `:ZY`.
- **3 rotations** (`θ₁`, `θ₂`, `θ₃`): `:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`,
    `:YZY`, `:ZXY`, `:ZXZ`, `:ZYX`, or `:ZYZ`

!!! note

    The type of the new quaternion will be obtained by promiting `T1`, `T2`, and `T3`.

# Remarks

This function assigns `q = q1 * q2 * q3` in which `qi` is the quaternion related with the
_i_-th rotation, `i ∈ [1,2,3]`. If the _i_-th rotation is not specified, then
`qi = Quaternion(I)`.

# Example

```jldoctest
julia> angle_to_quat(pi / 2, :X)
Quaternion{Float64}:
  + 0.707107 + 0.707107⋅i + 0.0⋅j + 0.0⋅k

julia> angle_to_quat(pi / 5, pi / 7, :YZ)
Quaternion{Float64}:
  + 0.927212 + 0.0687628⋅i + 0.301269⋅j + 0.21163⋅k

julia> angle_to_quat(pi / 5, pi / 7, 0, :YZX)
Quaternion{Float64}:
  + 0.927212 + 0.0687628⋅i + 0.301269⋅j + 0.21163⋅k

julia> angle_to_quat(pi / 2, pi / 3, pi / 4, :ZYX)
Quaternion{Float64}:
  + 0.701057 - 0.092296⋅i + 0.560986⋅j + 0.430459⋅k
```
"""
function angle_to_quat(θ::Number, rot_seq::Symbol)
    # Compute the sines and cosines of half angle.
    s, c = sincos(θ / 2)

    # Make sure that the real part is always positive.
    if c < 0
        c = -c
        s = -s
    end

    if rot_seq == :X
        return Quaternion(c, s, 0, 0)
    elseif rot_seq == :Y
        return Quaternion(c, 0, s, 0)
    elseif rot_seq == :Z
        return Quaternion(c, 0, 0, s)
    else
        throw(ArgumentError("rot_seq must be :X, :Y, or :Z"))
    end
end

function angle_to_quat(θ₁::T1, θ₂::T2, rot_seq::Symbol) where {T1<:Number, T2<:Number}
    T = promote_type(T1, T2)

    # Compute the sines and cosines of half angle.
    s₁, c₁ = sincos(T(θ₁) / 2)
    s₂, c₂ = sincos(T(θ₂) / 2)

    # When we have two rotations, the `q0` component is always the same.
    q0 = c₁ * c₂

    s = (q0 < 0) ? -1 : +1

    if rot_seq == :XY
        return Quaternion(
            s * q0,
            s * (s₁ * c₂),
            s * (c₁ * s₂),
            s * (s₁ * s₂)
        )
    elseif rot_seq == :XZ
        return Quaternion(
            s * q0,
            s * ( s₁ * c₂),
            s * (-s₁ * s₂),
            s * ( c₁ * s₂)
        )
    elseif rot_seq == :YX
        return Quaternion(
            s * q0,
            s * ( c₁ * s₂),
            s * ( s₁ * c₂),
            s * (-s₁ * s₂)
        )
    elseif rot_seq == :YZ
        return Quaternion(
            s * q0,
            s * (s₁ * s₂),
            s * (s₁ * c₂),
            s * (c₁ * s₂)
        )
    elseif rot_seq == :ZX
        return Quaternion(
            s * q0,
            s * (c₁ * s₂),
            s * (s₁ * s₂),
            s * (s₁ * c₂)
        )
    elseif rot_seq == :ZY
        return Quaternion(
            s * q0,
            s * (-s₁ * s₂),
            s * ( c₁ * s₂),
            s * ( s₁ * c₂)
        )
    else
        throw(ArgumentError("The rotation sequence :$rot_seq is not valid."))
    end
end

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
