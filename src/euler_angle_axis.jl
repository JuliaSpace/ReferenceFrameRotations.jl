################################################################################
#                             Euler Angle and Axis
################################################################################

export angleaxis_to_quat

################################################################################
#                                  Operations
################################################################################

"""
    function *(ea₂::EulerAngleAxis{T1}, ea₁::EulerAngleAxis{T2}) where {T1,T2}

Compute the composed rotation of `ea₁ -> ea₂`. Notice that the rotation will be
represented by a Euler angle and axis (see `EulerAngleAxis`). By convention, the
output angle will always be in the range [0, 2π] [rad].

Notice that the vector representing the axis in `ea₁` and `ea₂` must be unitary.
This function neither verifies this nor normalizes the vector.

"""
function *(ea₂::EulerAngleAxis{T1}, ea₁::EulerAngleAxis{T2}) where {T1,T2}
    # Auxiliary variables.
    T = promote_type(T1,T2)

    sθ₁o2, cθ₁o2 = sincos(ea₁.a/2)
    sθ₂o2, cθ₂o2 = sincos(ea₂.a/2)

    v₁ = ea₁.v
    v₂ = ea₂.v

    # Compute the new Euler angle and axis [0, 2π].
    θ = mod(2acos(cθ₁o2*cθ₂o2 - sθ₁o2*sθ₂o2 * dot(v₁, v₂)), T(2)*π)

    if (θ == 0) || (θ == 2π)
        # Avoid division by zero.
        a = SVector{3,T}(0,0,0)
    else
        a = ( sθ₁o2*cθ₂o2*v₁ + cθ₁o2*sθ₂o2*v₂ + sθ₁o2*sθ₂o2*(v₁ × v₂) )/sin(θ/2)
    end

    EulerAngleAxis(θ, a)
end

################################################################################
#                                 Conversions
################################################################################

# Quaternions
# ==============================================================================

"""
    function angleaxis_to_quat(a::Number, v::AbstractVector)

Convert the Euler angle `a` [rad] and Euler axis `v`, which must be a unit
vector, to a quaternion.

# Remarks

It is expected that the vector `v` is unitary. However, no verification is
performed inside the function. The user must handle this situation.

# Example

```julia-repl
julia> v = [1;1;1];

julia> v /= norm(v);

julia> angleaxis_to_quat(pi/2,v)
Quaternion{Float64}:
  + 0.7071067811865476 + 0.408248290463863.i + 0.408248290463863.j + 0.408248290463863.k
```

"""
function angleaxis_to_quat(a::Number, v::AbstractVector)
    # Check the arguments.
    (length(v) > 3) && throw(ArgumentError("The provided vector for the Euler axis must have 3 elements."))

    # Create the quaternion.
    Quaternion( cos(a/2), sin(a/2)*v )
end

"""
    function angleaxis_to_quat(angleaxis::EulerAngleAxis)

Convert a Euler angle and Euler axis `angleaxis` (see `EulerAngleAxis`) to a
quaternion.

# Remarks

It is expected that the vector `angleaxis.v` is unitary. However, no
verification is performed inside the function. The user must handle this
situation.

# Example

```julia-repl
julia> v = [1;1;1];

julia> v /= norm(v);

julia> angleaxis_to_quat(EulerAngleAxis(pi/2,v))
Quaternion{Float64}:
  + 0.7071067811865476 + 0.408248290463863.i + 0.408248290463863.j + 0.408248290463863.k
```

"""
angleaxis_to_quat(angleaxis::EulerAngleAxis) = angleaxis_to_quat(angleaxis.a,
                                                                 angleaxis.v)
