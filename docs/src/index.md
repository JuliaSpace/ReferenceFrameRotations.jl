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

## Requirements

* Julia >= 0.7
* StaticArrays >= 0.8.3

## Installation

This package can be installed using:

```julia-repl
julia> Pkg.update()
julia> Pkg.add("ReferenceFrameRotations")
```

## Status

This packages supports the following representations of 3D rotations:

* **Euler Angle and Axis** (INCOMPLETE);
* **Euler Angles**;
* **Direction Cosine Matrices (DCMs)**;
* **Quaternions**.

However, composing rotations is only currently supported for DCMs and
Quaternions.

Furthermore, the following conversions between the representations are
available:

* **Direction Cosine Matrices** to **Euler Angles**;
* **Direction Cosine Matrices** to **Quaternions**;
* **Euler Angle and Axis** to **Quaternions**;
* **Euler Angles** to **Direction Cosine Matrices**;
* **Euler Angles** to **Quaternions**;
* **Small Euler Angles** to **Direction Cosine Matrices**;
* **Small Euler Angles** to **Quaternions**;
* **Quaternions** to **Direction Cosine Matrices**;
* **Quaternions** to **Euler Angle and Axis**;
* **Quaternions** to **Euler Angles**.

## Roadmap

This package will be continuously enhanced. Next steps will be to add other
representations of 3D rotations such as Euler angle and axis (initial support is
already available), Rodrigues parameters, etc.

## Manual outline

```@contents
Pages = [
    "man/dcm.md",
    "man/euler_angle_axis.md",
    "man/euler_angles.md",
    "man/quaternions.md",
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
