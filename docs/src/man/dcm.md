Direction Cosine Matrices
=========================

```@meta
CurrentModule = ReferenceFrameRotations
DocTestSetup = quote
    using ReferenceFrameRotations
end
```

Direction cosine matrices, or DCMs, are ``3 \times 3`` matrices that represent a
coordinate transformation between two orthonormal reference frames. Let those
frames be right-handed, then it can be shown that this transformation is always
a rotation. Thus, a DCM that rotates the reference frame ``a`` into alignment
with the reference frame ``b`` is:

```math
\mathbf{D}_{ba} = \left[\begin{matrix}
    a_{11} & a_{12} & a_{13} \\
    a_{21} & a_{22} & a_{23} \\
    a_{31} & a_{32} & a_{33}
    \end{matrix}\right]
```

In **ReferenceFrameRotations.jl**, a DCM is a ``3 \times 3`` static matrix:

```julia
DCM{T} = SMatrix{3,3,T,9}
```

which means that `DCM` is immutable.

## Initialization

Usually, a DCM is initialized by converting a more "visual" rotation
representation, such as the Euler angles (see [Conversions](@ref)). However, it
can be initialized by the following methods:

* Identity DCM.

```jldoctest
julia> DCM(I)  # Create a Boolean DCM, this can be used to save space.
3×3 StaticArrays.SArray{Tuple{3,3},Bool,2,9}:
  true  false  false
 false   true  false
 false  false   true

julia> DCM(1I)  # Create an Integer DCM.
3×3 StaticArrays.SArray{Tuple{3,3},Int64,2,9}:
 1  0  0
 0  1  0
 0  0  1

julia> DCM(1.f0I) # Create a Float32 DCM.
3×3 StaticArrays.SArray{Tuple{3,3},Float32,2,9}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0

julia> DCM(1.0I)  # Create a Float64 DCM.
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0
```

* User-defined DCM.

```jldoctest
julia> DCM([-1 0 0; 0 -1 0; 0 0 1])
3×3 StaticArrays.SArray{Tuple{3,3},Int64,2,9}:
 -1   0  0
  0  -1  0
  0   0  1

julia> DCM([-1.f0 0.f0 0.f0; 0.f0 -1.f0 0.f0; 0.f0 0.f0 1.f0])
3×3 StaticArrays.SArray{Tuple{3,3},Float32,2,9}:
 -1.0   0.0  0.0
  0.0  -1.0  0.0
  0.0   0.0  1.0

julia> DCM([-1.0 0.0 0.0; 0.0 -1.0 0.0; 0.0 0.0 1.0])
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
 -1.0   0.0  0.0
  0.0  -1.0  0.0
  0.0   0.0  1.0
```

!!! note

    The type of the DCM will depend on the type of the input.

!!! warning

    This initialization method **will not** verify if the input data is indeed a
    DCM.

## Operations

Since a DCM is an Static Matrix (`SMatrix`), then all the operations available
for general matrices in Julia are also available for DCMs.

### Orthonomalization

A DCM can be orthonormalized using the Gram-Schmidt algorithm by the function:

```julia
function orthonormalize(dcm::DCM)
```

```jldoctest
julia> D = DCM([2 0 0; 0 2 0; 0 0 2]);

julia> orthonormalize(D)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0

julia> D = DCM(3.0f0I);

julia> orthonormalize(D)
3×3 StaticArrays.SArray{Tuple{3,3},Float32,2,9}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0

julia> D = DCM(1,1,2,2,3,3,4,4,5);

julia> Dn = orthonormalize(D)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
 0.408248   0.123091   0.904534
 0.408248   0.86164   -0.301511
 0.816497  -0.492366  -0.301511

julia> Dn*Dn'
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  1.0           5.55112e-17  -5.55112e-17
  5.55112e-17   1.0          -1.249e-16
 -5.55112e-17  -1.249e-16     1.0

```

!!! warning

    This function does not check if the columns of the input matrix span a
    three-dimensional space. If not, then the returned matrix should have `NaN`.
    Notice, however, that such input matrix is not a valid direction cosine
    matrix.
