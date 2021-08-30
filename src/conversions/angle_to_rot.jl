# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the API to convert from Euler angles to rotation
#   representations.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export angle_to_rot

"""
    angle_to_rot([T,] θ::Number, axis::Symbol)

Create a rotation described by the type `T` that rotates the reference frame
about `axis` by an angle `θ` [rad]. `axis` can be `:X`, `:Y`, or `:Z`. `T`
can be `DCM` or `Quaternion`.

If the type `T` is not specified, then it defaults to `DCM`.

# Example

```jldocstest
julia> angle_to_rot(-pi / 4, :Y)
3×3 StaticArrays.SMatrix{3, 3, Float64, 9} with indices SOneTo(3)×SOneTo(3):
  0.707107  0.0  0.707107
  0.0       1.0  0.0
 -0.707107  0.0  0.707107

julia> angle_to_rot(Quaternion, -pi / 4, :Y)
Quaternion{Float64}:
  + 0.92388 + 0.0⋅i - 0.382683⋅j + 0.0⋅k
```
"""
@inline function angle_to_rot(θ::Number, axis::Symbol)
    return angle_to_dcm(θ, axis)
end

@inline function angle_to_rot(::Type{DCM}, θ::Number, axis::Symbol)
    return angle_to_dcm(θ, axis)
end

@inline function angle_to_rot(::Type{Quaternion}, θ::Number, axis::Symbol)
    return angle_to_quat(θ, axis)
end

"""
    angle_to_rot([T,] θx::Number, θy::Number, θz::Number, rot_seq::Symbol)
    angle_to_rot([T,] Θ::EulerAngles)

Convert the Euler angles `Θx`, `Θy`, and `Θz` [rad] with the rotation sequence
`rot_seq` to a rotation description of type `T`, which can be `DCM` or
`Quaternion`.

The input values of the origin Euler angles can also be passed inside the
structure `Θ` (see [`EulerAngles`](@ref)).

If the type `T` is not specified, then it defaults to `DCM`.

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`. If no value is specified, then it defaults to `:ZYX`.

# Example

```julia-repl
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
@inline function angle_to_rot(
    θx::Number,
    θy::Number,
    θz::Number,
    rot_seq::Symbol
)
    return angle_to_dcm(θx, θy, θz, rot_seq)
end

@inline function angle_to_rot(
        ::Type{DCM},
        θx::Number,
        θy::Number,
        θz::Number,
        rot_seq::Symbol
)
    return angle_to_dcm(θx, θy, θz, rot_seq)
end

@inline function angle_to_rot(
        ::Type{Quaternion},
        θx::Number,
        θy::Number,
        θz::Number,
        rot_seq::Symbol
)
    return angle_to_quat(θx, θy, θz, rot_seq)
end

@inline function angle_to_rot(Θ::EulerAngles)
    return angle_to_rot(Θ.a1, Θ.a2, Θ.a3, Θ.rot_seq)
end

@inline function angle_to_rot(
        T::Union{Type{DCM}, Type{Quaternion}},
        Θ::EulerAngles
)
    return angle_to_rot(T, Θ.a1, Θ.a2, Θ.a3, Θ.rot_seq)
end
