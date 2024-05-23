## Description #############################################################################
#
# Functions related to the conversion from quaternion to Euler angle and axis.
#
############################################################################################

export quat_to_angleaxis

"""
    quat_to_angleaxis(q::Quaternion{T}) where T -> EulerAngleAxis

Convert the quaternion `q` to a Euler angle and axis representation (see
[`EulerAngleAxis`](@ref)). By convention, the Euler angle will be kept between `[0, π]` rad.

# Remarks

This function will not fail if the quaternion norm is not 1. However, the meaning of the
results will not be defined, because the input quaternion does not represent a 3D rotation.
The user must handle such situations.

# Examples

```jldoctest
julia> q = Quaternion(cosd(45/2), sind(45/2), 0, 0);

julia> quat_to_angleaxis(q)
EulerAngleAxis{Float64}:
  Euler angle : 0.785398 rad  (45.0°)
  Euler axis  : [1.0, 0.0, 0.0]
```
"""
function quat_to_angleaxis(q::Quaternion{T}) where T
    # If `q0` is 1 or -1, then we have an identity rotation.
    if abs(q.q0) >= 1 - eps()
        return EulerAngleAxis(T(0), SVector{3, T}(0, 0, 0))
    else
        # Compute sin(θ/2).
        sθo2 = √(q.q1 * q.q1 + q.q2 * q.q2 + q.q3 * q.q3)

        # Compute θ in range [0, 2π].
        θ = 2acos(q.q0)

        # Keep θ between [0, π].
        s = +1
        if θ > π
            θ = T(2π) - θ
            s = -1
        end

        return EulerAngleAxis(θ, s * SVector{3}(q.q1, q.q2, q.q3) / sθo2)
    end
end
