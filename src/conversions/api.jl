## Description #############################################################################
#
# Julia API functions to implement conversions between representations.
#
############################################################################################

# == Conversions to DCM ====================================================================

Base.convert(::Type{<:DCM}, a::EulerAngles)    = angle_to_dcm(a)
Base.convert(::Type{<:DCM}, a::Quaternion)     = quat_to_dcm(a)
Base.convert(::Type{<:DCM}, a::EulerAngleAxis) = angleaxis_to_dcm(a)
Base.convert(::Type{<:DCM}, a::CRP)            = crp_to_dcm(a)
Base.convert(::Type{<:DCM}, a::MRP)            = mrp_to_dcm(a)

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

function Base.convert(::Type{<:_EulerAngleConversion{R}}, a::CRP) where R
    return crp_to_angle(a, R)
end

function Base.convert(::Type{<:_EulerAngleConversion{R}}, a::MRP) where R
    return mrp_to_angle(a, R)
end

Base.convert(::Type{<:EulerAngles}, a::DCM)            = dcm_to_angle(a, :ZYX)
Base.convert(::Type{<:EulerAngles}, a::EulerAngleAxis) = angleaxis_to_angle(a, :ZYX)
Base.convert(::Type{<:EulerAngles}, a::Quaternion)     = quat_to_angle(a, :ZYX)
Base.convert(::Type{<:EulerAngles}, a::CRP)            = crp_to_angle(a, :ZYX)
Base.convert(::Type{<:EulerAngles}, a::MRP)            = mrp_to_angle(a, :ZYX)

# == Conversions to Euler Angle and Axis ===================================================

Base.convert(::Type{<:EulerAngleAxis}, a::DCM)         = dcm_to_angleaxis(a)
Base.convert(::Type{<:EulerAngleAxis}, a::EulerAngles) = angle_to_angleaxis(a)
Base.convert(::Type{<:EulerAngleAxis}, a::Quaternion)  = quat_to_angleaxis(a)
Base.convert(::Type{<:EulerAngleAxis}, a::CRP)         = crp_to_angleaxis(a)
Base.convert(::Type{<:EulerAngleAxis}, a::MRP)         = mrp_to_angleaxis(a)

# == Conversions to Quaternions ============================================================

Base.convert(::Type{<:Quaternion}, a::DCM)            = dcm_to_quat(a)
Base.convert(::Type{<:Quaternion}, a::EulerAngles)    = angle_to_quat(a)
Base.convert(::Type{<:Quaternion}, a::EulerAngleAxis) = angleaxis_to_quat(a)
Base.convert(::Type{<:Quaternion}, a::CRP)            = crp_to_quat(a)
Base.convert(::Type{<:Quaternion}, a::MRP)            = mrp_to_quat(a)

# == Conversions to CRP ====================================================================

Base.convert(::Type{<:CRP}, a::DCM)            = dcm_to_crp(a)
Base.convert(::Type{<:CRP}, a::Quaternion)     = quat_to_crp(a)
Base.convert(::Type{<:CRP}, a::EulerAngles)    = angle_to_crp(a)
Base.convert(::Type{<:CRP}, a::EulerAngleAxis) = dcm_to_crp(angleaxis_to_dcm(a))
Base.convert(::Type{<:CRP}, a::MRP)            = dcm_to_crp(mrp_to_dcm(a))

# == Conversions to MRP ====================================================================

Base.convert(::Type{<:MRP}, a::DCM)            = dcm_to_mrp(a)
Base.convert(::Type{<:MRP}, a::Quaternion)     = quat_to_mrp(a)
Base.convert(::Type{<:MRP}, a::EulerAngles)    = angle_to_mrp(a)
Base.convert(::Type{<:MRP}, a::EulerAngleAxis) = dcm_to_mrp(angleaxis_to_dcm(a))
Base.convert(::Type{<:MRP}, a::CRP)            = dcm_to_mrp(crp_to_dcm(a))
