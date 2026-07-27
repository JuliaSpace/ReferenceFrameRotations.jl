## Description #############################################################################
#
# Functions to sample random representations of rotations.
#
## References ##############################################################################
#
# [1] K. Shoemake. Uniform random rotations. In D. Kirk, editor, Graphics Gems III, pages
#     124-132. Academic, New York, 1992.
#
############################################################################################

# == Euler angle and axis ==================================================================

"""
    rand(
        rng::AbstractRNG,
        ::Random.SamplerType{R}
    ) where {R <: EulerAngleAxis} -> R

Sample a uniformly distributed random Euler angle-axis rotation using `rng`.
"""
function Random.rand(rng::AbstractRNG, ::Random.SamplerType{R}) where {R <: EulerAngleAxis}
    T = eltype(R)
    if T == Any
        T = Float64
    end

    return quat_to_angleaxis(_rand_quat(rng, T))
end

# == Euler angles ==========================================================================

"""
    rand(
        rng::AbstractRNG,
        ::Random.SamplerType{R}
    ) where {R <: EulerAngles} -> R

Sample a random Euler-angle representation using `rng`.
"""
function Random.rand(rng::AbstractRNG, ::Random.SamplerType{R}) where {R <: EulerAngles}
    T = eltype(R)
    if T == Any
        T = Float64
    end

    k  = 2 * T(π)
    a₁ = k * rand(rng, T)
    a₂ = k * rand(rng, T)
    a₃ = k * rand(rng, T)

    rot_seq = rand(
        rng, (:XYX, :XYZ, :XZX, :XZY, :YXY, :YXZ, :YZX, :YZY, :ZXY, :ZXZ, :ZYX, :ZYZ)
    )

    return EulerAngles{T}(a₁, a₂, a₃, rot_seq)
end

# == DCM ===================================================================================

"""
    rand(
        rng::AbstractRNG,
        ::Random.SamplerType{R}
    ) where {R <: DCM} -> R

Sample a uniformly distributed random rotation as a DCM using `rng`.
"""
function Random.rand(rng::AbstractRNG, ::Random.SamplerType{R}) where {R <: DCM}
    T = eltype(R)
    if T == Any
        T = Float64
    end

    return quat_to_dcm(_rand_quat(rng, T))
end

# == Quaternion ============================================================================

"""
    rand(
        rng::AbstractRNG,
        ::Random.SamplerType{R}
    ) where {R <: Quaternion} -> R

Sample a uniformly distributed random unit quaternion using `rng`.
"""
function Random.rand(rng::AbstractRNG, ::Random.SamplerType{R}) where {R <: Quaternion}
    T = eltype(R)
    if T == Any
        T = Float64
    end

    return _rand_quat(rng, T)
end

# == CRP ===================================================================================

"""
    rand(
        rng::AbstractRNG,
        ::Random.SamplerType{R}
    ) where {R <: CRP} -> R

Sample a random CRP rotation using `rng`.
"""
function Random.rand(rng::AbstractRNG, ::Random.SamplerType{R}) where {R <: CRP}
    T = eltype(R)
    if T == Any
        T = Float64
    end

    return quat_to_crp(_rand_quat(rng, T))
end

# == MRP ===================================================================================

"""
    rand(
        rng::AbstractRNG,
        ::Random.SamplerType{R}
    ) where {R <: MRP} -> R

Sample a random MRP rotation using `rng`.
"""
function Random.rand(rng::AbstractRNG, ::Random.SamplerType{R}) where {R <: MRP}
    T = eltype(R)
    if T == Any
        T = Float64
    end

    return quat_to_mrp(_rand_quat(rng, T))
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

@inline function _rand_quat(rng::AbstractRNG, T::DataType)
    # A random unit quaternion is sampled using the algorithm in [1].
    k = 2T(π)

    u₁ = rand(rng, T)
    u₂ = k * rand(rng, T)
    u₃ = k * rand(rng, T)

    sin_u₂, cos_u₂ = sincos(u₂)
    sin_u₃, cos_u₃ = sincos(u₃)

    v₁ = √(1 - u₁)
    v₂ = √u₁

    q = Quaternion(v₁ * sin_u₂, v₁ * cos_u₂, v₂ * sin_u₃, v₂ * cos_u₃)

    return q
end
