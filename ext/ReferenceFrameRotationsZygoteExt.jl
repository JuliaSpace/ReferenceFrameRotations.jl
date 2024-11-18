module ReferenceFrameRotationsZygoteExt

using ReferenceFrameRotations
using StaticArrays

using Zygote.ChainRulesCore: ChainRulesCore
import Zygote.ChainRulesCore: Tangent, NoTangent, ProjectTo

function ChainRulesCore.rrule(
    ::Type{<:DCM}, data::AbstractVector
)
    y = DCM(data)

    function DCM_pullback(Δ::AbstractMatrix)
        return (NoTangent(), Δ)
    end

    return y, DCM_pullback
end

function ChainRulesCore.rrule(::Type{<:DCM}, data::NTuple{9, T}) where {T}
    # Forward pass: construct the DCM from the data tuple
    project_data = ProjectTo(data)
    pullback(Δ) = (NoTangent(), project_data(vec(Δ)))

    return DCM(data), pullback
end

end