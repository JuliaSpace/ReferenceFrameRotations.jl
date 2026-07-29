## Description #############################################################################
#
# Functions related to the conversion from quaternion to MRP.
#
############################################################################################

export quat_to_mrp

"""
    quat_to_mrp(q::Quaternion) -> MRP

Convert Quaternion `q` to MRP.
"""
function quat_to_mrp(q::Quaternion)
    # MRP = tan(Φ/4)⋅ê is singular at Φ = 2π, i.e. q0 = cos(Φ/2) = -1.
    if isapprox(q.q0, -1; atol = 1e-15)
        throw(
            ArgumentError(
                "The quaternion represents a rotation of 360 degrees, which is a singularity for MRP.",
            ),
        )
    end

    denom = 1 + q.q0

    return MRP(q.q1 / denom, q.q2 / denom, q.q3 / denom)
end
