# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the conversion from Euler angle and axis to Euler
#   angles.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export angleaxis_to_angle

"""
    angleaxis_to_angle(θ::Number, v::AbstractVector, rot_seq::Symbol)
    angleaxis_to_angle(av::EulerAngleAxis, rot_seq::Symbol)

Convert the Euler angle `θ` [rad]  and Euler axis `v` to Euler angles with
rotation sequence `rot_seq`.

Those values can also be passed inside the structure `av` (see
[`EulerAngleAxis`](@ref)).

The rotation sequence is defined by a `:Symbol`. The possible values are:
`:XYX`, `XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`,
`:ZYX`, and `:ZYZ`. If no value is specified, then it defaults to `:ZYX`.

!!! warning
    It is expected that the vector `v` is unitary. However, no verification is
    performed inside the function. The user must handle this situation.

# Example

```jldoctest
julia> av = EulerAngleAxis(deg2rad(45), [1, 0, 0]);

julia> angleaxis_to_angle(av, :ZXY)
EulerAngles{Float64}:
  R(Z) :  0.0      rad  ( 0.0°)
  R(X) :  0.785398 rad  ( 45.0°)
  R(Y) :  0.0      rad  ( 0.0°)
```
"""
@inline function angleaxis_to_angle(θ::Number, v::AbstractVector, rot_seq::Symbol)
    # Check the arguments.
    (length(v) ≠ 3) && throw(ArgumentError("The provided vector for the Euler axis must have 3 elements."))

    # First we convert to DCM then to Euler angles.
    return dcm_to_angle(angleaxis_to_dcm(θ, v), rot_seq)
end

@inline function angleaxis_to_angle(av::EulerAngleAxis, rot_seq::Symbol)
    return angleaxis_to_angle(av.a, av.v, rot_seq)
end
