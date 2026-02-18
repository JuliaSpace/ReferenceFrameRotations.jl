export crp_to_angleaxis

"""
    crp_to_angleaxis(c::CRP) -> EulerAngleAxis

Convert CRP `c` to Euler Angle and Axis.
"""
function crp_to_angleaxis(c::CRP)
    q = crp_to_quat(c)
    return quat_to_angleaxis(q)
end
