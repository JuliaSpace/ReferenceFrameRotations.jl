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

    m₁ = m.q1
    m₂ = m.q2
    m₃ = m.q3

    m₁² = m₁^2
    m₂² = m₂^2
    m₃² = m₃^2

    norm_m² = m₁² + m₂² + m₃²

    # Hoist the division by the common denominator to avoid performing it nine times.
    id = inv((1 + norm_m²)^2)

    # Combine the factor 4(1 - |m|²) and the common denominator into a single constant.
    k = 4 * (1 - norm_m²) * id

    # Skew symmetric matrix components.
    #
    #        ┌            ┐
    #        │ 0  -m₃  m₂ │
    #   mˣ = │ m₃  0  -m₁ │
    #        │-m₂  m₁  0  │
    #        └            ┘

    mˣ₁₂ = -m₃
    mˣ₁₃ = m₂
    mˣ₂₁ = m₃
    mˣ₂₃ = -m₁
    mˣ₃₁ = -m₂
    mˣ₃₂ = m₁

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
    d₁₁ = 1 + 8mˣ²₁₁ * id
    d₁₂ = 8mˣ²₁₂ * id - k * mˣ₁₂
    d₁₃ = 8mˣ²₁₃ * id - k * mˣ₁₃

    d₂₁ = 8mˣ²₂₁ * id - k * mˣ₂₁
    d₂₂ = 1 + 8mˣ²₂₂ * id
    d₂₃ = 8mˣ²₂₃ * id - k * mˣ₂₃

    d₃₁ = 8mˣ²₃₁ * id - k * mˣ₃₁
    d₃₂ = 8mˣ²₃₂ * id - k * mˣ₃₂
    d₃₃ = 1 + 8mˣ²₃₃ * id

    return DCM(d₁₁, d₁₂, d₁₃, d₂₁, d₂₂, d₂₃, d₃₁, d₃₂, d₃₃)'
end
