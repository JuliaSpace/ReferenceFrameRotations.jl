# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the conversion between Euler angles.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export angle_to_angle

"""
    angle_to_angle(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq_orig::Symbol, rot_seq_dest::Symbol)
    angle_to_angle(Θ::EulerAngles, rot_seq_dest::Symbol)

Convert the Euler angles `θ₁`, `θ₂`, and `θ₃` [rad] with the rotation sequence
`rot_seq_orig` to a new set of Euler angles with rotation sequence
`rot_seq_dest`.

The input values of the origin Euler angles can also be passed inside the
structure `Θ` (see [`EulerAngles`](@ref)).

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`.

# Example

```julia-repl
julia> angle_to_angle(-pi / 2, -pi / 3, -pi / 4, :ZYX, :XYZ)
EulerAngles{Float64}:
  R(X):  -1.0472 rad ( -60.0000 deg)
  R(Y):   0.7854 rad (  45.0000 deg)
  R(Z):  -1.5708 rad ( -90.0000 deg)

julia> angle_to_angle(-pi / 2, 0, 0, :ZYX, :XYZ)
EulerAngles{Float64}:
  R(X):   0.0000 rad (   0.0000 deg)
  R(Y):   0.0000 rad (   0.0000 deg)
  R(Z):  -1.5708 rad ( -90.0000 deg)

julia> Θ = EulerAngles(1, 2, 3, :XYX)
EulerAngles{Int64}:
  R(X):   1.0000 rad (  57.2958 deg)
  R(Y):   2.0000 rad ( 114.5916 deg)
  R(X):   3.0000 rad ( 171.8873 deg)

julia> angle_to_angle(Θ, :ZYZ)
EulerAngles{Float64}:
  R(Z):  -2.7024 rad (-154.8356 deg)
  R(Y):   1.4668 rad (  84.0393 deg)
  R(Z):  -1.0542 rad ( -60.3984 deg)
```
"""
@inline function angle_to_angle(
    θ₁::Number,
    θ₂::Number,
    θ₃::Number,
    rot_seq_orig::Symbol,
    rot_seq_dest::Symbol
)
    return dcm_to_angle(angle_to_dcm(θ₁, θ₂, θ₃, rot_seq_orig), rot_seq_dest)
end

@inline function angle_to_angle(Θ::EulerAngles, rot_seq_dest::Symbol)
    return angle_to_angle(Θ.a1, Θ.a2, Θ.a3, Θ.rot_seq, rot_seq_dest)
end
