# Euler Angles

```@meta
CurrentModule = ReferenceFrameRotations
```

```@setup euler_angles
using ReferenceFrameRotations
```

The Euler Angles are defined by the following immutable structure:

```julia
struct EulerAngles{T}
    a1::T
    a2::T
    a3::T
    rot_seq::Symbol
end
```

in which `a1`, `a2`, and `a3` define the angles and the `rot_seq` is a symbol that defines
the axes. The valid values for `rot_seq` are:

- `:XYX`, `:XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`,
  `:ZXZ`, `:ZYX`, and `ZYZ`.

The constructor for this structure is:

```julia
function EulerAngles(a1::T1, a2::T2, a3::T3, rot_seq::Symbol = :ZYX) where {T1,T2,T3}
```

in which a `EulerAngles` with angles `a1`, `a2`, and `a3` [rad] and rotation sequence
`rot_seq` will be created. Notice that the type of the returned structure will be selected
according to the input types `T1`, `T2`, and `T3`. If `rot_seq` is omitted, then it defaults
to `:ZYX`.

```@repl euler_angles
EulerAngles(1, 1, 1)

EulerAngles(1, 1, 1.0f0, :XYZ)

EulerAngles(1., 1, 1, :XYX)
```

## Operations

### Multiplication

The multiplication of two Euler angles is defined here as the composition of the rotations.
Let ``\Theta_1`` and ``\Theta_2`` be two sequences of Euler angles (instances of the
structure `EulerAngles`). Thus, the operation:

```math
\Theta_{2,1} = \Theta_2 \cdot \Theta_1
```

will return a new set of Euler angles ``\Theta_{2,1}`` that represents the composed rotation
of ``\Theta_1`` followed by ``\Theta_2``. Notice that ``\Theta_{2,1}`` will be represented
using the same rotation sequence as ``\Theta_2``.

```@repl euler_angles
a1 = EulerAngles(1, 0, 0, :ZYX)

a2 = EulerAngles(0, -1, 0, :YZY)

a2 * a1

a1 = EulerAngles(1, 1, 1, :YZY)

a2 = EulerAngles(0, 0, -1, :YZY)

a2 * a1

a1 = EulerAngles(1.3, 2.2, 1.4, :XYZ)

a2 = EulerAngles(-1.4, -2.2, -1.3, :ZYX)

a2 * a1
```

### Inversion

The `inv` function applied to Euler angles will return the inverse rotation. If the Euler
angles ``\Theta`` represent a rotation through the axes ``a_1``, ``a_2``, and ``a_3`` by
angles ``\alpha_1``, ``\alpha_2``, and ``\alpha_3``, then ``\Theta^{-1}`` is a rotation
through the axes ``a_3``, ``a_2``, and ``a_1`` by angles ``-\alpha_3``, ``-\alpha_2``, and
``-\alpha_1``.

```@repl euler_angles
a = EulerAngles(1, 2, 3, :ZYX)

inv(a)

a = EulerAngles(1.2, 3.3, 4.6, :XYX)

a * inv(a)
```

!!! warning

    All the operations related to Euler angles first convert them to DCM or Quaternions, and
    then the result is converted back to Euler angles. Hence, the performance will not be
    good.
