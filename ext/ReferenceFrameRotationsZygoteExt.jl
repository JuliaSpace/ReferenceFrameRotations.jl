## Description #############################################################################
#
# Zygote extension for ReferenceFrameRotations.jl.
#
############################################################################################

module ReferenceFrameRotationsZygoteExt

using ReferenceFrameRotations
using ForwardDiff

using Zygote.ChainRulesCore: ChainRulesCore
import Zygote.ChainRulesCore: AbstractZero, NoTangent, unthunk

function ChainRulesCore.rrule(::Type{<:DCM}, data::NTuple{9, T}) where {T}
    y = DCM(data)

    function DCM_pullback(Δ)
        Δ_unthunked = unthunk(Δ)
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
