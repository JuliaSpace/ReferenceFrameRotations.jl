## Description #############################################################################
#
# Zygote extension for ReferenceFrameRotations.jl.
#
############################################################################################

module ReferenceFrameRotationsZygoteExt

using ReferenceFrameRotations
using ForwardDiff

using Zygote.ChainRulesCore: ChainRulesCore
import Zygote.ChainRulesCore: NoTangent, unthunk

function ChainRulesCore.rrule(::Type{<:DCM}, data::NTuple{9, T}) where {T}
    y = DCM(data)

    function DCM_pullback(Δ)
        Δ_unthunked = unthunk(Δ)
        return (NoTangent(), Tuple(Δ_unthunked))
    end

    return y, DCM_pullback
end

function ChainRulesCore.rrule(::typeof(orthonormalize), dcm::DCM)
    y = orthonormalize(dcm)

    function orthonormalize_pullback(Δ)
        Δ_unthunked = unthunk(Δ)
        jac = ForwardDiff.jacobian(orthonormalize, dcm)
        return (NoTangent(), reshape(vcat(Δ_unthunked...)' * jac, 3, 3))
    end

    return y, orthonormalize_pullback
end

end
