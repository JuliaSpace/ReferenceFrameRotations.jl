## Description #############################################################################
#
# Functions related to the Classical Rodrigues Parameters (CRP).
#
## References ##############################################################################
#
# [1] Schaub, H.; Junkins, J. L (1996). Stereographic Orientation Parameters for Attitude
#     Dynamics: A Generalization of the Rodrigues Parameters. In: Journal of the
#     Astronautical Sciences, Vol. 44, No. 1, pp. 1 -- 19.
#
############################################################################################

export dcrp

############################################################################################
#                                       Constructors                                       #
############################################################################################

"""
    CRP(v::AbstractVector)

Create a `CRP` from the vector `v`.
"""
function CRP(v::AbstractVector)
    # The vector must have 3 components.
    length(v) != 3 && throw(ArgumentError("The input vector must have 3 components."))

    return CRP(v[begin], v[begin + 1], v[begin + 2])
end

CRP(::UniformScaling{T}) where T = CRP(zero(T), zero(T), zero(T))

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
    return (c1.q1 == c2.q1) && (c1.q2 == c2.q2) && (c1.q3 == c2.q3)
end

@inline function Base.isapprox(c1::CRP, c2::CRP; kwargs...)
    return isapprox(c1.q1, c2.q1; kwargs...) &&
           isapprox(c1.q2, c2.q2; kwargs...) &&
           isapprox(c1.q3, c2.q3; kwargs...)
end

############################################################################################
#                                        Kinematics                                        #
############################################################################################

"""
    dcrp(c::CRP, wba_b::AbstractVector) -> CRP

Compute the time-derivative of the CRP `c` that rotates a reference frame `a` into alignment
with the reference frame `b` in which the angular velocity of `b` with respect to `a`, and
represented in `b`, is `wba_b` **[1]**.

# Example

```julia-repl
julia> c = CRP(0.0, 0.0, 0.0)
CRP{Float64}:
  X : + 0.0
  Y : + 0.0
  Z : + 0.0

julia> dcrp(c, [1.0, 0.0, 0.0])
CRP{Float64}:
  X : + 0.5
  Y : + 0.0
  Z : + 0.0
```

# References

- **[1]** Schaub, H.; Junkins, J. L (1996). *Stereographic Orientation Parameters for
    Attitude Dynamics: A Generalization of the Rodrigues Parameters*. In: **Journal of the
    Astronautical Sciences**, Vol. 44, No. 1, pp. 1 -- 19.
"""
function dcrp(c::CRP, wba_b::AbstractVector)
    # Check the dimensions.
    length(wba_b) != 3 &&
        throw(ArgumentError("The angular velocity vector must have three components."))

    # Auxiliary variables.
    w₁ = wba_b[begin]
    w₂ = wba_b[begin + 1]
    w₃ = wba_b[begin + 2]

    # Equation [1]:
    #
    #     dcrp    w + c × w + (c ⋅ w) c
    #     ──── = ───────────────────────
    #      dt              2

    k₂_₁    = c.q2 * w₃ - c.q3 * w₂
    k₂_₂    = c.q3 * w₁ - c.q1 * w₃
    k₂_₃    = c.q1 * w₂ - c.q2 * w₁
    c_dot_w = c.q1 * w₁ + c.q2 * w₂ + c.q3 * w₃

    return CRP(
        (w₁ + k₂_₁ + c_dot_w * c.q1) / 2,
        (w₂ + k₂_₂ + c_dot_w * c.q2) / 2,
        (w₃ + k₂_₃ + c_dot_w * c.q3) / 2
    )
end

############################################################################################
#                                            IO                                            #
############################################################################################

function show(io::IO, c::CRP{T}) where T
    # Check if the user wants compact printing, defaulting to `true`.
    compact_printing = get(io, :compact, true)::Bool

    # Get the absolute values using `print`.
    c₀ = sprint(print, abs(c.q1), context = :compact => compact_printing)
    c₁ = sprint(print, abs(c.q2), context = :compact => compact_printing)
    c₂ = sprint(print, abs(c.q3), context = :compact => compact_printing)

    print(io, "CRP{$(T)}: ")
    print(io, "[", c₀, ", ", c₁, ", ", c₂, "]")

    return nothing
end

function show(io::IO, ::MIME"text/plain", c::CRP{T}) where T
    # Check if the user wants colors.
    color = get(io, :color, false)::Bool

    # Check if the user wants compact printing, defaulting to `true`.
    compact_printing = get(io, :compact, true)::Bool

    # Assemble the context.
    context = IOContext(io, :color => color, :compact => compact_printing)

    b = color ? string(_b) : ""
    d = color ? string(_d) : ""

    # Check if the user wants compact printing, defaulting to `true`.
    compact_printing = get(io, :compact, true)::Bool

    # Get the absolute values using `print`.
    ac₁ = sprint(print, abs(c.q1), context = context)
    ac₂ = sprint(print, abs(c.q2), context = context)
    ac₃ = sprint(print, abs(c.q3), context = context)

    # Get the signs.
    sc₁ = signbit(c.q1) ? "-" : "+"
    sc₂ = signbit(c.q2) ? "-" : "+"
    sc₃ = signbit(c.q3) ? "-" : "+"

    # Assemble the context.
    println(io, "CRP{$(T)}:")
    println(io, "  ", b, "X : ", d, sc₁, " ", ac₁)
    println(io, "  ", b, "Y : ", d, sc₂, " ", ac₂)
    print(  io, "  ", b, "Z : ", d, sc₃, " ", ac₃)

    return nothing
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

    # TODO: Return a specific error?
    isapprox(norm_c1_c2, 1; atol = 1e-15) && throw(
        ArgumentError("The composition of these CRPs results in a specific singularity (180° rotation).")
    )

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
@inline zero(::CRP{T}) where T = zero(CRP{T})

"""
    copy(c::CRP) -> CRP

Create a copy of the CRP `c`.
"""
@inline copy(c::CRP{T}) where T = CRP{T}(c.q1, c.q2, c.q3)

"""
    vect(c::CRP) -> SVector{3, T}

Return the vector definition of the CRP `c`:

    [q1, q2, q3]
"""
@inline vect(c::CRP) = SVector{3}(c.q1, c.q2, c.q3)

# == UniformScaling ========================================================================

@inline *(u::UniformScaling, c::CRP) = CRP(u) * c
@inline *(c::CRP, u::UniformScaling) = c * CRP(u)
@inline /(u::UniformScaling, c::CRP) = CRP(u) / c
@inline /(c::CRP, u::UniformScaling) = c / CRP(u)
@inline \(u::UniformScaling, c::CRP) = CRP(u) \ c
@inline \(c::CRP, u::UniformScaling) = c \ CRP(u)
