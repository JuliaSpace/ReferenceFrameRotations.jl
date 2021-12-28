# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Julia API functions to implement conversions between representations.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Conversions to DCM
# ==============================================================================

Base.convert(::Type{<:DCM}, a::EulerAngles)    = angle_to_dcm(a)
Base.convert(::Type{<:DCM}, a::Quaternion)     = quat_to_dcm(a)
Base.convert(::Type{<:DCM}, a::EulerAngleAxis) = angleaxis_to_dcm(a)

# Conversions to quaternions
# ==============================================================================

Base.convert(::Type{<:Quaternion}, a::DCM)            = dcm_to_quat(a)
Base.convert(::Type{<:Quaternion}, a::EulerAngles)    = angle_to_quat(a)
Base.convert(::Type{<:Quaternion}, a::EulerAngleAxis) = angleaxis_to_quat(a)
