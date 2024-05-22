# Euler Angle and Axis

```@meta
CurrentModule = ReferenceFrameRotations
```

```@setup euler_angle_axis
using ReferenceFrameRotations
```

The Euler angle and axis representation is defined by the following immutable structure:

```julia
struct EulerAngleAxis{T}
    a::T
    v::SVector{3,T}
end
```

in which `a` is the Euler Angle and `v` is a unitary vector aligned with the Euler axis.

The constructor for this structure is:

```julia
function EulerAngleAxis(a::T1, v::AbstractVector{T2}) where {T1,T2}
```

in which a `EulerAngleAxis` with angle `a` [rad] and vector `v` will be created. Notice that
the type of the returned structure will be selected according to the input types `T1` and
`T2`. Furthermore, the vector `v` **will not** be normalized.

```@repl euler_angle_axis
EulerAngleAxis(1, [1, 1, 1])

EulerAngleAxis(1.f0, [1, 1, 1])

EulerAngleAxis(1, [1, 1, 1.f0])

EulerAngleAxis(1.0, [1, 1, 1])
```

## Operations

### Multiplication

The multiplication of two Euler angle and axis sets is defined here as the composition of
the rotations. Let ``\Theta_1`` and ``\Theta_2`` be two Euler angle and axis sets (instances
of the structure `EulerAngleAxis`).  Thus, the operation:

```math
\Theta_{2,1} = \Theta_2 \cdot \Theta_1
```

will return a new set of Euler angle and axis ``\Theta_{2,1}`` that represents the composed
rotation of ``\Theta_1`` followed by ``\Theta_2``. By convention, the Euler angle of the
result will always be in the interval ``[0, \pi]`` rad.

!!! warning

    This operation is only valid if the vector of the Euler angle and axis set
    is unitary. The multiplication function does not verify this and does not
    normalize the vector.

```@repl euler_angle_axis
ea1 = EulerAngleAxis(30 * pi / 180, [1.0, 0.0, 0.0])

ea2 = EulerAngleAxis(60 * pi / 180, [1.0, 0.0, 0.0])

ea2 * ea1
```

### Inversion

The `inv` function applied to Euler angle and axis will return the inverse rotation. Hence,
if the Euler angle is `a` and the Euler axis is aligned with the unitary vector `v`, then it
  will return `a` as the Euler angle and `-v` as the Euler axis. By convention, the Euler
  angle of the result will always be in the interval ``[0, \pi]`` rad.

```@repl euler_angle_axis
ea = EulerAngleAxis(1.3, [1.0, 0, 0])

inv(ea)

ea = EulerAngleAxis(-π, [sqrt(3), sqrt(3), sqrt(3)])

inv(ea)

ea = EulerAngleAxis(-3π / 2, [sqrt(3), sqrt(3), sqrt(3)])

inv(ea)
```
