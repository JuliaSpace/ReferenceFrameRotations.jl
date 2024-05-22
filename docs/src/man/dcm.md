# Direction Cosine Matrices

```@meta
CurrentModule = ReferenceFrameRotations
```

```@setup dcm
using LinearAlgebra
using ReferenceFrameRotations
```

Direction cosine matrices, or DCMs, are ``3 \times 3`` matrices that represent a coordinate
transformation between two orthonormal reference frames. Let those frames be right-handed,
then it can be shown that this transformation is always a rotation. Thus, a DCM that rotates
the reference frame ``a`` into alignment with the reference frame ``b`` is:

```math
\mathbf{D}_{ba} = \left[\begin{matrix}
    a_{11} & a_{12} & a_{13} \\
    a_{21} & a_{22} & a_{23} \\
    a_{31} & a_{32} & a_{33}
    \end{matrix}\right]
```

In **ReferenceFrameRotations.jl**, a DCM is a ``3 \times 3`` static matrix, *i.e.* it is
immutable.

## Initialization

Usually, a DCM is initialized by converting a more "visual" rotation representation, such as
the Euler angles (see [Conversions](@ref)). However, it can be initialized by the following
methods:

* Identity DCM.

```@repl dcm
DCM(I)  # Create a Boolean DCM, this can be used to save space.

DCM(Int64(1)I)  # Create an Integer DCM.

DCM(1.f0I) # Create a Float32 DCM.

DCM(1.0I)  # Create a Float64 DCM.
```

* User-defined DCM.

```@repl dcm
DCM([-1 0 0; 0 -1 0; 0 0 1])

DCM([-1.f0 0.f0 0.f0; 0.f0 -1.f0 0.f0; 0.f0 0.f0 1.f0])

DCM([-1.0 0.0 0.0; 0.0 -1.0 0.0; 0.0 0.0 1.0])
```

!!! note

    The type of the DCM will depend on the type of the input.

!!! warning

    This initialization method **will not** verify if the input data is indeed a DCM.

## Operations

Since a DCM is a static matrix (`<: StaticMatrix`), then all the operations available for
general matrices in Julia are also available for DCMs.

### Orthonomalization

A DCM can be orthonormalized using the Gram-Schmidt algorithm by the function:

```julia
function orthonormalize(dcm::DCM)
```

```@repl dcm
D = DCM([2 0 0; 0 2 0; 0 0 2])

orthonormalize(D)

D = DCM(3.0f0I);

orthonormalize(D)

D = DCM(1, 1, 2, 2, 3, 3, 4, 4, 5);

Dn = orthonormalize(D)

Dn * Dn'
```

!!! warning

    This function does not check if the columns of the input matrix span a three-dimensional
    space. If not, then the returned matrix should have `NaN`. Notice, however, that such
    input matrix is not a valid direction cosine matrix.
