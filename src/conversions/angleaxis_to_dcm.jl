# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the conversion from Euler angle and axis to DCM.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export angleaxis_to_dcm

"""
    angleaxis_to_dcm(a::Number, v::AbstractVector)
    angleaxis_to_dcm(av::EulerAngleAxis)

Convert the Euler angle `a` [rad] and Euler axis `v` to a DCM.

Those values can also be passed inside the structure `ea` (see
[`EulerAngleAxis`](@ref)).

!!! warning
    It is expected that the vector `v` is unitary. However, no verification is
    performed inside the function. The user must handle this situation.

# Example

```julia-repl
julia> v = [1, 1, 1];

julia> v /= norm(v);

julia> angleaxis_to_dcm(pi / 2, v)
3×3 StaticArrays.SMatrix{3, 3, Float64, 9} with indices SOneTo(3)×SOneTo(3):
  0.333333   0.910684  -0.244017
 -0.244017   0.333333   0.910684
  0.910684  -0.244017   0.333333

julia> ea = EulerAngleAxis(pi / 2, v);

julia> angleaxis_to_dcm(ea)
3×3 StaticArrays.SMatrix{3, 3, Float64, 9} with indices SOneTo(3)×SOneTo(3):
  0.333333   0.910684  -0.244017
 -0.244017   0.333333   0.910684
  0.910684  -0.244017   0.333333
```
"""
@inline function angleaxis_to_dcm(a::Number, v::AbstractVector)
    # Check the arguments.
    (length(v) ≠ 3) && throw(ArgumentError("The provided vector for the Euler axis must have 3 elements."))

    sθ, cθ = sincos(a)
    aux    = 1 - cθ

    return DCM(
          cθ + v[1] * v[1] * aux,      v[1] * v[2] * aux + v[3] * sθ, v[1] * v[3] * aux - v[2] * sθ,
        v[1] * v[2] * aux - v[3] * sθ,   cθ + v[2] * v[2] * aux,      v[2] * v[3] * aux + v[1] * sθ,
        v[1] * v[3] * aux + v[2] * sθ, v[2] * v[3] * aux - v[1] * sθ,   cθ + v[3] * v[3] * aux
    )'
end

@inline angleaxis_to_dcm(av::EulerAngleAxis) = angleaxis_to_dcm(av.a, av.v)
