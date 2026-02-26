## Description #############################################################################
#
# Functions related to the conversion from MRP to quaternion.
#
############################################################################################

export mrp_to_quat

"""
    mrp_to_quat(m::MRP) -> Quaternion

Convert MRP `m` to a quaternion.

# Remarks

By convention, the real part of the quaternion will always be positive. Moreover, the
function does not check if `dcm` is a valid direction cosine matrix. This must be handle by
the user.

# Example

```jldoctest
julia> m = MRP(0.5, 0, 0)
MRP{Float64}:
  X : + 0.5
  Y : + 0.0
  Z : + 0.0

julia> mrp_to_quat(m)
Quaternion{Float64}:
  + 0.6 + 0.8⋅i + 0.0⋅j + 0.0⋅k
```
"""
function mrp_to_quat(m::MRP)
    m₁ = m.q1
    m₂ = m.q2
    m₃ = m.q3

    norm_q² = m₁^2 + m₂^2 + m₃^2
    d       = 1 + norm_q²
    β₀      = (1 - norm_q²) / d
    f       = 2 / d

    return Quaternion(β₀, f * m₁, f * m₂, f * m₃)
end
