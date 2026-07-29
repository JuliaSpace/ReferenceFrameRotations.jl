## Description #############################################################################
#
# Julia API functions to implement conversions between representations.
#
############################################################################################

# Conversion to a concrete representation is deliberately performed in two steps: compute
# the representation using its natural scalar type, then cast its components.  Thus,
# requesting an integer representation has the usual `InexactError` semantics.

@inline _cast_rotation(::Type{DCM{T}}, D::DCM{T}) where {T} = D
@inline _cast_rotation(::Type{DCM{T}}, D::DCM) where {T} = _cast_dcm(DCM{T}, D)
@inline _cast_dcm(::Type{DCM{T}}, D::DCM) where {T} = DCM{T}(map(T, D.data))
@inline function _cast_rotation(::Type{EulerAngles{T}}, a::EulerAngles) where {T}
    return EulerAngles{T}(T(a.a1), T(a.a2), T(a.a3), a.rot_seq)
end
@inline function _cast_rotation(::Type{EulerAngleAxis{T}}, a::EulerAngleAxis) where {T}
    return EulerAngleAxis(T(a.a), SVector{3, T}(a.v))
end
@inline function _cast_rotation(::Type{Quaternion{T}}, q::Quaternion) where {T}
    return convert(Quaternion{T}, q)
end
@inline _cast_rotation(::Type{CRP{T}}, c::CRP) where {T} = convert(CRP{T}, c)
@inline _cast_rotation(::Type{MRP{T}}, m::MRP) where {T} = convert(MRP{T}, m)

# Preserve the original DCM when its elements are already floating point.  Besides avoiding
# an unnecessary reconstruction, this keeps the input visible to source-to-source AD tools.
@inline _float_dcm(dcm::DCM{T}) where {T} = _float_dcm(float(T), dcm)
@inline _float_dcm(::Type{T}, dcm::DCM{T}) where {T} = dcm
@inline _float_dcm(::Type{T}, dcm::DCM) where {T} = DCM{T}(Tuple(dcm))

# == Conversions to DCM ====================================================================

@inline _convert_to_dcm(D::DCM) = D
@inline _convert_to_dcm(a::EulerAngles) = angle_to_dcm(a)
@inline _convert_to_dcm(a::Quaternion) = quat_to_dcm(a)
@inline _convert_to_dcm(a::EulerAngleAxis) = angleaxis_to_dcm(a)
@inline _convert_to_dcm(a::CRP) = crp_to_dcm(a)
@inline _convert_to_dcm(a::MRP) = mrp_to_dcm(a)

"""
    convert(::Type{DCM}, a::ReferenceFrameRotation) -> DCM
    convert(::Type{DCM{T}}, a::ReferenceFrameRotation) where {T} -> DCM{T}

Convert rotation `a` to a direction cosine matrix, optionally converting its scalar type to
`T`.
"""
Base.convert(::Type{DCM}, a::ReferenceFrameRotation) = _convert_to_dcm(a)
function Base.convert(::Type{DCM{T}}, a::ReferenceFrameRotation) where {T}
    return _cast_rotation(DCM{T}, _convert_to_dcm(a))
end

# == Conversion to Euler Angles ============================================================

function Base.convert(::Type{<:EulerAngleConversion{R}}, a) where {R}
    return _convert_to_euler_angles(a, Val{R}())
end

