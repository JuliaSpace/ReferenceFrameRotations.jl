## Description #############################################################################
#
# Functions related to the conversion from MRP to Euler angle and axis.
#
############################################################################################

export mrp_to_angleaxis

"""
    mrp_to_angleaxis(m::MRP) -> EulerAngleAxis

Convert MRP `m` to Euler Angle and Axis.
"""
function mrp_to_angleaxis(m::MRP)
    q = mrp_to_quat(m)
    return quat_to_angleaxis(q)
end
