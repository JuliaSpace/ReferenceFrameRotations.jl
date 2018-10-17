Quaternion
==========

```@meta
CurrentModule = ReferenceFrameRotations
DocTestSetup = quote
    using ReferenceFrameRotations
end
```

Quaternions are hypercomplex number with 4 dimensions that can be used to
represent 3D rotations. In this package, a quaternion ``\mathbf{q}`` is
represented by

```math
\mathbf{q} = \overbrace{q_0}^{\mbox{Real part}} + \underbrace{q_1 \cdot \mathbf{i} + q_2 \cdot \mathbf{j} + q_3 \cdot \mathbf{k}}_{\mbox{Vectorial or imaginary part}} = r + \mathbf{v}
```

using the following immutable structure:

```julia
struct Quaternion{T}
    q0::T
    q1::T
    q2::T
    q3::T
end
```

## Initialization

There are several ways to create a quaternion.

* Provide all the elements:
```jldoctest
julia> q = Quaternion(1.0, 0.0, 0.0, 0.0)
Quaternion{Float64}:
  + 1.0 + 0.0.i + 0.0.j + 0.0.k
```

* Provide the real and imaginary parts as separated numbers:

```jldoctest
julia> r = sqrt(2)/2;

julia> v = [sqrt(2)/2; 0; 0];

julia> q = Quaternion(r,v)
Quaternion{Float64}:
  + 0.7071067811865476 + 0.7071067811865476.i + 0.0.j + 0.0.k
```

* Provide the real and imaginary parts as one single vector:

```jldoctest
julia> v = [1.;2.;3.;4.];

julia> q = Quaternion(v)
Quaternion{Float64}:
  + 1.0 + 2.0.i + 3.0.j + 4.0.k
```

* Provide just the imaginary part, in this case the real part will be 0:

```jldoctest
julia> v = [1.;0.;0.];

julia> q = Quaternion(v)
Quaternion{Float64}:
  + 0.0 + 1.0.i + 0.0.j + 0.0.k
```

* Create an identity quaternion:

```jldoctest
julia> q = Quaternion{Float64}(I)  # Creates an identity quaternion of type `Float64`.
Quaternion{Float64}:
  + 1.0 + 0.0.i + 0.0.j + 0.0.k

julia> q = Quaternion(1.0I)  # Creates an identity quaternion of type `Float64`.
Quaternion{Float64}:
  + 1.0 + 0.0.i + 0.0.j + 0.0.k

julia> q = Quaternion{Float32}(I)  # Creates an identity quaternion of type `Float32`.
Quaternion{Float32}:
  + 1.0 + 0.0.i + 0.0.j + 0.0.k

julia> q = Quaternion(1.0f0I)  # Creates an identity quaternion of type `Float32`.
Quaternion{Float32}:
  + 1.0 + 0.0.i + 0.0.j + 0.0.k

julia> a = Quaternion(I,q)  # Creates an identity quaternion with the same type of `q`.
Quaternion{Float32}:
  + 1.0 + 0.0.i + 0.0.j + 0.0.k

julia> q = Quaternion(I)
Quaternion{Bool}:
  + true + false.i + false.j + false.k
```

* Create a zero quaternion using the `zeros` function:

```jldoctest
julia> q = zeros(Quaternion)  # Creates a zero quaternion of type `Float64`.
Quaternion{Float64}:
  + 0.0 + 0.0.i + 0.0.j + 0.0.k

julia> q = zeros(Quaternion{Float32})  # Creates a zero quaternion of type `Float32`.
Quaternion{Float32}:
  + 0.0 + 0.0.i + 0.0.j + 0.0.k

julia> a = zeros(q)  # Creates a zero quaternion with the same type of `q`.
Quaternion{Float32}:
  + 0.0 + 0.0.i + 0.0.j + 0.0.k
```

!!! note

    Individual elements of the quaternion can be accessed by:

    ```julia
    q.q0
    q.q1
    q.q2
    q.q3
    ```

