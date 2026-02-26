## Description #############################################################################
#
# Functions related to the conversion from CRP to MRP.
#
############################################################################################

export crp_to_mrp

"""
    crp_to_mrp(c::CRP) -> MRP

Convert CRP `c` to MRP.

# Examples

```jldoctest
julia> c = CRP(0.5, 0, 0)
CRP{Float64}:
  X : + 0.5
  Y : + 0.0
  Z : + 0.0

julia> crp_to_mrp(c)
MRP{Float64}:
  X : + 0.236068
  Y : + 0.0
  Z : + 0.0
```
"""
function crp_to_mrp(c::CRP)
    # Equation:
    #                 c
    #   MRP = ─────────────────
    #          1 + √(1 + |c|²)
    #

    c₁ = c.q1
    c₂ = c.q2
    c₃ = c.q3

    norm_q² = c₁^2 + c₂^2 + c₃^2

    k  = 1 / (1 + √(1 + norm_q²))

    return MRP(k * c₁, k * c₂, k * c₃)
end

