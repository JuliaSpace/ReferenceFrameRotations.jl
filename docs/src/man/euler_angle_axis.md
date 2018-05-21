Euler Angle and Axis
====================

The Euler angle and axis representation is defined by the following immutable
structure:

```julia
struct EulerAngleAxis{T<:Real}
    a::T
    v::Vector{T}
end
```

in which `a` is the Euler Angle and `v` is a unitary vector aligned with the
Euler axis.

!!! note

    The support of this representation is still incomplete. Only the conversion
    to and from quaternions are implemented. Furthermore, there is no support
    for operations using Euler angles and axes.

