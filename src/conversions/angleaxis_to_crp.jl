## Description #############################################################################
#
# Functions related to the conversion from Euler angle and axis to CRP.
#
############################################################################################

export angleaxis_to_crp

"""
    angleaxis_to_crp(a::Number, v::AbstractVector) -> CRP
    angleaxis_to_crp(av::EulerAngleAxis) -> CRP

Convert the Euler angle `a` [rad] and Euler axis `v` to classical Rodrigues parameters.

Those values can also be passed inside the structure `av` (see [`EulerAngleAxis`](@ref)).

!!! warning

    It is expected that the vector `v` is unitary. However, no verification is performed
    inside the function. The user must handle this situation.

# Example

```jldoctest
julia> angleaxis_to_crp(pi / 2, [1, 0, 0])
CRP{Float64}:
  X : + 1.0
  Y : + 0.0
  Z : + 0.0
```
"""
@inline function angleaxis_to_crp(a::Number, v::AbstractVector)
    return quat_to_crp(angleaxis_to_quat(a, v))
end

@inline angleaxis_to_crp(av::EulerAngleAxis) = quat_to_crp(angleaxis_to_quat(av))
