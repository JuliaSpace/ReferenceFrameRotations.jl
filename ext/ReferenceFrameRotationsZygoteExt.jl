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

function ChainRulesCore.rrule(::Type{DCM{T}}, data::SMatrix{3, 3, T}) where {T}
    # Construct the DCM from an SMatrix
    y = DCM(data)

    function DCM_pullback(Δ)
        # Δ could be DCM, SMatrix, MMatrix, or plain Matrix.
        # Convert to a Matrix to avoid any reconstruction of DCM.
        return (NoTangent(), Δ)
    end
    return y, DCM_pullback
end


function ChainRulesCore.rrule(::Type{DCM{T}}, data::MMatrix{3, 3, T}) where {T}
    # Construct the DCM from an SMatrix
    y = DCM(data)

    function DCM_pullback(Δ)
        # Δ could be DCM, SMatrix, MMatrix, or plain Matrix.
        # Convert to a Matrix to avoid any reconstruction of DCM.
        return (NoTangent(), Δ)
    end
    return y, DCM_pullback
end

function ChainRulesCore.rrule(::Type{DCM{T}}, data::Matrix{T}) where {T}
    # Construct the DCM from an SMatrix
    y = DCM(data)

    function DCM_pullback(Δ)
        # Δ could be DCM, SMatrix, MMatrix, or plain Matrix.
        # Convert to a Matrix to avoid any reconstruction of DCM.
        return (NoTangent(), Δ)
    end
    return y, DCM_pullback
end

end