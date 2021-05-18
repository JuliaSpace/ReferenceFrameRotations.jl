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
  R(X) : -1.0471975511965976 rad  (-59.99999999999999°)
  R(Y) :  0.7853981633974482 rad  ( 44.99999999999999°)
  R(Z) : -1.5707963267948966 rad  (-90.0°)

julia> angle_to_angle(-pi / 2, 0, 0, :ZYX, :XYZ)
EulerAngles{Float64}:
  R(X) :  0.0                rad  ( 0.0°)
  R(Y) :  0.0                rad  ( 0.0°)
  R(Z) : -1.5707963267948966 rad  (-90.0°)

julia> Θ = EulerAngles(1, 2, 3, :XYX)
EulerAngles{Int64}:
  R(X) :  1 rad  ( 57.29577951308232°)
  R(Y) :  2 rad  ( 114.59155902616465°)
  R(X) :  3 rad  ( 171.88733853924697°)

julia> angle_to_angle(Θ, :ZYZ)
EulerAngles{Float64}:
  R(Z) : -2.7023903824034057 rad  (-154.83556350845976°)
  R(Y) :  1.4667622012262838 rad  ( 84.03928367958444°)
  R(Z) : -1.0541508719307968 rad  (-60.398395931670414°)
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
