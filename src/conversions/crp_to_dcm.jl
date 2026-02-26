## Description #############################################################################
#
# Functions related to the conversion from CRP to DCM.
#
############################################################################################

export crp_to_dcm

"""
    crp_to_dcm(c::CRP) -> DCM

Convert the CRP `c` to a Direction Cosine Matrix (DCM).

# Examples

```jldoctest
julia> c = CRP(0.5, 0, 0)
CRP{Float64}:
  X : + 0.5
  Y : + 0.0
  Z : + 0.0

julia> crp_to_dcm(c)
DCM{Float64}:
 1.0   0.0  0.0
 0.0   0.6  0.8
 0.0  -0.8  0.6
```
"""
function crp_to_dcm(c::CRP)
    c₁  = c.q1
    c₂  = c.q2
    c₃  = c.q3
    c₁² = c₁^2
    c₂² = c₂^2
    c₃² = c₃^2
    d   = 1 + (c₁² + c₂² + c₃²)

    # Auxiliary variables to reduce computational burden.
    c₁c₂ = c₁ * c₂
    c₁c₃ = c₁ * c₃
    c₂c₃ = c₂ * c₃

    return DCM(
        (1 + c₁² - c₂² - c₃²) / d,     2 * (c₁c₂ + c₃) / d,       2 * (c₁c₃ - c₂) / d,
           2 * (c₁c₂ - c₃) / d,    (1 - c₁² + c₂² - c₃²) / d,     2 * (c₂c₃ + c₁) / d,
           2 * (c₁c₃ + c₂) / d,        2 * (c₂c₃ - c₁) / d,   (1 - c₁² - c₂² + c₃²) / d
    )'
end
