Conversions
===========

```@meta
CurrentModule = ReferenceFrameRotations
DocTestSetup = quote
    using LinearAlgebra
    using ReferenceFrameRotations
end
```

There are several functions available to convert between the different types of
3D rotation representations.

## DCMs to Euler Angles

A Direction Cosine Matrix (DCM) can be converted to Euler Angles using the
following function:

```julia
function dcm2angle(dcm, rot_seq=:ZYX)
```

```jldoctest
julia> dcm = DCM([1 0 0; 0 0 -1; 0 1 0]);

julia> dcm2angle(dcm)
EulerAngles{Float64}(0.0, 0.0, -1.5707963267948966, :ZYX)

julia> dcm2angle(dcm, :XYZ)
EulerAngles{Float64}(-1.5707963267948966, 0.0, 0.0, :XYZ)
```

## DCMs to Quaternions

A DCM can be converted to quaternion using the following method:

```julia
function dcm2quat(dcm)
```

```jldoctest
julia> dcm = DCM([1.0 0.0 0.0; 0.0 0.0 -1.0; 0.0 1.0 0.0]);

julia> q   = dcm2quat(dcm)
Quaternion{Float64}:
  + 0.7071067811865476 - 0.7071067811865475.i + 0.0.j + 0.0.k
```

!!! warning

    Avoid using DCMs with `Int` numbers like:

    ```julia
    dcm = DCM([1 0 0; 0 0 -1; 0 1 0])
    ```

    because it can lead to `InexactError()` when converting to Quaternions. This
    bug will be addressed in a future version of **ReferenceFrameRotations.jl**.

## Euler Angle and Axis to Quaternions

A Euler angle and axis representation can be converted to quaternion using these
two methods:

```julia
function angleaxis2quat(a, v)
function angleaxis2quat(angleaxis)
```

```jldoctest
julia> a = 60.0*pi/180;

julia> v = [sqrt(3)/3;sqrt(3)/3;sqrt(3)/3];

julia> angleaxis2quat(a,v)
Quaternion{Float64}:
  + 0.8660254037844387 + 0.2886751345948128.i + 0.2886751345948128.j + 0.2886751345948128.k

julia> angleaxis = EulerAngleAxis(a,v);

julia> angleaxis2quat(angleaxis)
Quaternion{Float64}:
  + 0.8660254037844387 + 0.2886751345948128.i + 0.2886751345948128.j + 0.2886751345948128.k
```

## Euler Angles to Direction Cosine Matrices

Euler angles can be converted to DCMs using the following functions:

```
function angle2dcm(angle_r1, angle_r2, angle_r3, rot_seq=:ZYX)
function angle2dcm(eulerang)
```

```jldoctest
julia> dcm = angle2dcm(pi/2, pi/4, pi/3, :ZYX)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  4.32978e-17  0.707107  -0.707107
 -0.5          0.612372   0.612372
  0.866025     0.353553   0.353553

julia> angles = EulerAngles(pi/2, pi/4, pi/3, :ZYX);

julia> dcm    = angle2dcm(angles)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  4.32978e-17  0.707107  -0.707107
 -0.5          0.612372   0.612372
  0.866025     0.353553   0.353553
```

### Euler Angles to Quaternions

Euler angles can be converted to quaternions using the following functions:

```julia
function angle2quat(angle_r1, angle_r2, angle_r3, rot_seq="ZYX")
function angle2quat(eulerang)
```

```jldoctest
julia> q = angle2quat(pi/2, pi/4, pi/3, :ZYX)
Quaternion{Float64}:
  + 0.7010573846499779 + 0.09229595564125723.i + 0.5609855267969309.j + 0.43045933457687935.k

julia> angles = EulerAngles(pi/2, pi/4, pi/3, :ZYX);

julia> q    = angle2quat(angles)
Quaternion{Float64}:
  + 0.7010573846499779 + 0.09229595564125723.i + 0.5609855267969309.j + 0.43045933457687935.k
```

## Small Euler Angles to Direction Cosine Matrices

Small Euler angles can be converted to DCMs using the following function:

```julia
function smallangle2dcm(θx, θy, θz)
```

```jldoctest
julia> dcm = smallangle2dcm(0.001, -0.002, +0.003)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  1.0     0.003  0.002
 -0.003   1.0    0.001
 -0.002  -0.001  1.0
```

!!! warning

    The computed DCM **is not** ortho-normalized.

## Small Euler Angles to Quaternions

Small Euler angles can be converted to quaternions using the following function:

```julia
function smallangle2quat(θx, θy, θz)
```

```jldoctest
julia> q = smallangle2quat(0.001, -0.002, +0.003)
Quaternion{Float64}:
  + 0.9999982500045936 + 0.0004999991250022968.i - 0.0009999982500045936.j + 0.0014999973750068907.k
```

!!! note

    The computed quaternion **is** normalized.

## Quaternions to Direction Cosine Matrices

A quaternion can be converted to DCM using the following method:

```julia
function quat2dcm(q)
```

```jldoctest
julia> q   = Quaternion(cosd(22.5), sind(22.5), 0.0, 0.0);

julia> dcm = quat2dcm(q)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
 1.0   0.0       0.0
 0.0   0.707107  0.707107
 0.0  -0.707107  0.707107
```

### Quaternions to Euler Angle and Axis

A quaternion can be converted to Euler Angle and Axis representation using the
following function:

```julia
function quat2angleaxis(q)
```

```jldoctest
julia> v = [sqrt(3)/3;sqrt(3)/3;sqrt(3)/3];

julia> a = 60.0*pi/180;

julia> q = Quaternion(cos(a/2), v*sin(a/2));

julia> quat2angleaxis(q)
EulerAngleAxis{Float64}(1.0471975511965974, [0.57735, 0.57735, 0.57735])
```

### Quaternions to Euler Angles

There is one method to convert quaternions to Euler Angles:

```julia
function quat2angle(q, rot_seq="ZYX")
```

However, it first transforms the quaternion to DCM using `quat2dcm` and then
transforms the DCM into the Euler Angles. Hence, the performance will be poor.
The improvement of this conversion will be addressed in a future version of
**ReferenceFrameRotations.jl**.

```jldoctest
julia> q = Quaternion(cosd(22.5), sind(22.5), 0.0, 0.0);

julia> quat2angle(q, :XYZ)
EulerAngles{Float64}(0.7853981633974484, 0.0, -0.0, :XYZ)
```
