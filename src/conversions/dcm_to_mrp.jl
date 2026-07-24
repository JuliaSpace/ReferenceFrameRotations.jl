## Description #############################################################################
#
# Functions related to the conversion from DCM to MRP.
#
############################################################################################

export dcm_to_mrp

"""
    dcm_to_mrp(dcm::DCM) -> MRP

Convert DCM `dcm` to MRP.
"""
function dcm_to_mrp(dcm::DCM)
    q0, q1, q2, q3 = _dcm_to_quat_components(dcm)

    if isapprox(q0, -1; atol = 1e-15)
        throw(ArgumentError("The quaternion represents a rotation of 360 degrees, which is a singularity for MRP."))
    end

    return MRP(q1 / (1 + q0), q2 / (1 + q0), q3 / (1 + q0))
end
