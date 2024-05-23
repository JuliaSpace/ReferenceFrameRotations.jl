## Description #############################################################################
#
# Functions related to the API to convert from Euler angles to rotation representations.
#
############################################################################################

export angle_to_rot

"""
    angle_to_rot([T,] θ₁::Number[, θ₂::Number[, θ₃::Number]], rot_seq::Symbol) -> T
    angle_to_rot([T,] Θ::EulerAngles) -> T

Create a rotation description of type `T` that perform a set of rotations (`θ₁`, `θ₂`, `θ₃`)
about the coordinate axes specified in `rot_seq`.

The input values of the origin Euler angles can also be passed inside the structure `Θ` (see
[`EulerAngles`](@ref)).

The rotation sequence is defined by a `Symbol` specifing the rotation axes. The possible
values depends on the number of rotations as follows:

- **1 rotation** (`θ₁`): `:X`, `:Y`, or `:Z`.
- **2 rotations** (`θ₁`, `θ₂`): `:XY`, `:XZ`, `:YX`, `:YZ`, `:ZX`, or `:ZY`.
- **3 rotations** (`θ₁`, `θ₂`, `θ₃`): `:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`,
    `:YZY`, `:ZXY`, `:ZXZ`, `:ZYX`, or `:ZYZ`

# Example

```julia-repl
julia> dcm = angle_to_rot(pi / 5, :Z)
3×3 StaticArrays.SMatrix{3, 3, Float64, 9} with indices SOneTo(3)×SOneTo(3):
  0.809017  0.587785  0.0
 -0.587785  0.809017  0.0
  0.0       0.0       1.0

julia> quat = angle_to_rot(Quaternion, pi / 5, :Z)
Quaternion{Float64}:
  + 0.951057 + 0.0⋅i + 0.0⋅j + 0.309017⋅k

julia> dcm = angle_to_rot(pi / 5, pi / 7, :YZ)
3×3 StaticArrays.SMatrix{3, 3, Float64, 9} with indices SOneTo(3)×SOneTo(3):
  0.728899  0.433884  -0.529576
 -0.351019  0.900969   0.25503
  0.587785  0.0        0.809017

julia> quat = angle_to_rot(Quaternion, pi / 5, pi / 7, :YZ)
Quaternion{Float64}:
  + 0.927212 + 0.0687628⋅i + 0.301269⋅j + 0.21163⋅k

julia> dcm = angle_to_rot(pi / 2, pi / 3, pi / 4, :ZYX)
3×3 StaticArrays.SMatrix{3, 3, Float64, 9} with indices SOneTo(3)×SOneTo(3):
  3.06162e-17  0.5       -0.866025
 -0.707107     0.612372   0.353553
  0.707107     0.612372   0.353553

julia> q = angle_to_rot(Quaternion, pi / 2, pi / 3, pi / 4, :ZYX)
Quaternion{Float64}:
  + 0.701057 - 0.092296⋅i + 0.560986⋅j + 0.430459⋅k
```
"""
@inline function angle_to_rot(θ::Number, rot_seq::Symbol)
    return angle_to_dcm(θ, rot_seq)
end

@inline function angle_to_rot(::Type{DCM}, θ::Number, rot_seq::Symbol)
    return angle_to_dcm(θ, rot_seq)
end

@inline function angle_to_rot(::Type{Quaternion}, θ::Number, rot_seq::Symbol)
    return angle_to_quat(θ, rot_seq)
end

@inline function angle_to_rot(θ₁::Number, θ₂::Number, rot_seq::Symbol)
    return angle_to_dcm(θ₁, θ₂, rot_seq)
end

@inline function angle_to_rot(::Type{DCM}, θ₁::Number, θ₂::Number, rot_seq::Symbol)
    return angle_to_dcm(θ₁, θ₂, rot_seq)
end

@inline function angle_to_rot(::Type{Quaternion}, θ₁::Number, θ₂::Number, rot_seq::Symbol)
    return angle_to_quat(θ₁, θ₂, rot_seq)
end

@inline function angle_to_rot(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol)
    return angle_to_dcm(θ₁, θ₂, θ₃, rot_seq)
end

@inline function angle_to_rot(
    ::Type{DCM},
    θ₁::Number,
    θ₂::Number,
    θ₃::Number,
    rot_seq::Symbol
)
    return angle_to_dcm(θ₁, θ₂, θ₃, rot_seq)
end

@inline function angle_to_rot(
    ::Type{Quaternion},
    θ₁::Number,
    θ₂::Number,
    θ₃::Number,
    rot_seq::Symbol
)
    return angle_to_quat(θ₁, θ₂, θ₃, rot_seq)
end

@inline function angle_to_rot(Θ::EulerAngles)
    return angle_to_rot(Θ.a1, Θ.a2, Θ.a3, Θ.rot_seq)
end

@inline function angle_to_rot(T::Union{Type{DCM}, Type{Quaternion}}, Θ::EulerAngles)
    return angle_to_rot(T, Θ.a1, Θ.a2, Θ.a3, Θ.rot_seq)
end
