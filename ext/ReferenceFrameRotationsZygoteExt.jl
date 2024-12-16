module ReferenceFrameRotationsZygoteExt

using ReferenceFrameRotations
using StaticArrays

using Zygote.ChainRulesCore: ChainRulesCore
import Zygote.ChainRulesCore: Tangent, NoTangent, ProjectTo

function ChainRulesCore.rrule(
    ::Type{<:DCM}, data::NTuple{9, T} where {T}
)
    y = DCM(data)

    function DCM_pullback(Δ::AbstractMatrix)
        return (NoTangent(), Tuple(Δ))
    end

    return y, DCM_pullback
end

function ChainRulesCore.rrule(
    ::Type{<:DCM}, data::T where {T<:AbstractArray}
)
    y = DCM(data)

    function DCM_pullback(Δ::DCM)
        return (NoTangent(), T(Δ))
    end

    return y, DCM_pullback
end


end