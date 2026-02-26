## Description #############################################################################
#
# Functions related to the conversion from MRP to Euler angles.
#
############################################################################################

export mrp_to_angle

"""
    mrp_to_angle(m::MRP, rot_seq::Symbol) -> EulerAngles

Convert MRP `m` to Euler Angles with rotation sequence `rot_seq`.
"""
function mrp_to_angle(m::MRP, rot_seq::Symbol = :ZYX)
    dcm = mrp_to_dcm(m)
    return dcm_to_angle(dcm, rot_seq)
end
