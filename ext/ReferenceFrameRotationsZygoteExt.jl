module ReferenceFrameRotationsZygoteExt

using ReferenceFrameRotations
using StaticArrays

using Zygote.ChainRulesCore: ChainRulesCore
import Zygote.ChainRulesCore: Tangent, NoTangent, ProjectTo

function ChainRulesCore.rrule(
    ::Type{<:DCM}, data::NTuple{9, T} 
) where {T}

    y = DCM(data)

    function DCM_pullback(Δ)
        return (NoTangent(), Tuple(Δ))
    end

    return y, DCM_pullback
end

function ChainRulesCore.rrule(
    ::Type{DCM}, mat::AbstractMatrix{T}
) where {T}

    y = DCM(mat)

    function pullback(Δ)
        return (NoTangent(), Δ)
    end

    return y, pullback
end

end