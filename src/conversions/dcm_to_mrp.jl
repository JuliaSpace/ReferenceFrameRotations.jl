export dcm_to_mrp

"""
    dcm_to_mrp(dcm::DCM) -> MRP

Convert DCM `dcm` to MRP.
"""
function dcm_to_mrp(dcm::DCM)
    return quat_to_mrp(dcm_to_quat(dcm))
end
