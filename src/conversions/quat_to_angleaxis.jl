## Description #############################################################################
#
# Functions related to the conversion from quaternion to Euler angle and axis.
#
############################################################################################

export quat_to_angleaxis

"""
    quat_to_angleaxis(q::Quaternion) -> EulerAngleAxis

Convert the quaternion `q` to an Euler angle and axis representation (see
[`EulerAngleAxis`](@ref)). By convention, keep the Euler angle between `[0, π]` [rad].

If `q` is the identity rotation, the Euler axis is undefined. In this case, return the zero
vector `[0, 0, 0]` as the axis.

!!! note

    If the rotation is a half turn (`θ = π`), then `v` and `-v` describe exactly the same
    rotation. Hence, the sign of the returned axis is arbitrary.

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

    # Compute sin(θ/2) from the vectorial part.
    sθo2 = sqrt(q1 * q1 + q2 * q2 + q3 * q3)

    # If the vectorial part vanishes, the rotation is the identity and the axis is undefined.
    # Return the zero axis by convention.
    if iszero(sθo2)
        return EulerAngleAxis(z, SVector{3, Tf}(z, z, z))
    else
        # Compute θ in range [0, 2π]. `atan` is well conditioned everywhere, unlike
        # `acos(q0)`, which loses precision for θ near 0.
        θ = two * atan(sθo2, q0)

        # Keep θ between [0, π].
        s = o
        if θ > Tf(π)
            θ = two * Tf(π) - θ
            s = -o
        end

        return EulerAngleAxis(θ, s * SVector{3, Tf}(q1, q2, q3) / sθo2)
    end
end
