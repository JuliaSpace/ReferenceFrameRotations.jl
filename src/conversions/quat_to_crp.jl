## Description #############################################################################
#
# Functions related to the conversion from quaternion to CRP.
#
############################################################################################

export quat_to_crp

"""
    quat_to_crp(q::Quaternion) -> CRP

Convert Quaternion `q` to CRP.
"""
function quat_to_crp(q::Quaternion)
    if isapprox(q.q0, 0; atol = 1e-15)
        throw(ArgumentError("The quaternion represents a rotation of 180 degrees, which is a singularity for CRP."))
    end

    return CRP(q.q1 / q.q0, q.q2 / q.q0, q.q3 / q.q0)
end
