# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the conversion from Euler angles to DCM.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export angle_to_dcm

"""
    angle_to_dcm(θ₁::Number[, θ₂::Number[, θ₃::Number]], rot_seq::Symbol = :ZYX)
    angle_to_dcm(Θ::EulerAngles)

Create a direction cosine matrix that perform a set of rotations (`θ₁`, `θ₂`,
`θ₃`) about the coordinate axes specified in `rot_seq`.

The input values of the origin Euler angles can also be passed inside the
structure `Θ` (see [`EulerAngles`](@ref)).

The rotation sequence is defined by a `Symbol` specifing the rotation axes. The
possible values depends on the number of rotations as follows:

- **1 rotation** (`θ₁`): `:X`, `:Y`, or `:Z`.
- **2 rotations** (`θ₁`, `θ₂`): `:XY`, `:XZ`, `:YX`, `:YZ`, `:ZX`, or `:ZY`.
- **3 rotations** (`θ₁`, `θ₂`, `θ₃`): `:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`,
    `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`, `:ZYX`, or `:ZYZ`

# Remarks

This function assigns `dcm = A3 * A2 * A1` in which `Ai` is the DCM related with
the *i*-th rotation, `i Є [1,2,3]`. If the *i*-th rotation is not specified,
then `Ai = I`.

# Example

```jldoctest
julia> angle_to_dcm(pi / 2, :X)
DCM{Float64}:
 1.0   0.0          0.0
 0.0   6.12323e-17  1.0
 0.0  -1.0          6.12323e-17

julia> angle_to_dcm(pi / 5, pi / 7, :YZ)
DCM{Float64}:
  0.728899  0.433884  -0.529576
 -0.351019  0.900969   0.25503
  0.587785  0.0        0.809017

julia> angle_to_dcm(pi / 5, pi / 7, 0, :YZY)
DCM{Float64}:
  0.728899  0.433884  -0.529576
 -0.351019  0.900969   0.25503
  0.587785  0.0        0.809017

julia> dcm = angle_to_dcm(pi / 2, pi / 3, pi / 4, :ZYX)
DCM{Float64}:
  3.06162e-17  0.5       -0.866025
 -0.707107     0.612372   0.353553
  0.707107     0.612372   0.353553
```
"""
function angle_to_dcm(θ::Number, rot_seq::Symbol)
    sa, ca = sincos(θ)

    if rot_seq == :X
        return DCM(
            1,   0,   0,
            0, +ca, +sa,
            0, -sa, +ca
        )'
    elseif rot_seq == :Y
        return DCM(
            +ca, 0, -sa,
              0, 1,   0,
            +sa, 0, +ca
        )'
    elseif rot_seq == :Z
        return DCM(
            +ca, +sa, 0,
            -sa, +ca, 0,
              0,   0, 1
        )'
    else
        throw(ArgumentError("rot_seq must be :X, :Y, or :Z"))
    end
end

function angle_to_dcm(
    θ₁::T1,
    θ₂::T2,
    rot_seq::Symbol
) where {T1<:Number, T2<:Number}
    T = promote_type(T1, T2)

    # Compute the sines and cosines.
    s₁, c₁ = sincos(T(θ₁))
    s₂, c₂ = sincos(T(θ₂))

    if rot_seq == :XY
        return DCM(
              c₂,  s₁ * s₂, -c₁ * s₂,
            T(0),       c₁,       s₁,
              s₂, -s₁ * c₂,  c₁ * c₂
        )'
    elseif rot_seq == :XZ
        return DCM(
              c₂, c₁ * s₂, s₁ * s₂,
             -s₂, c₁ * c₂, s₁ * c₂,
            T(0),     -s₁,      c₁
        )'
    elseif rot_seq == :YX
        return DCM(
                 c₁, T(0),      -s₁,
            s₁ * s₂,   c₂,  c₁ * s₂,
            s₁ * c₂,  -s₂,  c₁ * c₂
        )'
    elseif rot_seq == :YZ
        return DCM(
             c₁ * c₂,   s₂, -s₁ * c₂,
            -c₁ * s₂,   c₂,  s₁ * s₂,
                  s₁, T(0),       c₁
        )'
    elseif rot_seq == :ZX
        return DCM(
                  c₁,       s₁, T(0),
            -c₂ * s₁,  c₂ * c₁,   s₂,
             s₂ * s₁, -s₂ * c₁,   c₂
        )'
    elseif rot_seq == :ZY
        return DCM(
            c₂ * c₁, c₂ * s₁, -s₂ ,
                -s₁,      c₁, T(0),
            s₂ * c₁, s₂ * s₁,  c₂
        )'
    else
        throw(ArgumentError("The rotation sequence :$rot_seq is not valid."))
    end
end

