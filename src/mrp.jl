## Description #############################################################################
#
# Functions related to the Modified Rodrigues Parameters (MRP).
#
############################################################################################

############################################################################################
#                                       Constructors                                       #
############################################################################################

"""
    MRP(v::AbstractVector)

Create a `MRP` from the vector `v`.
"""
function MRP(v::AbstractVector)
    # The vector must have 3 components.
    if length(v) != 3
        throw(ArgumentError("The input vector must have 3 components."))
    end

    return MRP(v[1], v[2], v[3])
end

MRP(I::UniformScaling) = MRP(0, 0, 0)

############################################################################################
#                                        Julia API                                         #
############################################################################################

# The following functions make sure that a MRP is an iterable object. This allows
# broadcasting without allocations.
Base.IndexStyle(::Type{<:MRP}) = IndexLinear()
Base.eltype(::Type{MRP{T}}) where T = T
Base.firstindex(m::MRP) = 1
Base.lastindex(m::MRP) = 3
Base.length(::MRP) = 3
Base.ndims(::Type{<:MRP}) = 1
Base.ndims(m::MRP) = 1
Base.size(::MRP) = (3,)
Base.Broadcast.broadcastable(m::MRP) = m

function Base.convert(::Type{MRP{T}}, m::MRP) where T
    return MRP{T}(m.q1, m.q2, m.q3)
end

@inline function Base.getindex(m::MRP, i::Int)
    if i == 1
        return m.q1
    elseif i == 2
        return m.q2
    elseif i == 3
        return m.q3
    else
        throw(BoundsError(m, i))
    end
end

@inline function Base.getindex(m::MRP{T}, ::Colon) where T
    return SVector{3, T}(m.q1, m.q2, m.q3)
end

@inline function Base.getindex(m::MRP, i::CartesianIndex{1})
    return getindex(m, first(i.I))
end

@inline function Base.iterate(m::MRP)
    return iterate(m, 0)
end

@inline function Base.iterate(m::MRP, state::Integer)
    state = state + 1

    if state == 1
        return (m.q1, state)
    elseif state == 2
        return (m.q2, state)
    elseif state == 3
        return (m.q3, state)
    else
        return nothing
    end
end

# We need to define `setindex!` with respect to vectors to allow operations such as:
#
#     v[4:6] = m
@inline function setindex!(v::Vector{T}, m::MRP, I::UnitRange) where T
    # We can use all the functions in static arrays.
    return setindex!(v, m[:], I)
end

@inline function Base.:(==)(m1::MRP, m2::MRP)
    return (m1.q1 == m2.q1) &&
           (m1.q2 == m2.q2) &&
           (m1.q3 == m2.q3)
end

@inline function Base.isapprox(m1::MRP, m2::MRP; kwargs...)
    return isapprox(m1.q1, m2.q1; kwargs...) &&
           isapprox(m1.q2, m2.q2; kwargs...) &&
           isapprox(m1.q3, m2.q3; kwargs...)
end

############################################################################################
#                                            IO                                            #
############################################################################################

function Base.show(io::IO, m::MRP{T}) where T
    # Check if the user wants compact printing, defaulting to `true`.
    compact_printing = get(io, :compact, true)::Bool

    print(io, "MRP{$(T)}: ")
    print(io, m.q1, ", ", m.q2, ", ", m.q3)

    return nothing
end

function Base.show(io::IO, mime::MIME"text/plain", m::MRP{T}) where T
    # Check if the user wants colors.
    color = get(io, :color, false)::Bool

    # Check if the user wants compact printing, defaulting to `true`.
    compact_printing = get(io, :compact, true)::Bool

    # Assemble the context.
    context = IOContext(io, :color => color, :compact => compact_printing)

    print(io, "MRP{$(T)}: ")
    print(io, m.q1, ", ", m.q2, ", ", m.q3)
end

############################################################################################
#                                        Operations                                        #
############################################################################################

# == Operation: + ==========================================================================

@inline +(m1::MRP, m2::MRP) = MRP(m1.q1 + m2.q1, m1.q2 + m2.q2, m1.q3 + m2.q3)

# == Operation: - ==========================================================================

@inline -(m::MRP) = MRP(-m.q1, -m.q2, -m.q3)
@inline -(m1::MRP, m2::MRP) = MRP(m1.q1 - m2.q1, m1.q2 - m2.q2, m1.q3 - m2.q3)

# == Operation: * ==========================================================================

@inline *(λ::Number, m::MRP) = MRP(λ * m.q1, λ * m.q2, λ * m.q3)
@inline *(m::MRP, λ::Number) = MRP(m.q1 * λ, m.q2 * λ, m.q3 * λ)

"""
    *(m1::MRP, m2::MRP) -> MRP

Compute the composition of two MRPs `m1` and `m2`.

    M3 = M2 * M1

which means that `M3` acts as `M1` followed by `M2`.
"""
function Base.:*(m1::MRP, m2::MRP)
    # Direct formula for MRP composition (Attitude Addition).
    # [FN(m)] = [FB(m2)][BN(m1)]
    # m = ((1 - |m1|^2)m2 + (1 - |m2|^2)m1 - 2(m2 x m1)) / (1 + |m1|^2|m2|^2 - 2(m1 . m2))

    s1_sq = m1.q1^2 + m1.q2^2 + m1.q3^2
    s2_sq = m2.q1^2 + m2.q2^2 + m2.q3^2
    
    dot_prod = m1.q1 * m2.q1 + m1.q2 * m2.q2 + m1.q3 * m2.q3
    
    denom = 1 + s1_sq * s2_sq - 2 * dot_prod
    
    # Using cross product inline for performance
    cross_1 = m2.q2 * m1.q3 - m2.q3 * m1.q2
    cross_2 = m2.q3 * m1.q1 - m2.q1 * m1.q3
    cross_3 = m2.q1 * m1.q2 - m2.q2 * m1.q1
    
    term1_fac = 1 - s1_sq
    term2_fac = 1 - s2_sq
    
    q1 = (term1_fac * m2.q1 + term2_fac * m1.q1 + 2 * cross_1) / denom
    q2 = (term1_fac * m2.q2 + term2_fac * m1.q2 + 2 * cross_2) / denom
    q3 = (term1_fac * m2.q3 + term2_fac * m1.q3 + 2 * cross_3) / denom
    
    return MRP(q1, q2, q3)
end

# == Operation: / ==========================================================================

@inline /(m::MRP, λ::Number) = MRP(m.q1 / λ, m.q2 / λ, m.q3 / λ)
@inline /(m1::MRP, m2::MRP) = m1 * inv(m2)

# == Operation: \ ==========================================================================

@inline \(m1::MRP, m2::MRP) = inv(m1) * m2

############################################################################################
#                                        Functions                                         #
############################################################################################

"""
    inv(m::MRP) -> MRP

Compute the inverse of the MRP `m`.
"""
@inline inv(m::MRP) = -m

"""
    norm(m::MRP) -> Number

Compute the Euclidean norm of the MRP `m`.
"""
@inline norm(m::MRP) = √(m.q1^2 + m.q2^2 + m.q3^2)

@inline one(::Type{MRP{T}}) where T = MRP{T}(T(0), T(0), T(0))
@inline one(::Type{MRP}) = MRP{Float64}(0, 0, 0)
@inline one(m::MRP{T}) where T = one(MRP{T})

@inline zero(::Type{MRP{T}}) where T = MRP{T}(T(0), T(0), T(0))
@inline zero(::Type{MRP}) = MRP{Float64}(0, 0, 0)
@inline zero(m::MRP{T}) where T = zero(MRP{T})
