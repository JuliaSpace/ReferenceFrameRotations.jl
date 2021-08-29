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
function smallangle_to_quat(
    θx::T1,
    θy::T2,
    θz::T3
) where {T1<:Number, T2<:Number, T3<:Number}
    T = promote_type(T1, T2, T3)

    q0     = T(1)
    q1     = T(θx) / 2
    q2     = T(θy) / 2
    q3     = T(θz) / 2
    norm_q = √(q0^2 + q1^2 + q2^2 + q3^2)

    return Quaternion(q0 / norm_q, q1 / norm_q, q2 / norm_q, q3 / norm_q)
end
