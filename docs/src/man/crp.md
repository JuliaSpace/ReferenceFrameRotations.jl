# Classical Rodrigues Parameters

```@meta
CurrentModule = ReferenceFrameRotations
```

```@setup crp
using ReferenceFrameRotations
```

The Classical Rodrigues Parameters (CRP) are defined by the following immutable structure:

```julia
struct CRP{T}
    q1::T
    q2::T
    q3::T
end
```

The CRP is a 3-element parameterization of a rotation. In this package, it can be seen as
the stereographic parameter obtained from a quaternion by dividing the vector part by the
real part. Hence, it is singular for rotations of ``180^\circ``.

If a rotation is represented by the Euler angle ``\phi`` and the unitary Euler vector
``\mathbf{e}``, then the corresponding CRP ``\mathbf{c}`` is defined by:

```math
\mathbf{c} = \mathbf{e} \tan\left(\frac{\phi}{2}\right)\ .
```

Therefore, if ``\phi = \pi`` rad (``180^\circ``), then ``\tan(\phi/2)`` is singular and the
CRP is not defined.

## Initialization

The constructors for this structure are:

```julia
CRP(q1::T1, q2::T2, q3::T3) where {T1,T2,T3}
CRP(v::AbstractVector)
```

in which a `CRP` with components `q1`, `q2`, and `q3` will be created. Notice that the type
of the returned structure will be selected according to the input types.

```@repl crp
CRP(0.1, 0.2, 0.3)

CRP([0.1, 0.2, 0.3])

CRP(1, 2, 3.0f0)
```

It is also possible to create the identity rotation using `I`, `zero`, and `one`:

```@repl crp
CRP(I)

zero(CRP)

one(CRP)
```

!!! note

    Individual elements of the CRP can be accessed by:

    ```julia
    c.q1
    c.q2
    c.q3
    ```

    or using linear indexing:

    ```julia
    c[1]
    c[2]
    c[3]
    ```

## Operations

### Sum, subtraction, and scalar multiplication

```@repl crp
c1 = CRP(0.1, 0.2, 0.3)

c2 = CRP(0.2, -0.1, 0.1)

c1 + c2

c1 - c2

2c1

c1 / 2
```

### Multiplication (rotation composition)

The multiplication of two CRPs is defined here as the composition of the rotations. Let
``\mathbf{c}_1`` and ``\mathbf{c}_2`` be two CRPs (instances of the structure `CRP`). Thus,
the operation:

```math
\mathbf{c}_{2,1} = \mathbf{c}_2 \cdot \mathbf{c}_1
```

will return a new CRP ``\mathbf{c}_{2,1}`` that represents the composed rotation of
``\mathbf{c}_1`` followed by ``\mathbf{c}_2``.

!!! warning

    The CRP representation is singular at ``180^\circ``. Therefore, composing two CRPs can
    fail if the resulting rotation is exactly at that singularity.

```@repl crp
c1 = angle_to_crp(0.1, 0.2, 0.3, :ZYX)

c2 = angle_to_crp(-0.2, 0.1, -0.1, :XYZ)

c2 * c1
```

### Inversion

The inverse rotation is obtained using `inv`:

```@repl crp
c = angle_to_crp(0.2, -0.1, 0.3, :ZYX)

inv(c)
```

### Functions

Useful helper functions include:

```@repl crp
c = CRP(0.1, 0.2, 0.3)

norm(c)

vect(c)

copy(c)

shadow_rotation(c)
```

The shadow rotation of a CRP is the CRP itself.

## Kinematics

The time-derivative of a CRP can be computed using:

```julia
function dcrp(c::CRP, wba_b::AbstractVector)
```

```@repl crp
c = CRP(0.0, 0.0, 0.0)

wba_b = [0.01, 0.02, -0.03]

dcrp(c, wba_b)
```
