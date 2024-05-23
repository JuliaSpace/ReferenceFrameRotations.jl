## Description #############################################################################
#
# Functions related to the conversion from Euler angle and axis to quaternion.
#
############################################################################################

export angleaxis_to_quat

"""
    angleaxis_to_quat(θ::Number, v::AbstractVector) -> Quaternion
    angleaxis_to_quat(angleaxis::EulerAngleAxis) -> Quaternion

Convert the Euler angle `θ` [rad] and Euler axis `v` to a quaternion.

Those values can also be passed inside the structure `ea` (see [`EulerAngleAxis`](@ref)).

!!! warning

    It is expected that the vector `v` is unitary. However, no verification is performed
    inside the function. The user must handle this situation.

# Example

```jldoctest
julia> v = [1, 1, 1];

julia> v /= norm(v);

julia> angleaxis_to_quat(pi / 2, v)
Quaternion{Float64}:
  + 0.707107 + 0.408248⋅i + 0.408248⋅j + 0.408248⋅k
```
"""
@inline function angleaxis_to_quat(θ::T1, v::AbstractVector{T2}) where {T1, T2}
    # Check the arguments.
    (length(v) ≠ 3) && throw(ArgumentError("The provided vector for the Euler axis must have 3 elements."))

    # Obtain the type of the output.
    T = float(promote_type(T1, T2))

    sθo2, cθo2 = sincos(T(θ) / 2)

    # Keep `q0` positive.
    s = (cθo2 < 0) ? -1 : +1

    # Create the quaternion.
    return Quaternion(s * cθo2, s * sθo2 * T.(v))
end

@inline angleaxis_to_quat(av::EulerAngleAxis) = angleaxis_to_quat(av.a, av.v)
