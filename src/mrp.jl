## Description #############################################################################
#
# Functions related to the Modified Rodrigues Parameters (MRP).
#
## References ##############################################################################
#
# [1] Schaub, H.; Junkins, J. L (1996). Stereographic Orientation Parameters for Attitude
#     Dynamics: A Generalization of the Rodrigues Parameters. In: Journal of the
#     Astronautical Sciences, Vol. 44, No. 1, pp. 1 -- 19.
#
############################################################################################

export dmrp

############################################################################################
#                                       Constructors                                       #
############################################################################################

"""
    MRP(v::AbstractVector)

Create a `MRP` from the vector `v`.
"""
function MRP(v::AbstractVector)
    # The vector must have 3 components.
    length(v) != 3 && throw(ArgumentError("The input vector must have 3 components."))

    return MRP(v[begin], v[begin + 1], v[begin + 2])
end

MRP(::UniformScaling{T}) where T = MRP(zero(T), zero(T), zero(T))

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
    return (m1.q1 == m2.q1) && (m1.q2 == m2.q2) && (m1.q3 == m2.q3)
end

@inline function Base.isapprox(m1::MRP, m2::MRP; kwargs...)
    return isapprox(m1.q1, m2.q1; kwargs...) &&
           isapprox(m1.q2, m2.q2; kwargs...) &&
           isapprox(m1.q3, m2.q3; kwargs...)
end

############################################################################################
#                                        Kinematics                                        #
############################################################################################

"""
    dmrp(m::MRP, wba_b::AbstractVector) -> MRP

Compute the time-derivative of the MRP `m` that rotates a reference frame `a` into alignment
with the reference frame `b` in which the angular velocity of `b` with respect to `a`, and
represented in `b`, is `wba_b` **[1]**.

# Example

```julia-repl
julia> m = MRP(0.0, 0.0, 0.0)
MRP{Float64}:
  X : + 0.0
  Y : + 0.0
  Z : + 0.0

julia> dmrp(m, [1.0, 0.0, 0.0])
MRP{Float64}:
  X : + 0.25
  Y : + 0.0
  Z : + 0.0
```

# References

- **[1]** Schaub, H.; Junkins, J. L (1996). *Stereographic Orientation Parameters for
    Attitude Dynamics: A Generalization of the Rodrigues Parameters*. In: **Journal of the
    Astronautical Sciences**, Vol. 44, No. 1, pp. 1 -- 19.
"""
function dmrp(m::MRP, wba_b::AbstractVector)
    # Check the dimensions.
    length(wba_b) != 3 &&
        throw(ArgumentError("The angular velocity vector must have three components."))

    # Auxiliary variables.
    w₁ = wba_b[begin]
    w₂ = wba_b[begin + 1]
    w₃ = wba_b[begin + 2]

    # Equation [1]:
    #
    #     dmrp    (1 - mrp²) w + 2 (mrp × w) + 2 (mrp ⋅ w) mrp
    #     ──── = ──────────────────────────────────────────────
    #      dt                       4

    k₁       = 1 - (m.q1^2 + m.q2^2 + m.q3^2)
    k₂_₁     = m.q2 * w₃ - m.q3 * w₂
    k₂_₂     = m.q3 * w₁ - m.q1 * w₃
    k₂_₃     = m.q1 * w₂ - m.q2 * w₁
    ds_dot_w = 2 * (m.q1 * w₁ + m.q2 * w₂ + m.q3 * w₃)

    return MRP(
        (k₁ * w₁ + 2k₂_₁ + ds_dot_w * m.q1) / 4,
        (k₁ * w₂ + 2k₂_₂ + ds_dot_w * m.q2) / 4,
        (k₁ * w₃ + 2k₂_₃ + ds_dot_w * m.q3) / 4
    )
end

############################################################################################
#                                            IO                                            #
############################################################################################

