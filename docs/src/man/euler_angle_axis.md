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

in which a `EulerAngleAxis` with angle `a [rad]` and vector `v` will be created.
Notice that the type of the returned structure will be selected according to the
input types `T1` and `T2`. Furthermore, the vector `v` **will not** be
normalized.

```jldoctest
julia> EulerAngleAxis(1,[1,1,1])
EulerAngleAxis{Int64}(1, [1, 1, 1])

julia> EulerAngleAxis(1.f0,[1,1,1])
EulerAngleAxis{Float32}(1.0f0, Float32[1.0, 1.0, 1.0])

julia> EulerAngleAxis(1,[1,1,1.f0])
EulerAngleAxis{Float32}(1.0f0, Float32[1.0, 1.0, 1.0])

julia> EulerAngleAxis(1.0,[1,1,1])
EulerAngleAxis{Float64}(1.0, [1.0, 1.0, 1.0])
```

!!! note

    The support of this representation is still incomplete. Only the conversion
    to and from quaternions are implemented. Furthermore, there is no support
    for operations using Euler angles and axes.

