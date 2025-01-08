module ReferenceFrameRotationsZygoteExt

using ReferenceFrameRotations
using ForwardDiff

using Zygote.ChainRulesCore: ChainRulesCore
import Zygote.ChainRulesCore: NoTangent

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
    ::typeof(orthonormalize), dcm::DCM
)

    y = orthonormalize(dcm)

    function orthonormalize_pullback(Δ)
        
        jac = ForwardDiff.jacobian(orthonormalize, dcm)

        return (NoTangent(), vcat(Δ...)' * jac)
    end

    return y, orthonormalize_pullback
end

end