function angle_to_dcm(
    θ₁::T1,
    θ₂::T2,
    θ₃::T3,
    rot_seq::Symbol = :ZYX
) where {T1<:Number, T2<:Number, T3<:Number}
    T = promote_type(T1, T2, T3)

    # Compute the sines and cosines.
    s₁, c₁ = sincos(T(θ₁))
    s₂, c₂ = sincos(T(θ₂))
    s₃, c₃ = sincos(T(θ₃))

    if rot_seq == :ZYX
        return DCM(
                 c₂ * c₁,                c₂ * s₁,             -s₂ ,
            s₃ * s₂ * c₁ - c₃ * s₁, s₃ * s₂ * s₁ + c₃ * c₁, s₃ * c₂,
            c₃ * s₂ * c₁ + s₃ * s₁, c₃ * s₂ * s₁ - s₃ * c₁, c₃ * c₂
        )'
    elseif rot_seq == :XYX
        return DCM(
              c₂,               s₁ * s₂,               -c₁ * s₂,
            s₂ * s₃, -s₁ * c₂ * s₃ + c₁ * c₃, c₁ * c₂ * s₃ + s₁ * c₃,
            s₂ * c₃, -s₁ * c₃ * c₂ - c₁ * s₃, c₁ * c₃ * c₂ - s₁ * s₃
        )'
    elseif rot_seq == :XYZ
        return DCM(
             c₂ * c₃,  s₁ * s₂ * c₃ + c₁ * s₃, -c₁ * s₂ * c₃ + s₁ * s₃,
            -c₂ * s₃, -s₁ * s₂ * s₃ + c₁ * c₃,  c₁ * s₂ * s₃ + s₁ * c₃,
                s₂,             -s₁ * c₂,                 c₁ * c₂
        )'
    elseif rot_seq == :XZX
        return DCM(
               c₂,               c₁ * s₂,                 s₁ * s₂,
            -s₂ * c₃,  c₁ * c₃ * c₂ - s₁ * s₃,  s₁ * c₃ * c₂ + c₁ * s₃,
             s₂ * s₃, -c₁ * c₂ * s₃ - s₁ * c₃, -s₁ * c₂ * s₃ + c₁ * c₃
        )'

    elseif rot_seq == :XZY
        return DCM(
            c₃ * c₂, c₁ * c₃ * s₂ + s₁ * s₃, s₁ * c₃ * s₂ - c₁ * s₃,
              -s₂,             c₁ * c₂,                s₁ * c₂,
            s₃ * c₂, c₁ * s₂ * s₃ - s₁ * c₃, s₁ * s₂ * s₃ + c₁ * c₃
        )'
    elseif rot_seq == :YXY
        return DCM(
            -s₁ * c₂ * s₃ + c₁ * c₃,  s₂ * s₃, -c₁ * c₂ * s₃ - s₁ * c₃,
                       s₁ * s₂,         c₂,              c₁ * s₂,
             s₁ * c₃ * c₂ + c₁ * s₃, -s₂ * c₃,  c₁ * c₃ * c₂ - s₁ * s₃
        )'
    elseif rot_seq == :YXZ
        return DCM(
             c₁ * c₃ + s₂ * s₁ * s₃, c₂ * s₃, -s₁ * c₃ + s₂ * c₁ * s₃,
            -c₁ * s₃ + s₂ * s₁ * c₃, c₂ * c₃,  s₁ * s₃ + s₂ * c₁ * c₃,
                  s₁ * c₂,             -s₂,         c₂ * c₁
        )'
    elseif rot_seq == :YZX
        return DCM(
                       c₁ * c₂,         s₂,              -s₁ * c₂,
            -c₃ * c₁ * s₂ + s₃ * s₁,  c₂ * c₃,  c₃ * s₁ * s₂ + s₃ * c₁,
             s₃ * c₁ * s₂ + c₃ * s₁, -s₃ * c₂, -s₃ * s₁ * s₂ + c₃ * c₁
        )'
    elseif rot_seq == :YZY
        return DCM(
            c₁ * c₃ * c₂ - s₁ * s₃, s₂ * c₃, -s₁ * c₃ * c₂ - c₁ * s₃,
                -c₁ * s₂,             c₂,               s₁ * s₂,
            c₁ * c₂ * s₃ + s₁ * c₃, s₂ * s₃, -s₁ * c₂ * s₃ + c₁ * c₃
        )'
    elseif rot_seq == :ZXY
        return DCM(
            c₃ * c₁ - s₂ * s₃ * s₁, c₃ * s₁ + s₂ * s₃ * c₁, -s₃ * c₂,
                -c₂ * s₁,                c₂ * c₁,              s₂,
            s₃ * c₁ + s₂ * c₃ * s₁, s₃ * s₁ - s₂ * c₃ * c₁,  c₂ * c₃
        )'
    elseif rot_seq == :ZXZ
        return DCM(
            -s₁ * c₂ * s₃ + c₁ * c₃, c₁ * c₂ * s₃ + s₁ * c₃, s₂ * s₃,
            -s₁ * c₃ * c₂ - c₁ * s₃, c₁ * c₃ * c₂ - s₁ * s₃, s₂ * c₃,
                       s₁ * s₂,               -c₁ * s₂,         c₂
        )'
    elseif rot_seq == :ZYZ
        return DCM(
             c₁ * c₃ * c₂ - s₁ * s₃,  s₁ * c₃ * c₂ + c₁ * s₃, -s₂ * c₃,
            -c₁ * c₂ * s₃ - s₁ * c₃, -s₁ * c₂ * s₃ + c₁ * c₃,  s₂ * s₃,
                       c₁ * s₂,                 s₁ * s₂,          c₂
        )'
    else
        throw(ArgumentError("The rotation sequence :$rot_seq is not valid."))
    end
end

angle_to_dcm(Θ::EulerAngles) = angle_to_dcm(Θ.a1, Θ.a2, Θ.a3, Θ.rot_seq)
