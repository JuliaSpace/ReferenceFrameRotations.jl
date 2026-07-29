## Description #############################################################################
#
# Zygote extension for ReferenceFrameRotations.jl.
#
############################################################################################

module ReferenceFrameRotationsZygoteExt

using LinearAlgebra: dot, norm
using ReferenceFrameRotations
using StaticArrays: SVector

using Zygote.ChainRulesCore: ChainRulesCore
import Zygote.ChainRulesCore: AbstractZero, NoTangent, unthunk

function ChainRulesCore.rrule(::Type{<:DCM}, data::NTuple{9, T}) where {T}
    y = DCM(data)

    function DCM_pullback(Δ)
        Δ_unthunked = unthunk(Δ)
        if Δ_unthunked isa AbstractZero
            return (NoTangent(), Δ_unthunked)
        end
        return (NoTangent(), Tuple(Δ_unthunked))
    end

    return y, DCM_pullback
end

# Converting between floating-point types is opaque to Zygote.  Scope the rule to the helper
# used only by cross-type concrete DCM casts; same-type casts bypass this function entirely.
function ChainRulesCore.rrule(
    ::typeof(ReferenceFrameRotations._cast_dcm), ::Type{DCM{T}}, dcm::DCM{S}
) where {T <: AbstractFloat, S <: AbstractFloat}
    y = ReferenceFrameRotations._cast_dcm(DCM{T}, dcm)

    function cast_dcm_pullback(Δ)
        Δ_unthunked = unthunk(Δ)
        if Δ_unthunked isa AbstractZero
            return NoTangent(), NoTangent(), Δ_unthunked
        end
        return NoTangent(), NoTangent(), DCM{S}(map(S, Tuple(Δ_unthunked)))
    end

    return y, cast_dcm_pullback
end

function ChainRulesCore.rrule(
    ::typeof(orthonormalize), dcm::DCM{T}
) where {T <: AbstractFloat}
    y = orthonormalize(dcm)

    e₁ = SVector{3, T}(dcm[1, 1], dcm[2, 1], dcm[3, 1])
    e₂ = SVector{3, T}(dcm[1, 2], dcm[2, 2], dcm[3, 2])
    e₃ = SVector{3, T}(dcm[1, 3], dcm[2, 3], dcm[3, 3])

    n₁ = norm(e₁)
    u₁ = e₁ / n₁
    p₂ = e₂ - u₁ * dot(u₁, e₂)
    n₂ = norm(p₂)
    u₂ = p₂ / n₂
    p₃₁ = e₃ - u₁ * dot(u₁, e₃)
    p₃ = p₃₁ - u₂ * dot(u₂, p₃₁)
    n₃ = norm(p₃)
    u₃ = p₃ / n₃

    function orthonormalize_pullback(Δ)
        Δ_unthunked = unthunk(Δ)
        if Δ_unthunked isa AbstractZero
            return NoTangent(), Δ_unthunked
        end

        ū₁ = SVector{3, T}(Δ_unthunked[1, 1], Δ_unthunked[2, 1], Δ_unthunked[3, 1])
        ū₂ = SVector{3, T}(Δ_unthunked[1, 2], Δ_unthunked[2, 2], Δ_unthunked[3, 2])
        ū₃ = SVector{3, T}(Δ_unthunked[1, 3], Δ_unthunked[2, 3], Δ_unthunked[3, 3])

        # Reverse the normalizations and orthogonal projections in exact forward order.
        p̄₃ = (ū₃ - u₃ * dot(u₃, ū₃)) / n₃
        p̄₃₁ = p̄₃ - u₂ * dot(u₂, p̄₃)
        ū₂ += -dot(u₂, p₃₁) * p̄₃ - p₃₁ * dot(u₂, p̄₃)

        ē₃ = p̄₃₁ - u₁ * dot(u₁, p̄₃₁)
        ū₁ += -dot(u₁, e₃) * p̄₃₁ - e₃ * dot(u₁, p̄₃₁)

        p̄₂ = (ū₂ - u₂ * dot(u₂, ū₂)) / n₂
        ē₂ = p̄₂ - u₁ * dot(u₁, p̄₂)
        ū₁ += -dot(u₁, e₂) * p̄₂ - e₂ * dot(u₁, p̄₂)

        ē₁ = (ū₁ - u₁ * dot(u₁, ū₁)) / n₁
        dcm_bar = DCM((ē₁..., ē₂..., ē₃...))
        return NoTangent(), dcm_bar
    end

    return y, orthonormalize_pullback
end

end
