## Description #############################################################################
#
# Functions related to the conversion from Euler angle and axis to MRP.
#
############################################################################################

export angleaxis_to_mrp

"""
    angleaxis_to_mrp(a::Number, v::AbstractVector) -> MRP
    angleaxis_to_mrp(av::EulerAngleAxis) -> MRP

Convert the Euler angle `a` [rad] and Euler axis `v` to modified Rodrigues parameters.

Those values can also be passed inside the structure `av` (see [`EulerAngleAxis`](@ref)).

!!! warning

    It is expected that the vector `v` is unitary. However, no verification is performed
    inside the function. The user must handle this situation.

# Example

```jldoctest
julia> angleaxis_to_mrp(pi / 2, [1, 0, 0])
MRP{Float64}:
  X : + 0.414214
  Y : + 0.0
  Z : + 0.0
```
"""
@inline function angleaxis_to_mrp(a::Number, v::AbstractVector)
    return quat_to_mrp(angleaxis_to_quat(a, v))
end

@inline angleaxis_to_mrp(av::EulerAngleAxis) = quat_to_mrp(angleaxis_to_quat(av))
