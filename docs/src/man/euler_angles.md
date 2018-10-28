Euler Angles
============

```@meta
CurrentModule = ReferenceFrameRotations
DocTestSetup = quote
    using ReferenceFrameRotations
end
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

in which `a1`, `a2`, and `a3` define the angles and the `rot_seq` is a symbol
that defines the axes. The valid values for `rot_seq` are:

* `:XYX`, `:XYZ`, `:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`,
  `:ZXZ`, `:ZYX`, and `ZYZ`.

## Operations

### Multiplication

The multiplication of two Euler angles is defined here as the composition of the
rotations. Let ``\Theta_1`` and ``\Theta_2`` be two sequences of Euler angles
(instances of the structure `EulerAngles`). Thus, the operation:

```math
\Theta_{2,1} = \Theta_2 \cdot \Theta_1
```

will return a new set of Euler angles ``\Theta_{2,1}`` that represents the
composed rotation of ``\Theta_1`` followed by ``\Theta_2``. Notice that
``\Theta_{2,1}`` will be represented using the same rotation sequence as
``\Theta_2``.

```jldoctest
julia> a1 = EulerAngles(1,0,0,:ZYX);

julia> a2 = EulerAngles(0,-1,0,:YZY);

julia> a2*a1
EulerAngles{Float64}(0.0, 0.0, 0.0, :YZY)

julia> a1 = EulerAngles(1,1,1,:YZY);

julia> a2 = EulerAngles(0,0,-1,:YZY);

julia> a2*a1
EulerAngles{Float64}(1.0, 0.9999999999999998, 1.3193836087867184e-16, :YZY)

julia> a1 = EulerAngles(1.3,2.2,1.4,:XYZ);

julia> a2 = EulerAngles(-1.4,-2.2,-1.3,:ZYX);

julia> a2*a1
EulerAngles{Float64}(-8.326672684688677e-17, 3.3306690738754696e-16, -1.1102230246251568e-16, :ZYX)
```

### Inversion

The `inv` function applied to Euler angles will return the inverse rotation. If
the Euler angles ``\Theta`` represent a rotation through the axes ``a_1``,
``a_2``, and ``a_3`` by angles ``\alpha_1``, ``\alpha_2``, and ``\alpha_3``,
then ``\Theta^{-1}`` is a rotation through the axes ``a_3``, ``a_2``, and
``a_1`` by angles ``-\alpha_3``, ``-\alpha_2``, and ``-\alpha_1``.

```jldoctest
julia> a = EulerAngles(1,2,3,:ZYX);

julia> inv(a)
EulerAngles{Int64}(-3, -2, -1, :XYZ)

julia> a = EulerAngles(1.2,3.3,4.6,:XYX);

julia> a*inv(a)
EulerAngles{Float64}(-1.925929944387236e-34, 0.0, 0.0, :XYX)
```

!!! warning

    All the operations related to Euler angles first convert them to DCM or
    Quaternions, and then the result is converted back to Euler angles. Hence,
    the performance will not be good.