function show(io::IO, m::MRP{T}) where T
    # Check if the user wants compact printing, defaulting to `true`.
    compact_printing = get(io, :compact, true)::Bool

    # Get the absolute values using `print`.
    m₀ = sprint(print, abs(m.q1), context = :compact => compact_printing)
    m₁ = sprint(print, abs(m.q2), context = :compact => compact_printing)
    m₂ = sprint(print, abs(m.q3), context = :compact => compact_printing)

    print(io, "MRP{$(T)}: ")
    print(io, "[", m₀, ", ", m₁, ", ", m₂, "]")

    return nothing
end

function show(io::IO, ::MIME"text/plain", m::MRP{T}) where T
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
    am₁ = sprint(print, abs(m.q1), context = context)
    am₂ = sprint(print, abs(m.q2), context = context)
    am₃ = sprint(print, abs(m.q3), context = context)

    # Get the signs.
    sm₁ = signbit(m.q1) ? "-" : "+"
    sm₂ = signbit(m.q2) ? "-" : "+"
    sm₃ = signbit(m.q3) ? "-" : "+"

    # Assemble the context.
    println(io, "MRP{$(T)}:")
    println(io, "  ", b, "X : ", d, sm₁, " ", am₁)
    println(io, "  ", b, "Y : ", d, sm₂, " ", am₂)
    print(  io, "  ", b, "Z : ", d, sm₃, " ", am₃)

    return nothing
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
    #
    #     a        b      a
    #   m₃   =  m₂   ⋅ m₃
    #     c        c      b
    #
    #    a     (1 - |m1|²) m2 + (1 - |m2|²) m1 - 2(m2 x m1)
    #  m₃   = ──────────────────────────────────────────────
    #    c            1 + |m1|² |m2|² - 2(m1 ⋅ m2)
    #

    norm_m1² = m1.q1^2 + m1.q2^2 + m1.q3^2
    norm_m2² = m2.q1^2 + m2.q2^2 + m2.q3^2

    dot_prod = m1.q1 * m2.q1 + m1.q2 * m2.q2 + m1.q3 * m2.q3

    denom = 1 + norm_m1² * norm_m2² - 2 * dot_prod

    # Using cross product inline for performance
    m1_x_m2₁ = m2.q2 * m1.q3 - m2.q3 * m1.q2
    m1_x_m2₂ = m2.q3 * m1.q1 - m2.q1 * m1.q3
    m1_x_m2₃ = m2.q1 * m1.q2 - m2.q2 * m1.q1

    k₁_m1 = 1 - norm_m1²
    k₁_m2 = 1 - norm_m2² 

    q1 = (k₁_m1 * m2.q1 + k₁_m2 * m1.q1 + 2 * m1_x_m2₁) / denom
    q2 = (k₁_m1 * m2.q2 + k₁_m2 * m1.q2 + 2 * m1_x_m2₂) / denom
    q3 = (k₁_m1 * m2.q3 + k₁_m2 * m1.q3 + 2 * m1_x_m2₃) / denom

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
@inline zero(::MRP{T}) where T = zero(MRP{T})

"""
    copy(m::MRP) -> MRP

Create a copy of the MRP `m`.
"""
@inline copy(m::MRP{T}) where T = MRP{T}(m.q1, m.q2, m.q3)

"""
    vect(m::MRP) -> SVector{3, T}

Return the vector definition of the MRP `m`:

    [q1, q2, q3]
"""
@inline vect(m::MRP) = SVector{3}(m.q1, m.q2, m.q3)

# == UniformScaling ========================================================================

@inline *(u::UniformScaling, m::MRP) = MRP(u) * m
@inline *(m::MRP, u::UniformScaling) = m * MRP(u)
@inline /(u::UniformScaling, m::MRP) = MRP(u) / m
@inline /(m::MRP, u::UniformScaling) = m / MRP(u)
@inline \(u::UniformScaling, m::MRP) = MRP(u) \ m
@inline \(m::MRP, u::UniformScaling) = m \ MRP(u)
