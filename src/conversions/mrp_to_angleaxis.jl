## Description #############################################################################
#
# Functions related to the conversion from MRP to Euler angle and axis.
#
############################################################################################

export mrp_to_angleaxis

"""
    mrp_to_angleaxis(m::MRP) -> EulerAngleAxis

Convert the MRP `m` to a Euler angle and axis representation (see [`EulerAngleAxis`](@ref)).
By convention, the Euler angle will be kept between `[0, π]` rad.

# Examples

```jldoctest
julia> m = MRP(0.5, 0, 0)
MRP{Float64}:
  X : + 0.5
  Y : + 0.0
  Z : + 0.0

julia> mrp_to_angleaxis(m)
EulerAngleAxis{Float64}:
  Euler angle : 1.85459 rad  (106.26°)
  Euler axis  : [1.0, 0.0, 0.0]
```
"""
function mrp_to_angleaxis(m::MRP)
    q = mrp_to_quat(m)
    return quat_to_angleaxis(q)
end
