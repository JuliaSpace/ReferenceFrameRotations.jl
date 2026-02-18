export mrp_to_quat

"""
    mrp_to_quat(m::MRP) -> Quaternion

Convert MRP `m` to a Quaternion.
"""
function mrp_to_quat(m::MRP)
    s_sq = m.q1^2 + m.q2^2 + m.q3^2
    denom = 1 + s_sq
    
    β0 = (1 - s_sq) / denom
    f = 2 / denom
    
    return Quaternion(β0, f * m.q1, f * m.q2, f * m.q3)
end
