## Description #############################################################################
#
# Functions related to the conversion from CRP to quaternion.
#
############################################################################################

export crp_to_quat

"""
    crp_to_quat(c::CRP) -> Quaternion

Convert CRP `c` to a quaternion.

# Remarks

By convention, the real part of the quaternion will always be positive. Moreover, the
function does not check if `dcm` is a valid direction cosine matrix. This must be handle by
the user.

# Example

```jldoctest
julia> c = CRP(0.5, 0, 0)
CRP{Float64}:
  X : + 0.5
  Y : + 0.0
  Z : + 0.0

julia> crp_to_quat(c)
Quaternion{Float64}:
  + 0.894427 + 0.447214⋅i + 0.0⋅j + 0.0⋅k
```
"""
function crp_to_quat(c::CRP)
    c₁ = c.q1
    c₂ = c.q2
    c₃ = c.q3

    norm_q² = c₁^2 + c₂^2 + c₃^2
    β₀ = 1 / √(1 + norm_q²)

    return Quaternion(β₀, c₁ * β₀, c₂ * β₀, c₃ * β₀)
end