!!! warning

    Since the type `Quaternion` is **immutable**, its components cannot
    be changed individually after the creation. Hence, the following operation
    will lead to an error:

    ```julia
    q.q0 = 1.0  # This is not defined and will not work.
    ```

    If you want to modify a single value for the quaternion, then you need to
    create another one:

    ```julia
    q = Quaternion(1.0, q.q1, q.q2, q.q3)
    ```

    This can be annoying sometimes, but using an immutable type provided a huge
    performance boost for the algorithm.

## Operations

### Sum, subtraction, and scalar multiplication

The sum between quaternions, the subtraction between quaternions, and the
multiplication between a quaternion and a scalar are defined as usual:

```math
\begin{aligned}
  \mathbf{q}_a + \mathbf{q}_b &= (q_{a,0} + q_{b,0}) +
                                 (q_{a,1} + q_{b,1}) \cdot \mathbf{i} +
                                 (q_{a,2} + q_{b,2}) \cdot \mathbf{j} +
                                 (q_{a,3} + q_{b,3}) \cdot \mathbf{k} \\
  \mathbf{q}_a - \mathbf{q}_b &= (q_{a,0} - q_{b,0}) +
                                 (q_{a,1} - q_{b,1}) \cdot \mathbf{i} +
                                 (q_{a,2} - q_{b,2}) \cdot \mathbf{j} +
                                 (q_{a,3} - q_{b,3}) \cdot \mathbf{k} \\
  \lambda \cdot \mathbf{q} &= (\lambda \cdot q_0) +
                              (\lambda \cdot q_1) \cdot \mathbf{i} +
                              (\lambda \cdot q_2) \cdot \mathbf{j} +
                              (\lambda \cdot q_3) \cdot \mathbf{k}
\end{aligned}
```

```jldoctest
julia> q1 = Quaternion(1.0,1.0,0.0,0.0);

julia> q2 = Quaternion(1.0,2.0,3.0,4.0);

julia> q1+q2
Quaternion{Float64}:
  + 2.0 + 3.0.i + 3.0.j + 4.0.k

julia> q1-q2
Quaternion{Float64}:
  + 0.0 - 1.0.i - 3.0.j - 4.0.k

julia> q1 = Quaternion(1.0,2.0,3.0,4.0);

julia> q1*3
Quaternion{Float64}:
  + 3.0 + 6.0.i + 9.0.j + 12.0.k

julia> 4*q1
Quaternion{Float64}:
  + 4.0 + 8.0.i + 12.0.j + 16.0.k

julia> 5q1
Quaternion{Float64}:
  + 5.0 + 10.0.i + 15.0.j + 20.0.k
```

### Multiplication between quaternions

The multiplication between quaternions is defined using the Hamilton product:

```math
\begin{aligned}
  \mathbf{q}_1 &= r_1 + \mathbf{v}_1~, \\
  \mathbf{q}_2 &= r_2 + \mathbf{v}_2~, \\
  \mathbf{q}_1 \cdot \mathbf{q}_2 &= r_1 \cdot r_2 -
                                     \mathbf{v}_1 \cdot \mathbf{v}_2 +
                                     r_1 \cdot \mathbf{v}_2 +
                                     r_2 \cdot \mathbf{v}_1 +
                                     \mathbf{v}_1 \times \mathbf{v}_2~.
\end{aligned}
```

```jldoctest
julia> q1 = Quaternion(cosd(15), sind(15), 0.0, 0.0);

julia> q2 = Quaternion(cosd(30), sind(30), 0.0, 0.0);

julia> q1*q2
Quaternion{Float64}:
  + 0.7071067811865475 + 0.7071067811865475.i + 0.0.j + 0.0.k
```

If a quaternion ``\mathbf{q}`` is multiplied by a vector ``\mathbf{v}``, then
the vector is converted to a quaternion with real part 0, ``\mathbf{q}_v =
0 + \mathbf{v}``, and the quaternion multiplication is performed as usual:

