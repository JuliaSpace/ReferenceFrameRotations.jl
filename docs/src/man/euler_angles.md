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
struct EulerAngles{T<:Real}
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

!!! note

    In the current version, there is no support for operations using Euler
    Angles.
