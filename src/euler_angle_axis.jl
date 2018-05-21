################################################################################
#                             Euler Angle and Axis
################################################################################

export angleaxis2quat

################################################################################
#                                 Conversions
################################################################################

# Quaternions
# ==============================================================================

"""
    function angleaxis2quat(a::Number, v::Vector)

Convert the Euler angle `a` and Euler axis `v`, which must be a unit vector, to
a quaternion.

# Args

* `a`: Euler angle [rad].
* `v`: Unit vector that is aligned with the Euler axis.

# Returns

A quaternion that represents the same rotation of the Euler angle and axis.

# Remarks

It is expected that the vector `v` is unitary. However, no verification is
performed inside the function. The user must handle this situation.

# Example

```julia-repl
julia> v = [1;1;1];

julia> v /= norm(v);

julia> angleaxis2quat(pi/2,v)
Quaternion{Float64}:
  + 0.7071067811865476 + 0.408248290463863.i + 0.408248290463863.j + 0.408248290463863.k
```
---
"""
function angleaxis2quat(a::Number, v::Vector)
    # Check the arguments.
    if length(v) > 3
        throw(ArgumentError("The provided vector for the Euler axis must have 3 elements."))
    end

    # Create the quaternion.
    Quaternion( cos(a/2), sin(a/2)*v )
end

"""
    function angleaxis2quat(angleaxis::EulerAngleAxis{T}) where T<:Real

Convert a Euler angle and Euler axis `angleaxis` (see `EulerAngleAxis`) to a
quaternion.

# Args

* `angleaxis`: Structure of type `EulerAngleAxis` with the Euler angle [rad] and
             a unit vector that is aligned with the Euler axis.

# Returns

A quaternion that represents the same rotation of the Euler angle and axis.

# Remarks

It is expected that the vector `angleaxis.v` is unitary. However, no
verification is performed inside the function. The user must handle this
situation.

# Example

```julia-repl
julia> v = [1;1;1];

julia> v /= norm(v);

julia> angleaxis2quat(EulerAngleAxis(pi/2,v))
Quaternion{Float64}:
  + 0.7071067811865476 + 0.408248290463863.i + 0.408248290463863.j + 0.408248290463863.k
```

"""
function angleaxis2quat(angleaxis::EulerAngleAxis{T}) where T<:Real
    # Create a quaternion using the provided Euler angle and axis.
    angleaxis2quat(angleaxis.a, angleaxis.v)
end
