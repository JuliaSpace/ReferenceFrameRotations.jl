## Description #############################################################################
#
# Functions related to the conversion from DCM to CRP.
#
############################################################################################

export dcm_to_crp

"""
    dcm_to_crp(dcm::DCM) -> CRP

Convert DCM `dcm` to CRP.
"""
function dcm_to_crp(dcm::DCM)
    # Convert transformation matrix to quaternion.
    q = dcm_to_quat(dcm)

    # Convert quaternion to CRP.
    return quat_to_crp(q)
end
