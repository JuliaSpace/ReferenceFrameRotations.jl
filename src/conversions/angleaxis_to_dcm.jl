## Description #############################################################################
#
# Functions related to the conversion from Euler angle and axis to DCM.
#
############################################################################################

export angleaxis_to_dcm

"""
    angleaxis_to_dcm(a::Number, v::AbstractVector) -> DCM
    angleaxis_to_dcm(av::EulerAngleAxis) -> DCM

Convert the Euler angle `a` [rad] and Euler axis `v` to a DCM.

Those values can also be passed inside the structure `ea` (see [`EulerAngleAxis`](@ref)).

!!! warning

    It is expected that the vector `v` is unitary. However, no verification is performed
    inside the function. The user must handle this situation.

# Example

```jldoctest
julia> v = [1, 1, 1];

julia> v /= norm(v);

julia> angleaxis_to_dcm(pi / 2, v)
DCM{Float64}:
  0.333333   0.910684  -0.244017
 -0.244017   0.333333   0.910684
  0.910684  -0.244017   0.333333

julia> ea = EulerAngleAxis(pi / 2, v);

julia> angleaxis_to_dcm(ea)
DCM{Float64}:
  0.333333   0.910684  -0.244017
 -0.244017   0.333333   0.910684
  0.910684  -0.244017   0.333333
```
"""
@inline function angleaxis_to_dcm(a::T1, v::AbstractVector{T2}) where {T1, T2}
    # Check the arguments.
    (length(v) ≠ 3) && throw(ArgumentError("The provided vector for the Euler axis must have 3 elements."))

    # Obtain the output type.
    T = float(promote_type(T1, T2))

    sθ, cθ = sincos(T(a))
    aux    = 1 - cθ

    v₁ = T(v[1])
    v₂ = T(v[2])
    v₃ = T(v[3])

    return DCM(
        cθ + v₁ * v₁ * aux,      v₁ * v₂ * aux + v₃ * sθ, v₁ * v₃ * aux - v₂ * sθ,
        v₁ * v₂ * aux - v₃ * sθ, cθ + v₂ * v₂ * aux,      v₂ * v₃ * aux + v₁ * sθ,
        v₁ * v₃ * aux + v₂ * sθ, v₂ * v₃ * aux - v₁ * sθ, cθ + v₃ * v₃ * aux
    )'
end

@inline angleaxis_to_dcm(av::EulerAngleAxis) = angleaxis_to_dcm(av.a, av.v)
