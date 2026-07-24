## Description #############################################################################
#
# Functions related to the conversion from DCM to CRP.
#
############################################################################################

export dcm_to_crp

@inline function _dcm_to_quat_components(dcm::DCM)
    if tr(dcm) > 0
        # f = 4 * q0
        f = 2sqrt(tr(dcm) + 1)

        return f / 4,
            (dcm[2, 3] - dcm[3, 2]) / f,
            (dcm[3, 1] - dcm[1, 3]) / f,
            (dcm[1, 2] - dcm[2, 1]) / f
    elseif (dcm[1, 1] > dcm[2, 2]) && (dcm[1, 1] > dcm[3, 3])
        # f = 4 * q1
        f = 2sqrt(1 + dcm[1, 1] - dcm[2, 2] - dcm[3, 3])
        q0 = (dcm[2, 3] - dcm[3, 2]) / f
        s = (q0 > 0) ? +1 : -1

        return s * q0,
            s * f / 4,
            s * (dcm[1, 2] + dcm[2, 1]) / f,
            s * (dcm[3, 1] + dcm[1, 3]) / f
    elseif dcm[2, 2] > dcm[3, 3]
        # f = 4 * q2
        f = 2sqrt(1 + dcm[2, 2] - dcm[1, 1] - dcm[3, 3])
        q0 = (dcm[3, 1] - dcm[1, 3]) / f
        s = (q0 > 0) ? +1 : -1

        return s * q0,
            s * (dcm[1, 2] + dcm[2, 1]) / f,
            s * f / 4,
            s * (dcm[3, 2] + dcm[2, 3]) / f
    else
        # f = 4 * q3
        f = 2sqrt(1 + dcm[3, 3] - dcm[1, 1] - dcm[2, 2])
        q0 = (dcm[1, 2] - dcm[2, 1]) / f
        s = (q0 > 0) ? +1 : -1

        return s * q0,
            s * (dcm[1, 3] + dcm[3, 1]) / f,
            s * (dcm[2, 3] + dcm[3, 2]) / f,
            s * f / 4
    end
end

"""
    dcm_to_crp(dcm::DCM) -> CRP

Convert DCM `dcm` to CRP.
"""
function dcm_to_crp(dcm::DCM)
    q0, q1, q2, q3 = _dcm_to_quat_components(dcm)

    if isapprox(q0, zero(q0); atol = eps(one(q0)))
        throw(ArgumentError("The quaternion represents a rotation of 180 degrees, which is a singularity for CRP."))
    end

    return CRP(q1 / q0, q2 / q0, q3 / q0)
end
