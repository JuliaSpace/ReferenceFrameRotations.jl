## Description #############################################################################
#
# Functions related to the conversion from MRP to Euler angles.
#
############################################################################################

export mrp_to_angle

"""
    mrp_to_angle(m::MRP, rot_seq::Symbol) -> EulerAngles

Convert MRP `m` to Euler Angles (see [`EulerAngles`](@ref)) given a rotation sequence
`rot_seq`.

The rotation sequence is defined by a `:Symbol`. The possible values are: `:XYX`, `XYZ`,
`:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`, `:ZYX`, and `:ZYZ`. If no
value is specified, it defaults to `:ZYX`.

# Examples

```jldoctest
julia> m = MRP(0.5, 0, 0)
MRP{Float64}:
  X : + 0.5
  Y : + 0.0
  Z : + 0.0

julia> mrp_to_angle(m, :XYZ)
EulerAngles{Float64}:
  R(X) :  1.85459 rad  ( 106.26°)
  R(Y) :  0.0     rad  ( 0.0°)
  R(Z) :  0.0     rad  ( 0.0°)
```
"""
function mrp_to_angle(m::MRP, rot_seq::Symbol = :ZYX)
    dcm = mrp_to_dcm(m)
    return dcm_to_angle(dcm, rot_seq)
end
