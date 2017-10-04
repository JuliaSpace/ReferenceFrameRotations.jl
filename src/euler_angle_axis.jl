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
### function angleaxis2quat(a::T, v::Vector{T}) where T<:Real

Convert a Euler angle and axis to quaternion.

##### Args

* a: Euler angle [rad].
* v: Unit vector that is aligned with the Euler axis.

##### Returns

* A quaternion that represents the same rotation of the Euler angle and axis
provided.

##### Remarks

It is expected that the vector `v` is unitary. However, no verification is
performed inside the function. The user must handle this situation.

"""

function angleaxis2quat(a::T, v::Vector{T}) where T<:Real
    # Check the arguments.
    if length(v) > 3
        throw(ArgumentError("The provided vector for the Euler axis must have 3 elements."))
    end

    # Create the quaternion.
    Quaternion( cos(a/2), sin(a/2)*v )
end

"""
### function angleaxis2quat(angleaxis::EulerAngleAxis{T}) where T<:Real

Convert a Euler angle and axis to quaternion.

##### Args

* angleaxis: Structure of type `EulerAngleAxis` with the Euler angle [rad] and
a unit vector that is aligned with the Euler angle.

##### Returns

* A quaternion that represents the same rotation of the Euler angle and axis
provided.

##### Remarks

It is expected that the vector `angleaxis.v` is unitary. However, no
verification is performed inside the function. The user must handle this
situation.

"""

function angleaxis2quat(angleaxis::EulerAngleAxis{T}) where T<:Real
    # Create a quaternion using the provided Euler angle and axis.
    angleaxis2quat(angleaxis.a, angleaxis.v)
end