# Keep the sequence in the dispatch domain.  In particular, do not pass the type parameter
# back as a Symbol before selecting the conversion implementation.
@inline _convert_to_euler_angles(a, ::Val{:XYX}) = dcm_to_angle(convert(DCM, a), :XYX)
@inline _convert_to_euler_angles(a, ::Val{:XYZ}) = dcm_to_angle(convert(DCM, a), :XYZ)
@inline _convert_to_euler_angles(a, ::Val{:XZX}) = dcm_to_angle(convert(DCM, a), :XZX)
@inline _convert_to_euler_angles(a, ::Val{:XZY}) = dcm_to_angle(convert(DCM, a), :XZY)
@inline _convert_to_euler_angles(a, ::Val{:YXY}) = dcm_to_angle(convert(DCM, a), :YXY)
@inline _convert_to_euler_angles(a, ::Val{:YXZ}) = dcm_to_angle(convert(DCM, a), :YXZ)
@inline _convert_to_euler_angles(a, ::Val{:YZX}) = dcm_to_angle(convert(DCM, a), :YZX)
@inline _convert_to_euler_angles(a, ::Val{:YZY}) = dcm_to_angle(convert(DCM, a), :YZY)
@inline _convert_to_euler_angles(a, ::Val{:ZXY}) = dcm_to_angle(convert(DCM, a), :ZXY)
@inline _convert_to_euler_angles(a, ::Val{:ZXZ}) = dcm_to_angle(convert(DCM, a), :ZXZ)
@inline _convert_to_euler_angles(a, ::Val{:ZYX}) = dcm_to_angle(convert(DCM, a), :ZYX)
@inline _convert_to_euler_angles(a, ::Val{:ZYZ}) = dcm_to_angle(convert(DCM, a), :ZYZ)

@noinline function _convert_to_euler_angles(a, ::Val{R}) where {R}
    throw(ArgumentError("The rotation sequence :$R is not valid."))
end

@inline _convert_to_euler_angles_default(a::DCM) = dcm_to_angle(a, :ZYX)
@inline _convert_to_euler_angles_default(a::EulerAngleAxis) = angleaxis_to_angle(a, :ZYX)
@inline _convert_to_euler_angles_default(a::Quaternion) = quat_to_angle(a, :ZYX)
@inline _convert_to_euler_angles_default(a::CRP) = crp_to_angle(a, :ZYX)
@inline _convert_to_euler_angles_default(a::MRP) = mrp_to_angle(a, :ZYX)

"""
    convert(::Type{EulerAngles}, a::EulerAngles) -> EulerAngles
    convert(::Type{EulerAngles}, a::ReferenceFrameRotation) -> EulerAngles
    convert(::Type{EulerAngles{T}}, a::EulerAngles) where {T} -> EulerAngles{T}
    convert(::Type{EulerAngles{T}}, a::ReferenceFrameRotation) where {T} -> EulerAngles{T}

Convert rotation `a` to Euler angles using the default `:ZYX` sequence, or preserve the
sequence when `a` is already an `EulerAngles` value.
"""
Base.convert(::Type{EulerAngles}, a::EulerAngles) = a
Base.convert(::Type{EulerAngles}, a::ReferenceFrameRotation) = _convert_to_euler_angles_default(
    a
)
function Base.convert(::Type{EulerAngles{T}}, a::EulerAngles) where {T}
    return _cast_rotation(EulerAngles{T}, a)
end
function Base.convert(::Type{EulerAngles{T}}, a::ReferenceFrameRotation) where {T}
    return _cast_rotation(EulerAngles{T}, _convert_to_euler_angles_default(a))
end

# == Conversions to Euler Angle and Axis ===================================================

@inline _convert_to_angleaxis(a::DCM) = dcm_to_angleaxis(a)
@inline _convert_to_angleaxis(a::EulerAngles) = angle_to_angleaxis(a)
@inline _convert_to_angleaxis(a::Quaternion) = quat_to_angleaxis(a)
@inline _convert_to_angleaxis(a::CRP) = crp_to_angleaxis(a)
@inline _convert_to_angleaxis(a::MRP) = mrp_to_angleaxis(a)

"""
    convert(::Type{EulerAngleAxis}, a::EulerAngleAxis) -> EulerAngleAxis
    convert(::Type{EulerAngleAxis}, a::ReferenceFrameRotation) -> EulerAngleAxis
    convert(::Type{EulerAngleAxis{T}}, a::EulerAngleAxis) where {T} -> EulerAngleAxis{T}
    convert(
        ::Type{EulerAngleAxis{T}},
        a::ReferenceFrameRotation
    ) -> EulerAngleAxis{T}

Convert rotation `a` to an Euler angle-axis representation.
"""
Base.convert(::Type{EulerAngleAxis}, a::EulerAngleAxis) = a
Base.convert(::Type{EulerAngleAxis}, a::ReferenceFrameRotation) = _convert_to_angleaxis(a)
function Base.convert(::Type{EulerAngleAxis{T}}, a::EulerAngleAxis) where {T}
    return _cast_rotation(EulerAngleAxis{T}, a)
