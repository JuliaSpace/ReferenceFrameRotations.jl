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

    # Auxiliary variables to reduce computational burden. Notice that we hoist the division
    # by the common denominator to avoid performing it nine times.
    id   = inv(1 + (c₁² + c₂² + c₃²))
    c₁c₂ = c₁ * c₂
    c₁c₃ = c₁ * c₃
    c₂c₃ = c₂ * c₃

    #! format: off
    return DCM(
        (1 + c₁² - c₂² - c₃²) * id,     2 * (c₁c₂ + c₃) * id,       2 * (c₁c₃ - c₂) * id,
           2 * (c₁c₂ - c₃) * id,    (1 - c₁² + c₂² - c₃²) * id,     2 * (c₂c₃ + c₁) * id,
           2 * (c₁c₃ + c₂) * id,        2 * (c₂c₃ - c₁) * id,   (1 - c₁² - c₂² + c₃²) * id
    )'
    #! format: on
end
