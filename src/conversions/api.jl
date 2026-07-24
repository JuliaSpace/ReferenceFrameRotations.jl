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

function Base.convert(::Type{<:_EulerAngleConversion{R}}, a) where R
    return _convert_to_euler_angles(a, Val{R}())
end

# Keep the sequence in the dispatch domain.  In particular, do not pass the type parameter
# back as a Symbol before selecting the conversion implementation.
@inline _convert_to_euler_angles(a, ::Val{:XYX}) =
    dcm_to_angle(convert(DCM, a), :XYX)
@inline _convert_to_euler_angles(a, ::Val{:XYZ}) =
    dcm_to_angle(convert(DCM, a), :XYZ)
@inline _convert_to_euler_angles(a, ::Val{:XZX}) =
    dcm_to_angle(convert(DCM, a), :XZX)
@inline _convert_to_euler_angles(a, ::Val{:XZY}) =
    dcm_to_angle(convert(DCM, a), :XZY)
@inline _convert_to_euler_angles(a, ::Val{:YXY}) =
    dcm_to_angle(convert(DCM, a), :YXY)
@inline _convert_to_euler_angles(a, ::Val{:YXZ}) =
    dcm_to_angle(convert(DCM, a), :YXZ)
@inline _convert_to_euler_angles(a, ::Val{:YZX}) =
    dcm_to_angle(convert(DCM, a), :YZX)
@inline _convert_to_euler_angles(a, ::Val{:YZY}) =
    dcm_to_angle(convert(DCM, a), :YZY)
@inline _convert_to_euler_angles(a, ::Val{:ZXY}) =
    dcm_to_angle(convert(DCM, a), :ZXY)
@inline _convert_to_euler_angles(a, ::Val{:ZXZ}) =
    dcm_to_angle(convert(DCM, a), :ZXZ)
@inline _convert_to_euler_angles(a, ::Val{:ZYX}) =
    dcm_to_angle(convert(DCM, a), :ZYX)
@inline _convert_to_euler_angles(a, ::Val{:ZYZ}) =
    dcm_to_angle(convert(DCM, a), :ZYZ)

@noinline function _convert_to_euler_angles(a, ::Val{R}) where R
    throw(ArgumentError("The rotation sequence :$R is not valid."))
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
