module ReferenceFrameRotationsZygoteExt

using ReferenceFrameRotations
using StaticArrays

using Zygote.ChainRulesCore: ChainRulesCore
import Zygote.ChainRulesCore: Tangent, NoTangent, ProjectTo

function ChainRulesCore.rrule(
    ::Type{<:DCM}, data::NTuple{9, T} 
) where {T}
    y = DCM(data)

    function DCM_pullback(Δ::MMatrix{3, 3, T})
        return (NoTangent(), Tuple(Δ))
    end

    function DCM_pullback(Δ::SMatrix{3, 3, T})
        return (NoTangent(), Tuple(Δ))
    end

    function DCM_pullback(Δ::Matrix{T})
        return (NoTangent(), Tuple(Δ))
    end

    return y, DCM_pullback
end

end