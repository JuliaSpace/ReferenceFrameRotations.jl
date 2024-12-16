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

"""
Convert Δ back to the same type as the primal input matrix.
This is a helper function.
"""
function restore_type(primal::AbstractMatrix{T}, Δ::DCM{T}) where {T}
    # If the primal was a plain Matrix:
    if primal isa Matrix
        return Matrix(Δ)
    end
    # If the primal was an SMatrix:
    if primal isa SMatrix{3,3,T}
        return SMatrix{3,3,T}(Δ)
    end
    # If the primal was an MMatrix:
    if primal isa MMatrix{3,3,T}
        return MMatrix{3,3,T}(Δ)
    end
    # Fallback: just return a Matrix
    return Matrix(Δ)
end

function ChainRulesCore.rrule(
    ::Type{<:DCM}, data::T
) where {T <: AbstractMatrix}

    y = DCM(SMatrix{3, 3}(data))

    function DCM_pullback(Δ)
        return (NoTangent(), T(Δ))
    end

    return y, DCM_pullback
end


end