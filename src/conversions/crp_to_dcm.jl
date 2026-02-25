## Description #############################################################################
#
# Functions related to the conversion from CRP to DCM.
#
############################################################################################

export crp_to_dcm

"""
    crp_to_dcm(c::CRP) -> DCM

Convert CRP `c` to a Direction Cosine Matrix (DCM).
"""
function crp_to_dcm(c::CRP)
    q = c
    q_sq = q.q1^2 + q.q2^2 + q.q3^2
    denom = 1 + q_sq

    # Auxiliary variables to reduce computational burden.
    q1q2 = q.q1 * q.q2
    q1q3 = q.q1 * q.q3
    q2q3 = q.q2 * q.q3

    return DCM(
        (1 + q.q1^2 - q.q2^2 - q.q3^2) / denom,  2 * (q1q2 + q.q3) / denom,              2 * (q1q3 - q.q2) / denom,
        2 * (q1q2 - q.q3) / denom,               (1 - q.q1^2 + q.q2^2 - q.q3^2) / denom, 2 * (q2q3 + q.q1) / denom,
        2 * (q1q3 + q.q2) / denom,               2 * (q2q3 - q.q1) / denom,              (1 - q.q1^2 - q.q2^2 + q.q3^2) / denom
    )'
end
