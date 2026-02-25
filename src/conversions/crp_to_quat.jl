## Description #############################################################################
#
# Functions related to the conversion from CRP to quaternion.
#
############################################################################################

export crp_to_quat

"""
    crp_to_quat(c::CRP) -> Quaternion

Convert CRP `c` to a Quaternion.
"""
function crp_to_quat(c::CRP)
    q_sq = c.q1^2 + c.q2^2 + c.q3^2
    β0 = 1 / sqrt(1 + q_sq)

    return Quaternion(β0, c.q1 * β0, c.q2 * β0, c.q3 * β0)
end