```math
\begin{aligned}
\mathbf{q}   &= r + \mathbf{w}~, \\
\mathbf{q}_v &= 0 + \mathbf{v}~, \\
\mathbf{q} \cdot \mathbf{v} \triangleq \mathbf{q} \cdot \mathbf{q}_v &= - \mathbf{w} \cdot \mathbf{v} + r \cdot \mathbf{v} + \mathbf{w} \times \mathbf{v}~, \\
\mathbf{v} \cdot \mathbf{q} \triangleq \mathbf{q}_v \cdot \mathbf{q} &= - \mathbf{v} \cdot \mathbf{w} + r \cdot \mathbf{v} + \mathbf{v} \times \mathbf{w}~.
\end{aligned}
```

```jldoctest
julia> q1 = Quaternion(cosd(22.5), sind(22.5), 0.0, 0.0);

julia> v  = [0;1;0];

julia> v*q1
Quaternion{Float64}:
  + 0.0 + 0.0.i + 0.9238795325112867.j - 0.3826834323650898.k

julia> q1*v
Quaternion{Float64}:
  + 0.0 + 0.0.i + 0.9238795325112867.j + 0.3826834323650898.k
```

### Division between quaternions

Given this definition of the product between two quaternions, we can define the
multiplicative inverse of a quaternion by:

```math
\mathbf{q}^{-1} \triangleq \frac{\bar{\mathbf{q}}}{|\mathbf{q}|^2} =
  \frac{q_0 - q_1 \cdot \mathbf{i} - q_2 \cdot \mathbf{j} - q_3 \cdot \mathbf{k}}
       {q_0^2 + q_1^2 + q_2^2 + q_3^2}
```

Notice that, in this case, one gets:

```math
\mathbf{q} \cdot \mathbf{q}^{-1} = 1
```

!!! note

    ``\bar{\mathbf{q}}``, which is the quaternion conjugate, can be computed
    using `conj(q)`.

    ``|\mathbf{q}|``, which is the quaternion norm, can be computed using
    `norm(q)`.

    The quaternion inverse can be computed using `inv(q)`.

!!! warning

    The exponentiation operator is not defined for quaternions. Hence, `q^(-1)`
    or `q^2` will throw an error.

The right division (`/`) between two quaternions ``\mathbf{q}_1`` and
``\mathbf{q}_2`` is defined as the following Hamilton product:

```math
\mathbf{q}_1~/~\mathbf{q}_2 = \mathbf{q}_1 \cdot \mathbf{q}_2^{-1}~.
```

