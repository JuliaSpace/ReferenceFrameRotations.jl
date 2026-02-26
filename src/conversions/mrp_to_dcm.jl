## Description #############################################################################
#
# Functions related to the conversion from MRP to DCM.
#
############################################################################################

export mrp_to_dcm

"""
    mrp_to_dcm(m::MRP) -> DCM

Convert MRP `m` to a Direction Cosine Matrix (DCM).

# Examples

```jldoctest
julia> m = MRP(0.5, 0, 0)
MRP{Float64}:
  X : + 0.5
  Y : + 0.0
  Z : + 0.0

julia> mrp_to_dcm(m)
DCM{Float64}:
 1.0   0.0    0.0
 0.0  -0.28   0.96
 0.0  -0.96  -0.28
```
"""
function mrp_to_dcm(m::MRP)
    # Equation:
    #               8 (mˣ)² - 4(1 - |m|²) mˣ
    #   DCM = I₃ + ──────────────────────────
    #                     (1 + |m|²)²
    #

    m₁  = m.q1
    m₂  = m.q2
    m₃  = m.q3

    m₁² = m₁^2
    m₂² = m₂^2
    m₃² = m₃^2

    norm_m² = m₁² + m₂² + m₃²

    k₂  = (1 - norm_m²)
    d   = (1 + norm_m²)^2

    # Skew symmetric matrix components.
    #
    #        ┌            ┐
    #        │ 0  -m₃  m₂ │
    #   mˣ = │ m₃  0  -m₁ │
    #        │ m₂  m₁  0  │
    #        └            ┘

    mˣ₁₂  = -m₃
    mˣ₁₃  =  m₂
    mˣ₂₁  =  m₃
    mˣ₂₃  = -m₁
    mˣ₃₁  = -m₂
    mˣ₃₂  =  m₁

    # Squared skew symmetric matrix components.
    #
    #   mˣ² = mˣ ⋅ mˣ
    #

    mˣ²₁₁ = -m₃² - m₂²
    mˣ²₁₂ = m₁ * m₂
    mˣ²₁₃ = m₁ * m₃

    mˣ²₂₁ = mˣ²₁₂
    mˣ²₂₂ = -m₃² - m₁²
    mˣ²₂₃ = m₂ * m₃

    mˣ²₃₁ = mˣ²₁₃
    mˣ²₃₂ = mˣ²₂₃
    mˣ²₃₃ = -m₂² - m₁²

    # Combine
    d₁₁ = 1 + 8mˣ²₁₁ / d
    d₁₂ = (8mˣ²₁₂ - 4k₂ * mˣ₁₂) / d
    d₁₃ = (8mˣ²₁₃ - 4k₂ * mˣ₁₃) / d

    d₂₁ = (8mˣ²₂₁ - 4k₂ * mˣ₂₁) / d
    d₂₂ = 1 + 8mˣ²₂₂ / d
    d₂₃ = (8mˣ²₂₃ - 4k₂ * mˣ₂₃) / d

    d₃₁ = (8mˣ²₃₁ - 4k₂ * mˣ₃₁) / d
    d₃₂ = (8mˣ²₃₂ - 4k₂ * mˣ₃₂) / d
    d₃₃ = 1 + 8mˣ²₃₃ / d

    return DCM(d₁₁, d₁₂, d₁₃, d₂₁, d₂₂, d₂₃, d₃₁, d₃₂, d₃₃)'
end
