## Description #############################################################################
#
# Julia API functions to implement conversions between representations.
#
############################################################################################

# == Conversions to DCM ====================================================================

Base.convert(::Type{<:DCM}, a::EulerAngles)    = angle_to_dcm(a)
Base.convert(::Type{<:DCM}, a::Quaternion)     = quat_to_dcm(a)
Base.convert(::Type{<:DCM}, a::EulerAngleAxis) = angleaxis_to_dcm(a)

# == Conversion to Euler Angles ============================================================

function Base.convert(::Type{<:_EulerAngleConversion{R}}, a::DCM) where R
    return dcm_to_angle(a, R)
end

function Base.convert(::Type{<:_EulerAngleConversion{R}}, a::EulerAngles) where R
    return angle_to_angle(a, R)
end

function Base.convert(::Type{<:_EulerAngleConversion{R}}, a::EulerAngleAxis) where R
    return angleaxis_to_angle(a, R)
end

function Base.convert(::Type{<:_EulerAngleConversion{R}}, a::Quaternion) where R
    return quat_to_angle(a, R)
end

Base.convert(::Type{<:EulerAngles}, a::DCM)            = dcm_to_angle(a, :ZYX)
Base.convert(::Type{<:EulerAngles}, a::EulerAngleAxis) = angleaxis_to_angle(a, :ZYX)
Base.convert(::Type{<:EulerAngles}, a::Quaternion)     = quat_to_angle(a, :ZYX)

# == Conversions to Euler Angle and Axis ===================================================

Base.convert(::Type{<:EulerAngleAxis}, a::DCM)         = dcm_to_angleaxis(a)
Base.convert(::Type{<:EulerAngleAxis}, a::EulerAngles) = angle_to_angleaxis(a)
Base.convert(::Type{<:EulerAngleAxis}, a::Quaternion)  = quat_to_angleaxis(a)

# == Conversions to Quaternions ============================================================

Base.convert(::Type{<:Quaternion}, a::DCM)            = dcm_to_quat(a)
Base.convert(::Type{<:Quaternion}, a::EulerAngles)    = angle_to_quat(a)
Base.convert(::Type{<:Quaternion}, a::EulerAngleAxis) = angleaxis_to_quat(a)
