## Description #############################################################################
#
# Functions related to the conversion from DCM to quaternion.
#
############################################################################################

export dcm_to_quat

"""
    dcm_to_quat(dcm::DCM) -> Quaternion

Convert the `dcm` to a quaternion.

The type of the quaternion will be automatically selected by the constructor
[`Quaternion`](@ref) to avoid `InexactError`.

# Remarks

By convention, the real part of the quaternion will always be nonnegative (and is zero for
exact half-turns). Moreover, the
function does not check if `dcm` is a valid direction cosine matrix. This must be handled by
the user.

This algorithm was obtained from **[1]**.

# Example

```jldoctest
julia> dcm = angle_to_dcm(pi / 2, 0.0, 0.0, :XYZ);

julia> q = dcm_to_quat(dcm)
Quaternion{Float64}:
  + 0.707107 + 0.707107⋅i + 0.0⋅j + 0.0⋅k
```

# References

- **[1]**: http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/
"""
function dcm_to_quat(dcm::DCM{T}) where {T <: Number}
    Tf = float(T)
    dcm = _float_dcm(dcm)
    z = zero(Tf)
    o = one(Tf)
    two = Tf(2)
    four = Tf(4)
    td = tr(dcm)

    if td > z
        # f = 4 * q0
        f = two * sqrt(max(z, td + o))
        g = inv(f)

        return Quaternion{Tf}(
            f / four,
            (dcm[2, 3] - dcm[3, 2]) * g,
            (dcm[3, 1] - dcm[1, 3]) * g,
            (dcm[1, 2] - dcm[2, 1]) * g,
        )
    elseif (dcm[1, 1] > dcm[2, 2]) && (dcm[1, 1] > dcm[3, 3])
        # f = 4 * q1
        f = two * sqrt(max(z, o + dcm[1, 1] - dcm[2, 2] - dcm[3, 3]))
        g = inv(f)

        # Real part.
        q0 = (dcm[2, 3] - dcm[3, 2]) * g

        # Make sure that the real part is always nonnegative.
        s = (q0 < z) ? -o : o

        return Quaternion{Tf}(
            abs(q0),
            s * f / four,
            s * (dcm[1, 2] + dcm[2, 1]) * g,
            s * (dcm[3, 1] + dcm[1, 3]) * g,
        )
    elseif (dcm[2, 2] > dcm[3, 3])
        # f = 4 * q2
        f = two * sqrt(max(z, o + dcm[2, 2] - dcm[1, 1] - dcm[3, 3]))
        g = inv(f)

        # Real part.
        q0 = (dcm[3, 1] - dcm[1, 3]) * g

        # Make sure that the real part is always nonnegative.
        s = (q0 < z) ? -o : o

        return Quaternion{Tf}(
            abs(q0),
            s * (dcm[1, 2] + dcm[2, 1]) * g,
            s * f / four,
            s * (dcm[3, 2] + dcm[2, 3]) * g,
        )
    else
        # f = 4 * q3
        f = two * sqrt(max(z, o + dcm[3, 3] - dcm[1, 1] - dcm[2, 2]))
        g = inv(f)

        # Real part.
        q0 = (dcm[1, 2] - dcm[2, 1]) * g

        # Make sure that the real part is always nonnegative.
        s = (q0 < z) ? -o : o

        return Quaternion{Tf}(
            abs(q0),
            s * (dcm[1, 3] + dcm[3, 1]) * g,
            s * (dcm[2, 3] + dcm[3, 2]) * g,
            s * f / four,
        )
    end
end
