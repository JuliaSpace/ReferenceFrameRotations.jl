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
    ::Type{<:DCM}, data::SMatrix{3,3,T}
) where {T}

    y = DCM(data)

    function DCM_pullback(Δ)
        return (NoTangent(), SMatrix{3,3,T}(Δ))
    end

    return y, DCM_pullback
end

function ChainRulesCore.rrule(
    ::Type{<:DCM}, data::MMatrix{3,3,T}
) where {T}

    y = DCM(data)

    function DCM_pullback(Δ)
        return (NoTangent(), MMatrix{3,3,T}(Δ))
    end

    return y, DCM_pullback
end

function ChainRulesCore.rrule(
    ::Type{<:DCM}, data::Matrix{3,3,T}
) where {T}

    y = DCM(data)

    function DCM_pullback(Δ)
        return (NoTangent(), Matrix(Δ))
    end

    return y, DCM_pullback
end


end