# Rotations

[![Build Status](https://travis-ci.org/ronisbr/Rotations.jl.svg?branch=master)](https://travis-ci.org/ronisbr/Rotations.jl)
[![Coverage Status](https://coveralls.io/repos/github/ronisbr/Rotations.jl/badge.svg?branch=master)](https://coveralls.io/github/ronisbr/Rotations.jl?branch=master)

This module contains functions related to rotations of coordinate frames.

Requirements
------------

* Julia >= v0.6

Status
------

This packages supports the following representations of rotations:

* **Euler Angles**;
* **Direction Cosine Matrices**;
* **Quaternions**.

Furthermore, the following conversions between representations are available:

* **Direction Cosine Matrices** to **Euler Angles**;
* **Direction Cosine Matrices** to **Quaternions**;
* **Euler Angles** to **Direction Cosine Matrices**;
* **Quaternions** to **Direction Cosine Matrices**;
* **Quaternions** to **Euler Angles**.

The functions were constructed to match the syntax provided by the ones in
Mathworks® Matlab. The set of functions currently available are:

    angle2dcm, angle2dcm!
    dcm2angle
    dcm2quat, dcm2quat!
    quat2dcm, quat2dcm!
    quat2angle

Roadmap
-------

A roadmap is not defined yet, but I expect to add many functions related to 3D
rotations using Quaternions, Euler axes, Rodrigues parameters, etc.
