## Description #############################################################################
#
# Functions related to the conversion from MRP to CRP.
#
############################################################################################

export mrp_to_crp

"""
    mrp_to_crp(m::MRP) -> CRP

Convert MRP `m` to CRP.

# Examples

```jldoctest
julia> m = MRP(0.5, 0, 0)
MRP{Float64}:
  X : + 0.5
  Y : + 0.0
  Z : + 0.0

julia> mrp_to_crp(m)
CRP{Float64}:
  X : + 1.33333
  Y : + 0.0
  Z : + 0.0
```
"""
function mrp_to_crp(m::MRP)
    # Equation:
    #             2m
    #   CRP = ──────────
    #          1 - |m|²
    #

    m₁ = m.q1
    m₂ = m.q2
    m₃ = m.q3

    norm_q² = m₁^2 + m₂^2 + m₃^2

    if isapprox(norm_q², 1; atol = 1e-15)
        throw(ArgumentError("The MRP represents a rotation of 180 degrees, which is a singularity for CRP."))
    end

    k  = 2 / (1 - norm_q²)

    return CRP(k * m₁, k * m₂, k * m₃)
end
