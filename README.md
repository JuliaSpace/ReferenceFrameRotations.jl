# ReferenceFrameRotations

[![Build Status](https://travis-ci.org/ronisbr/ReferenceFrameRotations.jl.svg?branch=master)](https://travis-ci.org/ronisbr/ReferenceFrameRotations.jl)
[![Coverage Status](https://coveralls.io/repos/github/ronisbr/ReferenceFrameRotations.jl/badge.svg?branch=master)](https://coveralls.io/github/ronisbr/ReferenceFrameRotations.jl?branch=master)

This module contains functions related to the representation of 3D rotations of
reference frames. It is used on a daily basis on projects at the [Brazilian
National Institute for Space Research (INPE)](http://www.inpe.br).

## Requirements

* Julia >= v0.6

## Status

This packages supports the following representations of 3D rotations:

* **Euler Angle and Axis** (INCOMPLETE);
* **Euler Angles**;
* **Direction Cosine Matrices (DCMs)**;
* **Quaternions**.

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

## Euler Angle and Axis

The Euler angle and axis representation is defined by the following mutable
structure:

```julia
mutable struct EulerAngleAxis{T<:Real}
    a::T
    v::Vector{T}
end
```

in which `a` is the Euler Angle and `v` is a unitary vector aligned with the
Euler axis.

**NOTE**: The support of this representation is still incomplete. Only the
conversion to and from quaternions are implemented. Furthermore, there is no
support for operations using Euler angles and axes.

## Euler Angles

The Euler Angles are defined by the following mutable structure:

```julia
mutable struct EulerAngles{T<:Real}
    a1::T
    a2::T
    a3::T
    rot_seq::AbstractString
end
```

in which `a1`, `a2`, and `a3` define the angles and the `rot_seq` contains a
string defining the axes. The valid values for `rot_seq` are:

* `XYX`, `XYZ`, `XZX`, `XZY`, `YXY`, `YXZ`, `YZX`, `YZY`, `ZXY`, `ZXZ`, `ZYX`, and
`ZYZ`.

## Quaternions

There are several ways to create a quaternion:

1. Provide all the elements:

```julia
q = Quaternion(1.0, 0.0, 0.0, 0.0)

    Quaternion{Float64}:
      + 1.0 + 0.0.i + 0.0.j + 0.0.k
```

2. Provide the real and imaginary parts as separated numbers:

```julia
r = sqrt(2)/2
v = [sqrt(2)/2; 0; 0]
q = Quaternion(r,v)

    Quaternion{Float64}:
      + 0.7071067811865476 + 0.7071067811865476.i + 0.0.j + 0.0.k
```

3. Provide the real and imaginary parts as one single vector:

```julia
v = [1.;2.;3.;4.]
q = Quaternion(v)

    Quaternion{Float64}:
      + 1.0 + 2.0.i + 3.0.j + 4.0.k
```

4. Provide just the imaginary part, in this case the real part will be 0:

```julia
v = [1.;0.;0.]
q = Quaternion(v)

    Quaternion{Float64}:
      + 0.0 + 1.0.i + 0.0.j + 0.0.k
```

5. Create an identity quaternion using the `eye` function:

```julia
q = eye(Quaternion)  # Creates an identity quaternion of type `Float64`.

    Quaternion{Float64}:
      + 1.0 + 0.0.i + 0.0.j + 0.0.k

q = eye(Quaternion{Float32})  # Creates an identity quaternion of type `Float32`.

    Quaternion{Float32}:
      + 1.0 + 0.0.i + 0.0.j + 0.0.k

a = eye(q)  # Creates an identity quaternion with the same type of `q`.

    Quaternion{Float32}:
      + 1.0 + 0.0.i + 0.0.j + 0.0.k
```

6. Create a zero quaternion using the `zeros` function:

```julia
q = zeros(Quaternion)  # Creates a zero quaternion of type `Float64`.

    Quaternion{Float64}:
      + 0.0 + 0.0.i + 0.0.j + 0.0.k

q = zeros(Quaternion{Float32})  # Creates a zero quaternion of type `Float32`.

    Quaternion{Float32}:
      + 0.0 + 0.0.i + 0.0.j + 0.0.k

a = zeros(q)  # Creates a zero quaternion with the same type of `q`.

    Quaternion{Float32}:
      + 0.0 + 0.0.i + 0.0.j + 0.0.k
```

Note that the individual elements of the quaternion can be accessed by:

```julia
q.q0
q.q1
q.q2
q.q3
```

in which:

    q = q.q0 + (q.q1).i + (q.q2).j + (q.q3).k

### Operations

The sum operations between quaternions and the multiplication between a
quaternion and a scalar are defined as usual:

```julia
q1 = Quaternion(1.0,1.0,0.0,0.0)
q2 = Quaternion(1.0,2.0,3.0,4.0)
q1+q2

    Quaternion{Float64}:
      + 2.0 + 3.0.i + 3.0.j + 4.0.k
```

```julia
q1 = Quaternion(1.0,2.0,3.0,4.0)
q1*3

    Quaternion{Float64}:
      + 3.0 + 6.0.i + 9.0.j + 12.0.k

4*q1

    Quaternion{Float64}:
      + 4.0 + 8.0.i + 12.0.j + 16.0.k
```

There are also the following functions available:

```julia
q = Quaternion(1.0,2.0,3.0,4.0)

conj(q)  # Returns the complex conjugate of the quaternion.

    Quaternion{Float64}:
      + 1.0 - 2.0.i - 3.0.j - 4.0.k

copy(q)  # Creates a copy of the quaternion.

    Quaternion{Float64}:
      + 1.0 + 2.0.i + 3.0.j + 4.0.k

inv(q)   # Computes the multiplicative inverse of the quaternion.

    Quaternion{Float64}:
      + 0.03333333333333333 - 0.06666666666666667.i - 0.1.j - 0.13333333333333333.k

inv(q)*q

    Quaternion{Float64}:
      + 1.0 + 0.0.i + 0.0.j + 0.0.k

imag(q)  # Returns the vectorial / imaginary part of the quaternion.

    3-element Array{Float64,1}:
     2.0
     3.0
     4.0

norm(q)  # Computes the norm of the quaternion.

    5.477225575051661

real(q)  # Returns the real part of the quaternion.

    1.0

vect(q)  # Returns the vectorial / imaginary part of the quaternion.

    3-element Array{Float64,1}:
     2.0
     3.0
     4.0
```

**NOTE**: The operation `a/q` is equal to `a*inv(q)` if `a` is a scalar.

Moreover, the multiplication between quaternions is also defined using the
Hamilton product and it is transparent to the user:

```julia
q1 = Quaternion(cosd(15), sind(15), 0.0, 0.0)
q2 = Quaternion(cosd(30), sind(30), 0.0, 0.0)
q1*q2

    Quaternion{Float64}:
      + 0.7071067811865475 + 0.7071067811865475.i + 0.0.j + 0.0.k
```

If a quaternion is multiplied by a vector, then the vector is converted to a
quaternion with real part `0` and the quaternion multiplication is performed as
usual:

```julia
q1 = Quaternion(cosd(22.5), sind(22.5), 0.0, 0.0)
v  = [0;1;0]
v*q1

    Quaternion{Float64}:
      + 0.0 + 0.0.i + 0.9659258262890683.j - 0.25881904510252074.k

q1*v

    Quaternion{Float64}:
      + 0.0 + 0.0.i + 0.9659258262890683.j + 0.25881904510252074.k
```

Hence, if the quaternion represents a 3D rotation from the reference frame A to
the reference frame B, then a vector represented in reference frame A can be
represented in reference frame B using:

```julia
qBA = Quaternion(cosd(22.5), sind(22.5), 0.0, 0.0)
vA  = [0;1;0]
vB  = vect(inv(qBA)*vA*qBA)
vB

    3-element Array{Float64,1}:
      0.0
      0.707107
     -0.707107
```

## Conversions

### Direction Cosine Matrices to Euler Angles

A Direction Cosine Matrix (DCM) can be converted to Euler Angles using the
following function:

    function dcm2angle(dcm, rot_seq="ZYX")

**Example**:

```julia
dcm = [1 0 0; 0 0 -1; 0 1 0]
dcm2angle(dcm)

    ReferenceFrameRotations.EulerAngles{Float64}(0.0, 0.0, -1.5707963267948966, "ZYX")

dcm2angle(dcm, "XYZ")

    ReferenceFrameRotations.EulerAngles{Float64}(-1.5707963267948966, 0.0, 0.0, "XYZ")
```

### Direction Cosine Matrices to Quaternions

A DCM can be converted to quaternion using these two methods:

    function dcm2quat!(q, dcm)
    function dcm2quat(dcm)

The first `dcm2quat!` requires a pre-allocated quaternion, whereas the second
`dcm2quat` allocates a new quaternion.

**Example**

```julia
q   = Quaternion(1.0,0.0,0.0,0.0)
dcm = [1.0 0.0 0.0; 0.0 0.0 -1.0; 0.0 1.0 0.0]
dcm2quat!(q, dcm)
q

    Quaternion{Float64}:
      + 0.7071067811865476 - 0.7071067811865476.i + 0.0.j + 0.0.k

dcm = [1.0 0.0 0.0; 0.0 0.0 -1.0; 0.0 1.0 0.0]
q   = dcm2quat(dcm)

    Quaternion{Float64}:
      + 0.7071067811865476 - 0.7071067811865476.i + 0.0.j + 0.0.k
```

**NOTE**: Avoid using DCMs with `Int` numbers like:

    dcm = [1 0 0; 0 0 -1; 0 1 0]

because it can lead to `InexactError()` when converting to Quaternions. This bug
will be addressed in a future version of **ReferenceFrameRotations.jl**.

### Euler Angle and Axis to Quaternions

A Euler angle and axis representation can be converted to quaternion using these
two methods:

    function angleaxis2quat(a, v)
    function angleaxis2quat(angleaxis)

**Example**

```julia
a = 60.0*pi/180
v = [sqrt(3)/3;sqrt(3)/3;sqrt(3)/3]
angleaxis2quat(a,v)

    Quaternion{Float64}:
      + 0.8660254037844387 + 0.2886751345948128.i + 0.2886751345948128.j + 0.2886751345948128.k

angleaxis = EulerAngleAxis(a,v)
angleaxis2quat(angleaxis)

    Quaternion{Float64}:
      + 0.8660254037844387 + 0.2886751345948128.i + 0.2886751345948128.j + 0.2886751345948128.k
```

### Euler Angles to Direction Cosine Matrices

Euler angles can be converted to DCMs using two functions. The first
`angle2dcm!` requires a pre-allocated 3x3 matrix, whereas the second `angle2dcm`
allocates a new 3x3 matrix. The available methods are:

    function angle2dcm!(dcm, angle_r1, angle_r2, angle_r3, rot_seq="ZYX")
    function angle2dcm(angle_r1, angle_r2, angle_r3, rot_seq="ZYX")
    function angle2dcm!(dcm, eulerang)
    function angle2dcm(eulerang)

**Example**:

```julia
dcm = eye(3)
angle2dcm!(dcm, pi/2, pi/4, pi/3, "ZYX")
dcm

    3×3 Array{Float64,2}:
      4.32978e-17  0.707107  -0.707107
     -0.5          0.612372   0.612372
      0.866025     0.353553   0.353553

dcm    = eye(3)
angles = EulerAngles(pi/2, pi/4, pi/3, "ZYX")
angle2dcm!(dcm,angles)
dcm

    3×3 Array{Float64,2}:
      4.32978e-17  0.707107  -0.707107
     -0.5          0.612372   0.612372
      0.866025     0.353553   0.353553

dcm = angle2dcm(pi/2, pi/4, pi/3, "ZYX")

    3×3 Array{Float64,2}:
      4.32978e-17  0.707107  -0.707107
     -0.5          0.612372   0.612372
      0.866025     0.353553   0.353553

angles = EulerAngles(pi/2, pi/4, pi/3, "ZYX")
dcm    = angle2dcm(angles)

    3×3 Array{Float64,2}:
      4.32978e-17  0.707107  -0.707107
     -0.5          0.612372   0.612372
      0.866025     0.353553   0.353553
```

### Euler Angles to Quaternions

Euler angles can be converted to quaternions using two functions. The first
`angle2quat!` requires a pre-allocated quaternion, whereas the second
`angle2quat` allocates a new quaternion. The available methods are:

    function angle2quat!(q, angle_r1, angle_r2, angle_r3, rot_seq="ZYX")
    function angle2quat(angle_r1, angle_r2, angle_r3, rot_seq="ZYX")
    function angle2quat!(q, eulerang)
    function angle2quat(eulerang)

**Example**:

```julia
q = eye(Quaternion)
angle2quat!(q, pi/2, pi/4, pi/3, "ZYX")
q

    Quaternion{Float64}:
      + 0.7010573846499779 + 0.09229595564125723.i + 0.5609855267969309.j + 0.43045933457687935.k

q      = eye(Quaternion)
angles = EulerAngles(pi/2, pi/4, pi/3, "ZYX")
angle2quat!(q,angles)
q

    Quaternion{Float64}:
      + 0.7010573846499779 + 0.09229595564125723.i + 0.5609855267969309.j + 0.43045933457687935.k

q = angle2quat(pi/2, pi/4, pi/3, "ZYX")

    Quaternion{Float64}:
      + 0.7010573846499779 + 0.09229595564125723.i + 0.5609855267969309.j + 0.43045933457687935.k

angles = EulerAngles(pi/2, pi/4, pi/3, "ZYX")
q    = angle2quat(angles)

    Quaternion{Float64}:
      + 0.7010573846499779 + 0.09229595564125723.i + 0.5609855267969309.j + 0.43045933457687935.k
```

### Small Euler Angles to Direction Cosine Matrices

Small Euler angles can be converted to DCMs using two functions. The first
`smallangle2dcm!` requires a pre-allocated 3x3 matrix, whereas the second
`smallangle2dcm` allocates a new 3x3 matrix. The available methods are:

    function smallangle2dcm!(dcm, θx, θy, θz)
    function smallangle2dcm(θx, θy, θz)

**Example**:

```julia
dcm = eye(3)
smallangle2dcm!(dcm, 0.001, -0.002, +0.003)
dcm

    3×3 Array{Float64,2}:
      1.0     0.003  0.002
     -0.003   1.0    0.001
     -0.002  -0.001  1.0

dcm = smallangle2dcm(0.001, -0.002, +0.003)

    3×3 Array{Float64,2}:
      1.0     0.003  0.002
     -0.003   1.0    0.001
     -0.002  -0.001  1.0
```

**NOTE**: The computed DCM **is not** ortho-normalized.

### Small Euler Angles to Quaternions

Small Euler angles can be converted to quaternions using two functions. The
first `smallangle2quat!` requires a pre-allocated quaternion, whereas the second
`smallangle2quat` allocates a new quaternion. The available methods are:

    function smallangle2quat!(q, θx, θy, θz)
    function smallangle2quat(θx, θy, θz)

**Example**:

```julia
q = eye(Quaternion)
smallangle2quat!(q, 0.001, -0.002, +0.003)
q

    Quaternion{Float64}:
      + 0.9999982500045936 + 0.0004999991250022968.i - 0.0009999982500045936.j + 0.0014999973750068907.k

q = smallangle2quat(0.001, -0.002, +0.003)

    Quaternion{Float64}:
      + 0.9999982500045936 + 0.0004999991250022968.i - 0.0009999982500045936.j + 0.0014999973750068907.k
```

**NOTE**: The computed quaternion **is** normalized.

### Quaternions to Direction Cosine Matrices

A quaternion can be converted to DCM using these two methods:

    function quat2dcm!(dcm, q)
    function quat2dcm(q)

The first `quat2dcm!` requires a pre-allocated 3x3 matrix, whereas the second
`quat2dcm` allocates a new 3x3 matrix.

**Example**

```julia
q   = Quaternion(cosd(22.5), sind(22.5), 0.0, 0.0)
dcm = eye(3)
quat2dcm!(dcm,q)

    3×3 Array{Float64,2}:
     1.0   0.0       0.0
     0.0   0.707107  0.707107
     0.0  -0.707107  0.707107

q   = Quaternion(cosd(22.5), sind(22.5), 0.0, 0.0)
dcm = quat2dcm(q)

    3×3 Array{Float64,2}:
     1.0   0.0       0.0
     0.0   0.707107  0.707107
     0.0  -0.707107  0.707107
```

### Quaternions to Euler Angle and Axis

A quaternion can be converted to Euler Angle and Axis representation using the
following function:

    function quat2angleaxis(q)

**Example**

```julia
v = [sqrt(3)/3;sqrt(3)/3;sqrt(3)/3]
a = 60.0*pi/180
q = Quaternion(cos(a/2), v*sin(a/2))
quat2angleaxis(q)

    ReferenceFrameRotations.EulerAngleAxis{Float64}(1.0471975511965974, [0.57735, 0.57735, 0.57735])
```

### Quaternions to Euler Angles

Currently, there are only one method to convert quaternions to Euler Angles:

    function quat2angle(q, rot_seq="ZYX")

However, it first transforms the quaternion to DCM using `quat2dcm` and then
transforms the DCM into the Euler Angles. Hence, the performance will be poor.
The improvement of this conversion will be addressed in a future version of
**ReferenceFrameRotations.jl**.

**Example**

```julia
q = Quaternion(cosd(22.5), sind(22.5), 0.0, 0.0)
quat2angle(q, "XYZ")

    ReferenceFrameRotations.EulerAngles{Float64}(0.7853981633974484, 0.0, -0.0, "XYZ")
```

## Kinematics

### Direction Cosine Matrix

The user can use this function

    function ddcm(Dba, wba_b)

to obtain the time-derivative of a DCM. In this case, `Dba` is a DCM that
rotates the reference frame `a` into alignment to reference frame `b` in which
the angular velocity of `b` with respect to `a` and represented in `b` is
`wba_b`.

**Example**

The following code can be used to integrate a DCM by one sampling step Δ:

```julia
dDba = ddcm(Dba,wba_b)
Dba  = Dba + dDba*Δ
```

**NOTE**: In this case, the sampling step must be small to avoid numerical
problems. To avoid that, use better integration algorithms.

### Quaternions

The user can use this function

    function dquat(qba, wba_b)

to obtain the time-derivative of a quaternion. In this case, `qba` is a
quaternion that rotates the reference frame `a` into alignment to reference
frame `b` in which the angular velocity of `b` with respect to `a` and
represented in `b` is wba_b.

**Example**

The following code can be used to integrate a quaternion by one sampling step Δ:

```julia
dqba = dquat(qba,wba_b)
qba  = qba + dqba*Δ
qba  = qba/norm(qba)
```

**NOTE**: In this case, the sampling step must be small to avoid numerical
problems. To avoid that, use better integration algorithms.

## Composing rotations

Multiple rotations using Direction Cosine Matrices or Quaternions can be
composed by the function:

    compose_rotation(R1,R2,R3,R4...)

in which `R1`, `R2`, `R3`, ..., must be simultaneously DCMs or Quaternions. This
method returns the following rotation:

     First Rotation
     |
     |
    R1 => R2 => R3 => R4 => ...
           |
           |
           Second Rotation

## Remarks

In other to improve the readability of this document, the methods described here
are not presented with their entire signature. Nevertheless, they are fully
documented using Julia documentation system, which can be accessed by typing `?`
in REPL.

## Roadmap

This package will be continuously enhanced. Next steps will be to add other
representations of 3D rotations such as Euler angle and axis (initial support is
already available), Rodrigues parameters, etc.
