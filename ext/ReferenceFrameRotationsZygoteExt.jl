module ReferenceFrameRotationsZygoteExt

using ReferenceFrameRotations

using Zygote.ChainRulesCore: ChainRulesCore
import Zygote.ChainRulesCore: Tangent, NoTangent, ProjectTo

function ChainRulesCore.rrule(
    ::Type{<:DCM}, data::AbstractVector
)
    # Forward evaluation (Keplerian transformation)
    y = DCM(data)

    function DCM_pullback(Δ::AbstractMatrix)
        return (NoTangent(), Δ)
    end

    return y, DCM_pullback
end

end