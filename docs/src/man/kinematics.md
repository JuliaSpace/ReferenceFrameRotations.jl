# Kinematics

```@meta
CurrentModule = ReferenceFrameRotations
```

```@setup kinematics
using ReferenceFrameRotations
```

Currently, only the kinematics of Direction Cosine Matrices and Quaternions are implemented.

## Direction Cosine Matrices

Let **A** and **B** be two reference frames in which the angular velocity of **B** with
respect to **A**, and represented in **B**, is given by

```math
\boldsymbol{\omega}_{ba,b} = \left[\begin{array}{c}
    \omega_{ba,b,x} \\
    \omega_{ba,b,y} \\
    \omega_{ba,b,z}
\end{array}\right]\ .
```

If ``\mathbf{D}_{b}^{a}`` is the DCM that rotates the reference frame **A** into alignment
with the reference frame **B**, then its time-derivative is

```math
\dot{\mathbf{D}}_{b}^{a} = -\left[\begin{array}{ccc}
           0         & -\omega_{ba,b,z} & +\omega_{ba,b,y} \\
    +\omega_{ba,b,z} &        0         & -\omega_{ba,b,x} \\
    -\omega_{ba,b,y} & +\omega_{ba,b,x} &        0
\end{array}\right] \cdot \mathbf{D}_{b}^{a}\ .
```

In this package, the time-derivative of this DCM can be computed using the function:

```julia
function ddcm(Dba, wba_b)
```

```@repl kinematics
wba_b = [0.01, 0, 0]

Dba = angle_to_dcm(0.5, 0, 0, :XYZ)

ddcm(Dba, wba_b)
```

## Quaternions

Let **A** and **B** be two reference frames in which the angular velocity of **B** with
respect to **A**, and represented in **B**, is given by

```math
\boldsymbol{\omega}_{ba,b} = \left[\begin{array}{c}
    \omega_{ba,b,x} \\
    \omega_{ba,b,y} \\
    \omega_{ba,b,z}
\end{array}\right]\ .
```

If ``\mathbf{q}_{ba}`` is the quaternion that rotates the reference frame **A**
into alignment with the reference frame **B**, then its time-derivative is

```math
\dot{\mathbf{q}}_{ba} = \frac{1}{2} \cdot \left[\begin{array}{cccc}
           0         &  -\omega_{ba,b,x} &  -\omega_{ba,b,y} & -\omega_{ba,b,z} \\
    +\omega_{ba,b,x} &         0         &  +\omega_{ba,b,z} & -\omega_{ba,b,y} \\
    +\omega_{ba,b,y} &  -\omega_{ba,b,z} &         0         & +\omega_{ba,b,x} \\
    +\omega_{ba,b,z} &  +\omega_{ba,b,y} &  -\omega_{ba,b,x} &        0
\end{array}\right] \cdot \mathbf{q}_{ba}\ .
```

In this package, the time-derivative of this quaternion can be computed using the function:

```julia
function dquat(qba, wba_b)
```

```@repl kinematics
wba_b = [0.01, 0, 0]

qba = angle_to_quat(0.5, 0, 0, :XYZ)

dquat(qba, wba_b)
```
