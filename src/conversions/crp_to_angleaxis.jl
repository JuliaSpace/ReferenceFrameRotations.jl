## Description #############################################################################
#
# Functions related to the conversion from CRP to Euler angle and axis.
#
############################################################################################

export crp_to_angleaxis

"""
    crp_to_angleaxis(c::CRP) -> EulerAngleAxis

Convert the CRP `c` to a Euler angle and axis representation (see [`EulerAngleAxis`](@ref)).
By convention, the Euler angle will be kept between `[0, π]` rad.

# Examples

```jldoctest
julia> c = CRP(0.5, 0, 0)
CRP{Float64}:
  X : + 0.5
  Y : + 0.0
  Z : + 0.0

julia> crp_to_angleaxis(c)
EulerAngleAxis{Float64}:
  Euler angle : 0.927295 rad  (53.1301°)
  Euler axis  : [1.0, 0.0, 0.0]
```
"""
function crp_to_angleaxis(c::CRP)
    q = crp_to_quat(c)
    return quat_to_angleaxis(q)
end
