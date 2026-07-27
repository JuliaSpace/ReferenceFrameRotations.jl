## Description #############################################################################
#
# Generic function to compose rotations.
#
############################################################################################

export compose_rotation

############################################################################################
#                                    Compose Rotations                                     #
############################################################################################

"""
    compose_rotation(
        R1::ReferenceFrameRotation,
        Rs::ReferenceFrameRotation...
    ) -> ReferenceFrameRotation
    compose_rotation(rotations::Tuple) -> T
    compose_rotation(rotations::AbstractVector) -> T

Compose the rotations `R1`, `R2`, `R3`, `R4`, ..., in the following order:

     First rotation
     |
     |
    R1 => R2 => R3 => R4 => ...
           |
           |
           Second rotation

The rotations can be described by:

- A direction cosine matrix ([`DCM`](@ref));
- An Euler angle and axis ([`EulerAngleAxis`](@ref));
- A set of Euler angles ([`EulerAngles`](@ref));
- A quaternion ([`Quaternion`](@ref));
- Classical Rodrigues parameters ([`CRP`](@ref)); or
- Modified Rodrigues parameters ([`MRP`](@ref)).

Mixed rotation types are supported through the composition operator `∘`.

For inputs of the same type, the output has that type. With mixed types, the composition
operator uses the type of its first operand for the output.

A nonempty tuple or vector of rotations can also be passed as one argument. Homogeneous
collections preserve their concrete rotation type and are the preferred path for long
chains. Heterogeneous tuples use the same behavior as splatting the tuple into
`compose_rotation`.

# Example

```julia-repl
julia> D1 = angle_to_dcm(pi / 3, pi / 4, pi / 5, :ZYX);

julia> D2 = angle_to_dcm(-pi / 5, -pi / 4, -pi / 3, :XYZ);

julia> compose_rotation(D1, D2)
DCM{Float64}:
 1.0          1.08801e-17  3.54837e-17
 1.08801e-17  1.0          2.88714e-17
 3.54837e-17  2.88714e-17  1.0

julia> ea1 = EulerAngleAxis(30 * pi / 180, [0, 1, 0]);

julia> ea2 = EulerAngleAxis(45 * pi / 180, [0, 1, 0]);

julia> compose_rotation(ea1, ea2)
EulerAngleAxis{Float64}:
  Euler angle : 1.309 rad  (75.0°)
  Euler axis  : [0.0, 1.0, 0.0]

julia> Θ1 = EulerAngles(1, 2, 3, :ZYX);

julia> Θ2 = EulerAngles(-3, -2, -1, :XYZ);

julia> compose_rotation(Θ1, Θ2)
EulerAngles{Float64}:
  R(X) : -1.66533e-16 rad  (-9.54166e-15°)
  R(Y) :  9.24446e-33 rad  ( 5.29669e-31°)
  R(Z) : -1.11022e-16 rad  (-6.36111e-15°)

julia> q1 = angle_to_quat(pi / 3, pi / 4, pi / 5, :ZYX);

julia> q2 = angle_to_quat(-pi / 5, -pi / 4, -pi / 3, :XYZ);

julia> compose_rotation(q1, q2)
Quaternion{Float64}:
  + 1.0 + 0.0⋅i + 2.08167e-17⋅j + 5.55112e-17⋅k
```
"""
@inline compose_rotation(D::DCM) = D
@inline compose_rotation(D::DCM, Ds::DCM...) = compose_rotation(Ds...) * D

@inline compose_rotation(ea::EulerAngleAxis) = ea
@inline function compose_rotation(ea::EulerAngleAxis, eas::EulerAngleAxis...)
    return compose_rotation(eas...) * ea
end

@inline compose_rotation(Θ::EulerAngles) = Θ
@inline compose_rotation(Θ::EulerAngles, Θs::EulerAngles...) = compose_rotation(Θs...) * Θ

@inline compose_rotation(q::Quaternion) = q
@inline compose_rotation(q::Quaternion, qs::Quaternion...) = q * compose_rotation(qs...)

@inline compose_rotation(c::CRP) = c
@inline compose_rotation(c::CRP, cs::CRP...) = compose_rotation(cs...) * c

@inline compose_rotation(m::MRP) = m
@inline compose_rotation(m::MRP, ms::MRP...) = compose_rotation(ms...) * m

const ReverseCompositionRotation = Union{DCM, EulerAngleAxis, EulerAngles, CRP, MRP}

@inline function compose_rotation(
    Rs::Tuple{T, Vararg{T}}
) where {T <: ReverseCompositionRotation}
    R = last(Rs)
    for i in (lastindex(Rs) - 1):-1:firstindex(Rs)
        R = R * Rs[i]
    end
    return R
end

@inline function compose_rotation(
    Rs::AbstractVector{T}
) where {T <: ReverseCompositionRotation}
    isempty(Rs) && throw(ArgumentError("cannot compose an empty collection of rotations"))
    R = last(Rs)
    for i in (lastindex(Rs) - 1):-1:firstindex(Rs)
        R = R * Rs[i]
    end
    return R
end

@inline function compose_rotation(qs::Tuple{T, Vararg{T}}) where {T <: Quaternion}
    q = last(qs)
    for i in (lastindex(qs) - 1):-1:firstindex(qs)
        q = qs[i] * q
    end
    return q
end

@inline function compose_rotation(qs::AbstractVector{T}) where {T <: Quaternion}
    isempty(qs) && throw(ArgumentError("cannot compose an empty collection of rotations"))
    q = last(qs)
    for i in (lastindex(qs) - 1):-1:firstindex(qs)
        q = qs[i] * q
    end
    return q
end

compose_rotation(::Tuple{}) = throw(
    ArgumentError("cannot compose an empty tuple of rotations")
)

function compose_rotation(Rs::Tuple{ReferenceFrameRotation, Vararg{ReferenceFrameRotation}})
    return compose_rotation(Rs...)
end

# This algorithm was proposed by @Per in
#
#   https://discourse.julialang.org/t/improve-the-performance-of-multiplication-of-an-arbitrary-number-of-matrices/10835/24

# == Operator: ∘ ===========================================================================

"""
    ∘(R2::ReferenceFrameRotation, R1::ReferenceFrameRotation) -> ReferenceFrameRotation

Compose `R1` followed by `R2`, converting `R1` to the type of `R2` before composition.
"""
function ∘(
    R2::T1, R1::T2
) where {T1 <: ReferenceFrameRotation, T2 <: ReferenceFrameRotation}
    R1c = convert(T1, R1)
    return compose_rotation(R1c, R2)
end
