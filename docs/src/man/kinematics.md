# Kinematics

```@meta
CurrentModule = ReferenceFrameRotations
```

```@setup kinematics
using ReferenceFrameRotations
```

Currently, the kinematics of Direction Cosine Matrices, Quaternions, Classical Rodrigues
Parameters (CRP), and Modified Rodrigues Parameters (MRP) are implemented.

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

## Classical Rodrigues Parameters (CRP)

Let **A** and **B** be two reference frames in which the angular velocity of **B** with
respect to **A**, and represented in **B**, is given by

```math
\boldsymbol{\omega}_{ba,b} = \left[\begin{array}{c}
    \omega_{ba,b,x} \\
    \omega_{ba,b,y} \\
    \omega_{ba,b,z}
\end{array}\right]\ .
```

If ``\mathbf{c}_{ba}`` is the CRP that rotates the reference frame **A** into alignment
with the reference frame **B**, then its time-derivative is

```math
\dot{\mathbf{c}}_{ba} = \frac{
    \boldsymbol{\omega}_{ba,b} +
    \mathbf{c}_{ba} \times \boldsymbol{\omega}_{ba,b} +
    (\mathbf{c}_{ba} \cdot \boldsymbol{\omega}_{ba,b}) \mathbf{c}_{ba}
}{2}\ .
```

In this package, the time-derivative of this CRP can be computed using the function:

```julia
function dcrp(cba, wba_b)
```

```@repl kinematics
wba_b = [0.01, 0.0, -0.02]

cba = angle_to_crp(0.5, 0.1, -0.2, :XYZ)

dcrp(cba, wba_b)
```

## Modified Rodrigues Parameters (MRP)

Let **A** and **B** be two reference frames in which the angular velocity of **B** with
respect to **A**, and represented in **B**, is given by

```math
\boldsymbol{\omega}_{ba,b} = \left[\begin{array}{c}
    \omega_{ba,b,x} \\
    \omega_{ba,b,y} \\
    \omega_{ba,b,z}
\end{array}\right]\ .
```

If ``\mathbf{m}_{ba}`` is the MRP that rotates the reference frame **A** into alignment
with the reference frame **B**, then its time-derivative is

```math
\dot{\mathbf{m}}_{ba} = \frac{
    (1 - \|\mathbf{m}_{ba}\|^2)\boldsymbol{\omega}_{ba,b} +
    2(\mathbf{m}_{ba} \times \boldsymbol{\omega}_{ba,b}) +
    2(\mathbf{m}_{ba} \cdot \boldsymbol{\omega}_{ba,b})\mathbf{m}_{ba}
}{4}\ .
```

In this package, the time-derivative of this MRP can be computed using the function:

```julia
function dmrp(mba, wba_b)
```

```@repl kinematics
wba_b = [0.01, 0.0, -0.02]

mba = angle_to_mrp(0.5, 0.1, -0.2, :XYZ)

dmrp(mba, wba_b)
```