The left division (`\`) between two quaternions ``\mathbf{q}_1`` and
``\mathbf{q}_2`` is defined as the following Hamilton product:

```math
\mathbf{q}_1~\backslash~\mathbf{q}_2 = \mathbf{q}_1^{-1} \cdot \mathbf{q}_2~.
```

```jldoctest
julia> q1 = Quaternion(cosd(45+22.5), sind(45+22.5), 0.0, 0.0);

julia> q2 = Quaternion(cosd(22.5), sind(22.5), 0.0, 0.0);

julia> q1/q2
Quaternion{Float64}:
  + 0.7071067811865476 + 0.7071067811865475.i + 0.0.j + 0.0.k

julia> q1\q2
Quaternion{Float64}:
  + 0.7071067811865476 - 0.7071067811865475.i + 0.0.j + 0.0.k

julia> q1\q2*q1/q2
Quaternion{Float64}:
  + 1.0 + 5.551115123125783e-17.i + 0.0.j + 0.0.k
```

If a division operation (right-division or left-division) is performed between a
vector ``\mathbf{v}`` and a quaternion, then the vector ``\mathbf{v}`` is
converted to a quaternion real part 0, ``\mathbf{q}_v = 0 + \mathbf{v}``, and
the division operation is performed as defined earlier.

```math
\begin{aligned}
  \mathbf{v}~/~\mathbf{q}          &\triangleq \mathbf{q}_v      \cdot \mathbf{q}^{-1}   \\
  \mathbf{v}~\backslash~\mathbf{q} &\triangleq \mathbf{q}_v^{-1} \cdot \mathbf{q}        \\
  \mathbf{q}~/~\mathbf{v}          &\triangleq \mathbf{q}        \cdot \mathbf{q}_v^{-1} \\
  \mathbf{q}~\backslash~\mathbf{v} &\triangleq \mathbf{q}^{-1}   \cdot \mathbf{q}_v
\end{aligned}
```

```jldoctest
julia> q1 = Quaternion(cosd(22.5), sind(22.5), 0.0, 0.0);

julia> v  = [0;1;0];

julia> q1\v
Quaternion{Float64}:
  + 0.0 + 0.0.i + 0.9238795325112867.j - 0.3826834323650898.k

julia> v\q1
Quaternion{Float64}:
  + 0.0 + 0.0.i - 0.9238795325112867.j + 0.3826834323650898.k

```

### Other operations

There are also the following functions available:

```jldoctest
julia> q = Quaternion(1.0,2.0,3.0,4.0);

julia> conj(q)  # Returns the complex conjugate of the quaternion.
Quaternion{Float64}:
  + 1.0 - 2.0.i - 3.0.j - 4.0.k

julia> copy(q)  # Creates a copy of the quaternion.
Quaternion{Float64}:
  + 1.0 + 2.0.i + 3.0.j + 4.0.k

julia> inv(q)   # Computes the multiplicative inverse of the quaternion.
Quaternion{Float64}:
  + 0.03333333333333333 - 0.06666666666666667.i - 0.1.j - 0.13333333333333333.k

julia> inv(q)*q
Quaternion{Float64}:
  + 1.0 + 0.0.i + 5.551115123125783e-17.j + 0.0.k

julia> imag(q)  # Returns the vectorial / imaginary part of the quaternion.
3-element StaticArrays.SArray{Tuple{3},Float64,1,3}:
 2.0
 3.0
 4.0

julia> norm(q)  # Computes the norm of the quaternion.
5.477225575051661

julia> real(q)  # Returns the real part of the quaternion.
1.0

julia> vect(q)  # Returns the vectorial / imaginary part of the quaternion.
3-element StaticArrays.SArray{Tuple{3},Float64,1,3}:
 2.0
 3.0
 4.0
```

!!! note

    The operation `a/q` is equal to `a*inv(q)` if `a` is a scalar.

### Converting reference frames using quaternions

Given the reference frames **A** and **B**, let ``\mathbf{w}`` be a unitary
vector in which a rotation about it of an angle ``\theta`` aligns the reference
frame **A** with the reference frame **B** (in this case, ``\mathbf{w}`` is
aligned with the Euler Axis and ``\theta`` is the Euler angle). Construct the
following quaternion:

```math
\mathbf{q}_{ba} = cos\left(\frac{\theta}{2}\right) + sin\left(\frac{\theta}{2}\right) \cdot \mathbf{w}~.
```

Then, a vector ``\mathbf{v}`` represented in reference frame **A**
(``\mathbf{v}_a``) can be represented in reference frame **B** using:

```math
\mathbf{v}_b = \texttt{vect}\left(\mathbf{q}_{ba}^{-1} \cdot \mathbf{v}_a \cdot \mathbf{q}_{ba}\right)~.
```

Hence:

```julia
julia> qBA = Quaternion(cosd(22.5), sind(22.5), 0.0, 0.0);

julia> vA  = [0;1;0];

julia> vB  = vect(qBA\vA*qBA); # Equivalent to: vect(inv(qBA)*vA*qBA);

julia> vB
3-element StaticArrays.SArray{Tuple{3},Float64,1,3}:
  0.0
  0.707107
 -0.707107
```

!!! note

    A `SArray` is returned instead of the usual `Array`. This is a static vector
    created by the package
    [**StaticArrays**](https://github.com/JuliaArrays/StaticArrays.jl).
    Generally, you can treat this vector as any other one. The only downside is
    that you cannot modify individual components because it is immutable.

