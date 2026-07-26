## Description #############################################################################
#
# Functions related to the conversion from quaternion to Euler angle and axis.
#
############################################################################################

export quat_to_angleaxis

"""
    quat_to_angleaxis(q::Quaternion{T}) where T -> EulerAngleAxis

Convert the quaternion `q` to an Euler angle and axis representation (see
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
function quat_to_angleaxis(q::Quaternion{T}) where {T}
    Tf = float(T)
    q0 = Tf(q.q0)
    q1 = Tf(q.q1)
    q2 = Tf(q.q2)
    q3 = Tf(q.q3)
    z = zero(Tf)
    o = one(Tf)
    two = Tf(2)

    # If `q0` is 1 or -1, then we have an identity rotation.
    if abs(q0) >= o - eps(Tf)
        return EulerAngleAxis(z, SVector{3, Tf}(z, z, z))
    else
        # Compute sin(θ/2).
        sθo2 = sqrt(max(z, q1 * q1 + q2 * q2 + q3 * q3))

        # Compute θ in range [0, 2π].
        θ = two * acos(clamp(q0, -o, o))

        # Keep θ between [0, π].
        s = o
        if θ > Tf(π)
            θ = two * Tf(π) - θ
            s = -o
        end

        return EulerAngleAxis(θ, s * SVector{3, Tf}(q1, q2, q3) / sθo2)
    end
end
