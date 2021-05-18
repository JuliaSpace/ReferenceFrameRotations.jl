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
  + 0.7010573846499779 - 0.09229595564125714.i + 0.5609855267969309.j + 0.43045933457687935.k
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
