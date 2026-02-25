## Description #############################################################################
#
# Functions related to the conversion from CRP to Euler angles.
#
############################################################################################

export crp_to_angle

"""
    crp_to_angle(c::CRP, rot_seq::Symbol) -> EulerAngles

Convert CRP `c` to Euler Angles with rotation sequence `rot_seq`.
"""
function crp_to_angle(c::CRP, rot_seq::Symbol)
    dcm = crp_to_dcm(c)
    return dcm_to_angle(dcm, rot_seq)
end
