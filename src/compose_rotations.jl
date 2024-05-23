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
    compose_rotation(R1::T, [, R2::T, R3::T, R4::T, R5::T, ...]) -> T

Compute a composed rotation using the rotations `R1`, `R2`, `R3`, `R4`, ..., in the
following order:

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
- A set of Euler angles ([`EulerAngles`](@ref)); or
- A quaternion ([`Quaternion`](@ref)).

Notice, however, that all rotations **must be** of the same type (DCM or quaternion).

The output will have the same type as the inputs.

# Example

```jldoctest
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

# This algorithm was proposed by @Per in
#
#   https://discourse.julialang.org/t/improve-the-performance-of-multiplication-of-an-arbitrary-number-of-matrices/10835/24

# == Operator: ∘ ===========================================================================

function ∘(R2::T1, R1::T2) where {T1<:ReferenceFrameRotation, T2<:ReferenceFrameRotation}
    R1c = convert(T1, R1)
    return compose_rotation(R1c, R2)
end
