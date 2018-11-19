Euler Angle and Axis
====================

```@meta
CurrentModule = ReferenceFrameRotations
DocTestSetup = quote
    using ReferenceFrameRotations
end
```

The Euler angle and axis representation is defined by the following immutable
structure:

```julia
struct EulerAngleAxis{T}
    a::T
    v::SVector{3,T}
end
```

in which `a` is the Euler Angle and `v` is a unitary vector aligned with the
Euler axis.

The constructor for this structure is:

```julia
function EulerAngleAxis(a::T1, v::AbstractVector{T2}) where {T1,T2}
```

in which a `EulerAngleAxis` with angle `a` [rad] and vector `v` will be created.
Notice that the type of the returned structure will be selected according to the
input types `T1` and `T2`. Furthermore, the vector `v` **will not** be
normalized.

```jldoctest
julia> EulerAngleAxis(1,[1,1,1])
EulerAngleAxis{Int64}:
  Euler angle:   1.0000 rad ( 57.2958 deg)
   Euler axis: [  1.0000,   1.0000,   1.0000]

julia> EulerAngleAxis(1.f0,[1,1,1])
EulerAngleAxis{Float32}:
  Euler angle:   1.0000 rad ( 57.2958 deg)
   Euler axis: [  1.0000,   1.0000,   1.0000]

julia> EulerAngleAxis(1,[1,1,1.f0])
EulerAngleAxis{Float32}:
  Euler angle:   1.0000 rad ( 57.2958 deg)
   Euler axis: [  1.0000,   1.0000,   1.0000]

julia> EulerAngleAxis(1.0,[1,1,1])
EulerAngleAxis{Float64}:
  Euler angle:   1.0000 rad ( 57.2958 deg)
   Euler axis: [  1.0000,   1.0000,   1.0000]

```

## Operations

### Multiplication

The multiplication of two Euler angle and axis sets is defined here as the
composition of the rotations. Let ``\Theta_1`` and ``\Theta_2`` be two Euler
angle and axis sets (instances of the structure `EulerAngleAxis`).  Thus, the
operation:

```math
\Theta_{2,1} = \Theta_2 \cdot \Theta_1
```

will return a new set of Euler angle and axis ``\Theta_{2,1}`` that represents
the composed rotation of ``\Theta_1`` followed by ``\Theta_2``. By convention,
the Euler angle of the result will always be in the interval ``[0, \pi]`` rad.

!!! warning

    This operation is only valid if the vector of the Euler angle and axis set
    is unitary. The multiplication function does not verify this and does not
    normalize the vector.

```jldoctest
julia> ea1 = EulerAngleAxis(30*pi/180, [1.0;0.0;0.0])
EulerAngleAxis{Float64}:
  Euler angle:   0.5236 rad ( 30.0000 deg)
   Euler axis: [  1.0000,   0.0000,   0.0000]

julia> ea2 = EulerAngleAxis(60*pi/180, [1.0;0.0;0.0])
EulerAngleAxis{Float64}:
  Euler angle:   1.0472 rad ( 60.0000 deg)
   Euler axis: [  1.0000,   0.0000,   0.0000]

julia> ea2*ea1
EulerAngleAxis{Float64}:
  Euler angle:   1.5708 rad ( 90.0000 deg)
   Euler axis: [  1.0000,   0.0000,   0.0000]

```

### Inversion

The `inv` function applied to Euler angle and axis will return the inverse
rotation. Hence, if the Euler angle is `a` and the Euler axis is aligned with
the unitary vector `v`, then it will return `a` as the Euler angle and `-v` as
the Euler axis. By convention, the Euler angle of the result will always be in
the interval ``[0, \pi]`` rad.

```jldoctest
julia> ea = EulerAngleAxis(1.3,[1.0,0,0]);

julia> inv(ea)
EulerAngleAxis{Float64}:
  Euler angle:   1.3000 rad ( 74.4845 deg)
   Euler axis: [ -1.0000,  -0.0000,  -0.0000]

julia> ea = EulerAngleAxis(-π,[sqrt(3),sqrt(3),sqrt(3)]);

julia> inv(ea)
EulerAngleAxis{Float64}:
  Euler angle:   3.1416 rad (180.0000 deg)
   Euler axis: [ -1.7321,  -1.7321,  -1.7321]

julia> ea = EulerAngleAxis(-3π/2,[sqrt(3),sqrt(3),sqrt(3)]);

julia> inv(ea)
EulerAngleAxis{Float64}:
  Euler angle:   1.5708 rad ( 90.0000 deg)
   Euler axis: [ -1.7321,  -1.7321,  -1.7321]

```
