# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the conversion from small Euler angles to quaternion.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export smallangle_to_quat

"""
    smallangle_to_quat(θx::Number, θy::Number, θz::Number)

Create a quaternion from three small rotations of angles `θx`, `θy`, and `θz`
[rad] about the axes X, Y, and Z, respectively.

!!! note
    The quaternion is always normalized.

# Example

```jldoctest
julia> smallangle_to_quat(+0.01, -0.01, +0.01)
Quaternion{Float64}:
  + 0.999963 + 0.00499981⋅i - 0.00499981⋅j - 0.00499981⋅k
```
"""
function smallangle_to_quat(θx::Number, θy::Number, θz::Number)
    q0     = 1
    q1     = θx / 2
    q2     = θy / 2
    q3     = θz / 2
    norm_q = √(q0^2 + q1^2 + q2^2 + q3^2)

    return Quaternion(q0 / norm_q, q1 / norm_q, q2 / norm_q, q3 / norm_q)
end
