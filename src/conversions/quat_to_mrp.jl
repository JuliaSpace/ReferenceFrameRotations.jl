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
    # Check for singularity: q0 = -1 (360 degrees rotation, which is 0 mod 360, but MRP singularity is at 360?
    # Wait, MRP singularity is at +/- 360 degrees (q0 = -1).
    # Normal MRP is singular at +/- 360 deg?
    # No, MRP is singular at +/- 360 degrees (4*arctan(sigma)).
    # sigma = tan(Phi/4). Phi = 360 -> tan(90) = inf.
    # q0 = cos(Phi/2) = cos(180) = -1.
    # So singularity is at q0 = -1.

    if isapprox(q.q0, -1; atol = 1e-15)
        throw(ArgumentError("The quaternion represents a rotation of 360 degrees, which is a singularity for MRP."))
    end

    denom = 1 + q.q0

    return MRP(q.q1 / denom, q.q2 / denom, q.q3 / denom)
end
