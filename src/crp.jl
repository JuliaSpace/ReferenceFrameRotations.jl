## Description #############################################################################
#
# Functions related to the Classical Rodrigues Parameters (CRP).
#
############################################################################################

############################################################################################
#                                       Constructors                                       #
############################################################################################

"""
    CRP(v::AbstractVector)

Create a `CRP` from the vector `v`.
"""
function CRP(v::AbstractVector)
    # The vector must have 3 components.
    if length(v) != 3
        throw(ArgumentError("The input vector must have 3 components."))
    end

    return CRP(v[1], v[2], v[3])
end

CRP(I::UniformScaling) = CRP(0, 0, 0)

############################################################################################
#                                        Julia API                                         #
############################################################################################

# The following functions make sure that a CRP is an iterable object. This allows
# broadcasting without allocations.
Base.IndexStyle(::Type{<:CRP}) = IndexLinear()
Base.eltype(::Type{CRP{T}}) where T = T
Base.firstindex(c::CRP) = 1
Base.lastindex(c::CRP) = 3
Base.length(::CRP) = 3
Base.ndims(::Type{<:CRP}) = 1
Base.ndims(c::CRP) = 1
Base.size(::CRP) = (3,)
Base.Broadcast.broadcastable(c::CRP) = c

function Base.convert(::Type{CRP{T}}, c::CRP) where T
    return CRP{T}(c.q1, c.q2, c.q3)
end

@inline function Base.getindex(c::CRP, i::Int)
    if i == 1
        return c.q1
    elseif i == 2
        return c.q2
    elseif i == 3
        return c.q3
    else
        throw(BoundsError(c, i))
    end
end

@inline function Base.getindex(c::CRP{T}, ::Colon) where T
    return SVector{3, T}(c.q1, c.q2, c.q3)
end

@inline function Base.getindex(c::CRP, i::CartesianIndex{1})
    return getindex(c, first(i.I))
end

@inline function Base.iterate(c::CRP)
    return iterate(c, 0)
end

@inline function Base.iterate(c::CRP, state::Integer)
    state = state + 1

    if state == 1
        return (c.q1, state)
    elseif state == 2
        return (c.q2, state)
    elseif state == 3
        return (c.q3, state)
    else
        return nothing
    end
end

# We need to define `setindex!` with respect to vectors to allow operations such as:
#
#     v[4:6] = c
@inline function setindex!(v::Vector{T}, c::CRP, I::UnitRange) where T
    # We can use all the functions in static arrays.
    return setindex!(v, c[:], I)
end

@inline function Base.:(==)(c1::CRP, c2::CRP)
    return (c1.q1 == c2.q1) &&
           (c1.q2 == c2.q2) &&
           (c1.q3 == c2.q3)
end

@inline function Base.isapprox(c1::CRP, c2::CRP; kwargs...)
    return isapprox(c1.q1, c2.q1; kwargs...) &&
           isapprox(c1.q2, c2.q2; kwargs...) &&
           isapprox(c1.q3, c2.q3; kwargs...)
end

############################################################################################
#                                            IO                                            #
############################################################################################

function Base.show(io::IO, c::CRP{T}) where T
    # Check if the user wants compact printing, defaulting to `true`.
    compact_printing = get(io, :compact, true)::Bool

    print(io, "CRP{$(T)}: ")
    print(io, c.q1, ", ", c.q2, ", ", c.q3)

    return nothing
end

function Base.show(io::IO, mime::MIME"text/plain", c::CRP{T}) where T
    # Check if the user wants colors.
    color = get(io, :color, false)::Bool

    # Check if the user wants compact printing, defaulting to `true`.
    compact_printing = get(io, :compact, true)::Bool

    # Assemble the context.
    context = IOContext(io, :color => color, :compact => compact_printing)

    print(io, "CRP{$(T)}: ")
    print(context, c.q1, ", ", c.q2, ", ", c.q3)
end

############################################################################################
#                                        Operations                                        #
############################################################################################

# == Operation: + ==========================================================================

@inline +(c1::CRP, c2::CRP) = CRP(c1.q1 + c2.q1, c1.q2 + c2.q2, c1.q3 + c2.q3)

# == Operation: - ==========================================================================

@inline -(c::CRP) = CRP(-c.q1, -c.q2, -c.q3)
@inline -(c1::CRP, c2::CRP) = CRP(c1.q1 - c2.q1, c1.q2 - c2.q2, c1.q3 - c2.q3)

# == Operation: * ==========================================================================

@inline *(λ::Number, c::CRP) = CRP(λ * c.q1, λ * c.q2, λ * c.q3)
@inline *(c::CRP, λ::Number) = CRP(c.q1 * λ, c.q2 * λ, c.q3 * λ)

"""
    *(c1::CRP, c2::CRP) -> CRP

Compute the composition of two CRPs `c1` and `c2`.

    C3 = C2 * C1

which means that `C3` acts as `C1` followed by `C2`.
"""
function Base.:*(c1::CRP, c2::CRP)
    norm_c1_c2 = c1.q1 * c2.q1 + c1.q2 * c2.q2 + c1.q3 * c2.q3

    if isapprox(norm_c1_c2, 1; atol = 1e-15)
        # TODO: Return a specific error?
        throw(ArgumentError("The composition of these CRPs results in a specific singularity (180 degrees rotation)."))
    end

    denom = 1 - norm_c1_c2
    
    return CRP(
        (c1.q1 + c2.q1 - c1.q2 * c2.q3 + c1.q3 * c2.q2) / denom,
        (c1.q2 + c2.q2 - c1.q3 * c2.q1 + c1.q1 * c2.q3) / denom,
        (c1.q3 + c2.q3 - c1.q1 * c2.q2 + c1.q2 * c2.q1) / denom
    )
end

# == Operation: / ==========================================================================

@inline /(c::CRP, λ::Number) = CRP(c.q1 / λ, c.q2 / λ, c.q3 / λ)
@inline /(c1::CRP, c2::CRP) = c1 * inv(c2)

# == Operation: \ ==========================================================================

@inline \(c1::CRP, c2::CRP) = inv(c1) * c2

############################################################################################
#                                        Functions                                         #
############################################################################################

"""
    inv(c::CRP) -> CRP

Compute the inverse of the CRP `c`.
"""
@inline inv(c::CRP) = -c

"""
    norm(c::CRP) -> Number

Compute the Euclidean norm of the CRP `c`.
"""
@inline norm(c::CRP) = √(c.q1^2 + c.q2^2 + c.q3^2)

@inline one(::Type{CRP{T}}) where T = CRP{T}(T(0), T(0), T(0))
@inline one(::Type{CRP}) = CRP{Float64}(0, 0, 0)
@inline one(c::CRP{T}) where T = one(CRP{T})

@inline zero(::Type{CRP{T}}) where T = CRP{T}(T(0), T(0), T(0))
@inline zero(::Type{CRP}) = CRP{Float64}(0, 0, 0)
@inline zero(c::CRP{T}) where T = zero(CRP{T})
