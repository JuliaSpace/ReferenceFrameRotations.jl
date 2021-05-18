# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the conversion from quaternion to Euler angles.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export quat_to_angle

"""
    quat_to_angle(q::Quaternion, rot_seq::Symbol = :ZYX)

Convert the quaternion `q` to Euler Angles (see [`EulerAngles`](@ref)) given a
rotation sequence `rot_seq`.

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`. If no value is specified, then it defaults to `:ZYX`.

# Examples

```julia-repl
julia> q = Quaternion(cosd(45/2), sind(45/2), 0, 0)
Quaternion{Float64}:
  + 0.9238795325112867 + 0.3826834323650898.i + 0.0.j + 0.0.k

julia> quat_to_angle(q, :XYZ)
EulerAngles{Float64}:
  R(X) :  0.7853981633974484 rad  ( 45.00000000000001°)
  R(Y) :  0.0                rad  ( 0.0°)
  R(Z) :  0.0                rad  ( 0.0°)
```
"""
function quat_to_angle(q::Quaternion, rot_seq::Symbol = :ZYX)
    # Convert the quaternion to DCM.
    dcm = quat_to_dcm(q)

    # Convert the DCM to the Euler Angles.
    return dcm_to_angle(dcm, rot_seq)
end
