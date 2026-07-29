## Description #############################################################################
#
# Functions related to the conversion from DCM to Euler angle and axis.
#
############################################################################################

export dcm_to_angleaxis

"""
    dcm_to_angleaxis(dcm::DCM) -> EulerAngleAxis

Convert the `dcm` to an Euler angle and axis representation.

Return an angle in the interval `[0, π]` [rad] by convention.

If `dcm` is the identity, the rotation angle is `0` and the Euler axis is undefined. In this
case, return the zero vector `[0, 0, 0]` as the axis.

!!! note

    If the rotation is a half turn (`θ = π`), then `v` and `-v` describe exactly the same
    rotation. Hence, the sign of the returned axis is arbitrary.

# Remarks

The conversion is performed through the quaternion representation, which is numerically well
conditioned for every rotation angle, including `θ` near `π`.
"""
function dcm_to_angleaxis(dcm::DCM{T}) where {T <: Number}
    return quat_to_angleaxis(dcm_to_quat(dcm))
end
