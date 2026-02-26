ReferenceFrameRotations.jl
==========================

```@meta
CurrentModule = ReferenceFrameRotations
DocTestSetup = quote
    using ReferenceFrameRotations
end
```

This module contains functions related to 3D rotations of reference frames. It
is used on a daily basis on projects at the [Brazilian National Institute for
Space Research (INPE)](http://www.inpe.br).

## Installation

This package can be installed using:

```julia-repl
julia> Pkg.update()
julia> Pkg.add("ReferenceFrameRotations")
```

## Status

This packages supports the following representations of 3D rotations:

* **Classical Rodrigues Parameters (CRP)**;
* **Direction Cosine Matrices (DCMs)**;
* **Euler Angle and Axis**;
* **Euler Angles**;
* **Modified Rodrigues Parameters (MRP)**; and
* **Quaternions**.

All of those representations support rotation composition and inversion in this package.

## Roadmap

This package will be continuously enhanced. Next steps will include API improvements,
performance optimizations, and additional utilities for supported representations.

## Manual outline

```@contents
Pages = [
    "man/dcm.md",
    "man/euler_angle_axis.md",
    "man/euler_angles.md",
    "man/quaternions.md",
    "man/crp.md",
    "man/mrp.md",
    "man/conversions.md",
    "man/kinematics.md",
    "man/composing_rotations.md",
    "man/inv_rotations.md",
]
Depth = 2
```

## Library documentation

```@index
Pages = ["lib/library.md"]
```
