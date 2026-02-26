## Description #############################################################################
#
# Functions related to the conversion from CRP to Euler angles.
#
############################################################################################

export crp_to_angle

"""
    crp_to_angle(c::CRP, rot_seq::Symbol) -> EulerAngles

Convert CRP `c` to Euler Angles (see [`EulerAngles`](@ref)) given a rotation sequence
`rot_seq`.

The rotation sequence is defined by a `:Symbol`. The possible values are: `:XYX`, `XYZ`,
`:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`, `:ZYX`, and `:ZYZ`. If no
value is specified, it defaults to `:ZYX`.

# Examples

```jldoctest
julia> c = CRP(0.5, 0, 0)
CRP{Float64}:
  X : + 0.5
  Y : + 0.0
  Z : + 0.0

julia> crp_to_angle(c, :XYZ)
EulerAngles{Float64}:
  R(X) :  0.927295 rad  ( 53.1301°)
  R(Y) :  0.0      rad  ( 0.0°)
  R(Z) :  0.0      rad  ( 0.0°)
```
"""
function crp_to_angle(c::CRP, rot_seq::Symbol = :ZYX)
    dcm = crp_to_dcm(c)
    return dcm_to_angle(dcm, rot_seq)
end
