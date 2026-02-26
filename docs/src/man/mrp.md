# Modified Rodrigues Parameters

```@meta
CurrentModule = ReferenceFrameRotations
```

```@setup mrp
using ReferenceFrameRotations
```

The Modified Rodrigues Parameters (MRP) are defined by the following immutable structure:

```julia
struct MRP{T}
    q1::T
    q2::T
    q3::T
end
```

The MRP is a 3-element parameterization of a rotation related to quaternions by a
stereographic projection. Compared with CRP, it moves the singularity to ``360^\circ`` and
therefore remains finite at ``180^\circ``.

If a rotation is represented by the Euler angle ``\phi`` and the unitary Euler vector
``\mathbf{e}``, then the corresponding MRP ``\mathbf{m}`` is defined by:

```math
\mathbf{m} = \mathbf{e} \tan\left(\frac{\phi}{4}\right)\ .
```

Hence, the MRP remains finite for ``\phi = \pi`` rad (``180^\circ``), and becomes singular
only for ``\phi = 2\pi`` rad (``360^\circ``).

## Initialization

The constructors for this structure are:

```julia
MRP(q1::T1, q2::T2, q3::T3) where {T1,T2,T3}
MRP(v::AbstractVector)
```

in which a `MRP` with components `q1`, `q2`, and `q3` will be created. Notice that the type
of the returned structure will be selected according to the input types.

```@repl mrp
MRP(0.1, 0.2, 0.3)

MRP([0.1, 0.2, 0.3])

MRP(1, 2, 3.0f0)
```

It is also possible to create the identity rotation using `I`, `zero`, and `one`:

```@repl mrp
MRP(I)

zero(MRP)

one(MRP)
```

!!! note

    Individual elements of the MRP can be accessed by:

    ```julia
    m.q1
    m.q2
    m.q3
    ```

    or using linear indexing:

    ```julia
    m[1]
    m[2]
    m[3]
    ```

## Operations

### Sum, subtraction, and scalar multiplication

```@repl mrp
m1 = MRP(0.1, 0.2, 0.3)

m2 = MRP(0.2, -0.1, 0.1)

m1 + m2

m1 - m2

2m1

m1 / 2
```

### Multiplication (rotation composition)

The multiplication of two MRPs is defined here as the composition of the rotations. Let
``\mathbf{m}_1`` and ``\mathbf{m}_2`` be two MRPs (instances of the structure `MRP`). Thus,
the operation:

```math
\mathbf{m}_{2,1} = \mathbf{m}_2 \cdot \mathbf{m}_1
```

will return a new MRP ``\mathbf{m}_{2,1}`` that represents the composed rotation of
``\mathbf{m}_1`` followed by ``\mathbf{m}_2``.

!!! note

    MRP has a shadow-set representation. Depending on the rotation, the result can be
    represented by different MRP vectors that describe the same attitude. If desired, use
    `shadow_rotation(m)` to switch to the shadow set.

```@repl mrp
m1 = angle_to_mrp(0.1, 0.2, 0.3, :ZYX)

m2 = angle_to_mrp(-0.2, 0.1, -0.1, :XYZ)

m2 * m1
```

### Inversion

The inverse rotation is obtained using `inv`:

```@repl mrp
m = angle_to_mrp(0.2, -0.1, 0.3, :ZYX)

inv(m)
```

### Shadow rotation

The MRP admits a shadow set representation that corresponds to the same rotation and is
useful when the norm grows too large.

```@repl mrp
m = MRP(0.8, 0.2, -0.1)

shadow_rotation(m)
```

### Functions

Useful helper functions include:

```@repl mrp
m = MRP(0.1, 0.2, 0.3)

norm(m)

vect(m)

copy(m)
```

## Kinematics

The time-derivative of a MRP can be computed using:

```julia
function dmrp(m::MRP, wba_b::AbstractVector)
```

```@repl mrp
m = MRP(0.0, 0.0, 0.0)

wba_b = [0.01, 0.02, -0.03]

dmrp(m, wba_b)
```