end
function Base.convert(::Type{EulerAngleAxis{T}}, a::ReferenceFrameRotation) where {T}
    return _cast_rotation(EulerAngleAxis{T}, _convert_to_angleaxis(a))
end

# == Conversions to Quaternions ============================================================

@inline _convert_to_quaternion(a::DCM) = dcm_to_quat(a)
@inline _convert_to_quaternion(a::EulerAngles) = angle_to_quat(a)
@inline _convert_to_quaternion(a::EulerAngleAxis) = angleaxis_to_quat(a)
@inline _convert_to_quaternion(a::CRP) = crp_to_quat(a)
@inline _convert_to_quaternion(a::MRP) = mrp_to_quat(a)

"""
    convert(::Type{Quaternion}, q::Quaternion) -> Quaternion
    convert(::Type{Quaternion}, a::ReferenceFrameRotation) -> Quaternion
    convert(::Type{Quaternion{T}}, a::ReferenceFrameRotation) where {T} -> Quaternion{T}

Convert rotation `a` to a scalar-first quaternion, optionally converting its scalar type to
`T`.
"""
Base.convert(::Type{Quaternion}, q::Quaternion) = q
Base.convert(::Type{Quaternion}, a::ReferenceFrameRotation) = _convert_to_quaternion(a)
function Base.convert(::Type{Quaternion{T}}, a::ReferenceFrameRotation) where {T}
    return _cast_rotation(Quaternion{T}, _convert_to_quaternion(a))
end

# == Conversions to CRP ====================================================================

@inline _convert_to_crp(a::DCM) = dcm_to_crp(a)
@inline _convert_to_crp(a::Quaternion) = quat_to_crp(a)
@inline _convert_to_crp(a::EulerAngles) = angle_to_crp(a)
@inline _convert_to_crp(a::EulerAngleAxis) = angleaxis_to_crp(a)
@inline _convert_to_crp(a::MRP) = mrp_to_crp(a)

"""
    convert(::Type{CRP}, c::CRP) -> CRP
    convert(::Type{CRP}, a::ReferenceFrameRotation) -> CRP
    convert(::Type{CRP{T}}, a::ReferenceFrameRotation) where {T} -> CRP{T}

Convert rotation `a` to classical Rodrigues parameters, optionally changing its scalar type
to `T`.
"""
Base.convert(::Type{CRP}, c::CRP) = c
Base.convert(::Type{CRP}, a::ReferenceFrameRotation) = _convert_to_crp(a)
function Base.convert(::Type{CRP{T}}, a::ReferenceFrameRotation) where {T}
    return _cast_rotation(CRP{T}, _convert_to_crp(a))
end

# == Conversions to MRP ====================================================================

@inline _convert_to_mrp(a::DCM) = dcm_to_mrp(a)
@inline _convert_to_mrp(a::Quaternion) = quat_to_mrp(a)
@inline _convert_to_mrp(a::EulerAngles) = angle_to_mrp(a)
@inline _convert_to_mrp(a::EulerAngleAxis) = angleaxis_to_mrp(a)
@inline _convert_to_mrp(a::CRP) = crp_to_mrp(a)

"""
    convert(::Type{MRP}, m::MRP) -> MRP
    convert(::Type{MRP}, a::ReferenceFrameRotation) -> MRP
    convert(::Type{MRP{T}}, a::ReferenceFrameRotation) where {T} -> MRP{T}

Convert rotation `a` to modified Rodrigues parameters, optionally converting its scalar type
to `T`.
"""
Base.convert(::Type{MRP}, m::MRP) = m
Base.convert(::Type{MRP}, a::ReferenceFrameRotation) = _convert_to_mrp(a)
function Base.convert(::Type{MRP{T}}, a::ReferenceFrameRotation) where {T}
    return _cast_rotation(MRP{T}, _convert_to_mrp(a))
end
