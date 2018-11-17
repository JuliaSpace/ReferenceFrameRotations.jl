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
function dcm_to_angle(dcm::DCM, rot_seq=:ZYX)
```

!!! note

    **Gimbal-lock and special cases**

    If the rotations are about three different axes, *e.g.* `:XYZ`, `:ZYX`,
    etc., then a second rotation of ``\pm 90^{\circ}`` yields a gimbal-lock.
    This means that the rotations between the first and third axes have the same
    effect. In this case, the net rotation angle is assigned to the first
    rotation and the angle of the third rotation is set to 0.

    If the rotations are about two different axes, *e.g.* `:XYX`, `:YXY`, etc.,
    then a rotation about the duplicated axis yields multiple representations.
    In this case, the entire angle is assigned to the first rotation and the
    third rotation is set to 0.

```jldoctest
julia> dcm = DCM([1 0 0; 0 0 -1; 0 1 0]);

julia> dcm_to_angle(dcm)
EulerAngles{Float64}:
  R(Z):   0.0000 rad (   0.0000 deg)
  R(Y):   0.0000 rad (   0.0000 deg)
  R(X):  -1.5708 rad ( -90.0000 deg)

julia> dcm_to_angle(dcm, :XYZ)
EulerAngles{Float64}:
  R(X):  -1.5708 rad ( -90.0000 deg)
  R(Y):   0.0000 rad (   0.0000 deg)
  R(Z):   0.0000 rad (   0.0000 deg)

julia> D = angle_to_dcm(1, -pi/2, 2, :ZYX);

julia> dcm_to_angle(D,:ZYX)
EulerAngles{Float64}:
  R(Z):   3.0000 rad ( 171.8873 deg)
  R(Y):  -1.5708 rad ( -90.0000 deg)
  R(X):   0.0000 rad (   0.0000 deg)

julia> D = create_rotation_matrix(1,:X)*create_rotation_matrix(2,:X);

julia> dcm_to_angle(D,:XYX)
EulerAngles{Float64}:
  R(X):   3.0000 rad ( 171.8873 deg)
  R(Y):   0.0000 rad (   0.0000 deg)
  R(X):   0.0000 rad (   0.0000 deg)
```

## DCMs to Euler Angle and Axis

A DCM can be converto to an Euler angle and axis representation using the
following method:

```julia
function dcm_to_angleaxis(dcm::DCM)
```

```jldoctest
julia> dcm = DCM([1.0 0.0 0.0; 0.0 0.0 -1.0; 0.0 1.0 0.0]);

julia> ea  = dcm_to_angleaxis(dcm)
EulerAngleAxis{Float64}:
  Euler angle:   1.5708 rad ( 90.0000 deg)
   Euler axis: [ -1.0000,   0.0000,   0.0000]

```

## DCMs to Quaternions

A DCM can be converted to quaternion using the following method:

```julia
function dcm_to_quat(dcm::DCM)
```

```jldoctest
julia> dcm = DCM([1.0 0.0 0.0; 0.0 0.0 -1.0; 0.0 1.0 0.0]);

julia> q   = dcm_to_quat(dcm)
Quaternion{Float64}:
  + 0.7071067811865476 - 0.7071067811865475.i + 0.0.j + 0.0.k
```

## Euler Angle and Axis to DCMs

An Euler angle and axis representation can be converted to DCM using using these
two methods:

```julia
function angleaxis_to_dcm(a::Number, v::AbstractVector)
function angleaxis_to_dcm(ea::EulerAngleAxis)
```

```jldoctest
julia> a = 60.0*pi/180;

julia> v = [sqrt(3)/3;sqrt(3)/3;sqrt(3)/3];

julia> angleaxis_to_dcm(a,v)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  0.666667   0.666667  -0.333333
 -0.333333   0.666667   0.666667
  0.666667  -0.333333   0.666667

julia> angleaxis = EulerAngleAxis(a,v);

julia> angleaxis_to_dcm(angleaxis)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  0.666667   0.666667  -0.333333
 -0.333333   0.666667   0.666667
  0.666667  -0.333333   0.666667
```

## Euler Angle and Axis to Euler Angles

An Euler angle and axis representaion can be converto to Euler angles using
these two methods:

```julia
function angleaxis_to_angle(θ::Number, v::AbstractVector, rot_seq::Symbol)
function angleaxis_to_angle(ea::EulerAngleAxis, rot_seq::Symbol)
```

```jldoctest
julia> a = 19.86*pi/180;

julia> v = [0;1;0];

julia> angleaxis_to_angle(a,v,:XYX)
EulerAngles{Float64}:
  R(X):   0.0000 rad (   0.0000 deg)
  R(Y):   0.3466 rad (  19.8600 deg)
  R(X):   0.0000 rad (   0.0000 deg)

julia> a = 60.0*pi/180;

julia> v = [sqrt(3)/3;sqrt(3)/3;sqrt(3)/3];

julia> angleaxis = EulerAngleAxis(a,v)
EulerAngleAxis{Float64}:
  Euler angle:   1.0472 rad ( 60.0000 deg)
   Euler axis: [  0.5774,   0.5774,   0.5774]

julia> angleaxis_to_angle(angleaxis,:XYZ)
EulerAngles{Float64}:
  R(X):   0.4636 rad (  26.5651 deg)
  R(Y):   0.7297 rad (  41.8103 deg)
  R(Z):   0.4636 rad (  26.5651 deg)

julia> angleaxis_to_angle(angleaxis,:ZYX)
EulerAngles{Float64}:
  R(Z):   0.7854 rad (  45.0000 deg)
  R(Y):   0.3398 rad (  19.4712 deg)
  R(X):   0.7854 rad (  45.0000 deg)
```

## Euler Angle and Axis to Quaternions

An Euler angle and axis representation can be converted to quaternion using
these two methods:

```julia
function angleaxis_to_quat(a::Number, v::AbstractVector)
function angleaxis_to_quat(angleaxis::EulerAngleAxis)
```

```jldoctest
julia> a = 60.0*pi/180;

julia> v = [sqrt(3)/3;sqrt(3)/3;sqrt(3)/3];

julia> angleaxis_to_quat(a,v)
Quaternion{Float64}:
  + 0.8660254037844387 + 0.2886751345948128.i + 0.2886751345948128.j + 0.2886751345948128.k

julia> angleaxis = EulerAngleAxis(a,v);

julia> angleaxis_to_quat(angleaxis)
Quaternion{Float64}:
  + 0.8660254037844387 + 0.2886751345948128.i + 0.2886751345948128.j + 0.2886751345948128.k
```

## Euler Angles to Direction Cosine Matrices

Euler angles can be converted to DCMs using the following functions:

```julia
function angle_to_dcm(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol = :ZYX)
function angle_to_dcm(Θ::EulerAngles)
```

```jldoctest
julia> dcm = angle_to_dcm(pi/2, pi/4, pi/3, :ZYX)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  4.32978e-17  0.707107  -0.707107
 -0.5          0.612372   0.612372
  0.866025     0.353553   0.353553

julia> angles = EulerAngles(pi/2, pi/4, pi/3, :ZYX);

julia> dcm    = angle_to_dcm(angles)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  4.32978e-17  0.707107  -0.707107
 -0.5          0.612372   0.612372
  0.866025     0.353553   0.353553
```

## Euler Angles to Euler Angles

It is possible to change the rotation sequence of a set of Euler angles using
the following functions:

```julia
function angle_to_angle(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq_orig::Symbol, rot_seq_dest::Symbol)
function angle_to_angle(Θ::EulerAngles, rot_seq_dest::Symbol)
```

in which `rot_seq_dest` is the desired rotation sequence of the result.

```jldoctest
julia> angle_to_angle(-pi/2, -pi/3, -pi/4, :ZYX, :XYZ)
EulerAngles{Float64}:
  R(X):  -1.0472 rad ( -60.0000 deg)
  R(Y):   0.7854 rad (  45.0000 deg)
  R(Z):  -1.5708 rad ( -90.0000 deg)

julia> angle_to_angle(-pi/2, 0, 0, :ZYX, :XYZ)
EulerAngles{Float64}:
  R(X):   0.0000 rad (   0.0000 deg)
  R(Y):   0.0000 rad (   0.0000 deg)
  R(Z):  -1.5708 rad ( -90.0000 deg)

julia> Θ = EulerAngles(1,2,3,:XYX)
EulerAngles{Int64}:
  R(X):   1.0000 rad (  57.2958 deg)
  R(Y):   2.0000 rad ( 114.5916 deg)
  R(X):   3.0000 rad ( 171.8873 deg)

julia> angle_to_angle(Θ,:ZYZ)
EulerAngles{Float64}:
  R(Z):  -2.7024 rad (-154.8356 deg)
  R(Y):   1.4668 rad (  84.0393 deg)
  R(Z):  -1.0542 rad ( -60.3984 deg)
```

## Euler Angles to Quaternions

Euler angles can be converted to an Euler angle and axis using the following
functions:

```julia
function angle_to_angleaxis(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol = :ZYX)
function angle_to_angleaxis(Θ::EulerAngles)
```

```jldoctest
julia> angle_to_angleaxis(1,0,0,:XYZ)
EulerAngleAxis{Float64}:
  Euler angle:   1.0000 rad ( 57.2958 deg)
   Euler axis: [  1.0000,   0.0000,   0.0000]

julia> Θ = EulerAngles(1,1,1,:XYZ);

julia> angle_to_angleaxis(Θ)
EulerAngleAxis{Float64}:
  Euler angle:   1.9391 rad (111.1015 deg)
   Euler axis: [  0.6924,   0.2031,   0.6924]

```

## Euler Angles to Quaternions

Euler angles can be converted to quaternions using the following functions:

```julia
function angle_to_quat(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol = :ZYX)
function angle_to_quat(Θ::EulerAngles)
```

```jldoctest
julia> q = angle_to_quat(pi/2, pi/4, pi/3, :ZYX)
Quaternion{Float64}:
  + 0.7010573846499779 + 0.09229595564125723.i + 0.5609855267969309.j + 0.43045933457687935.k

julia> angles = EulerAngles(pi/2, pi/4, pi/3, :ZYX);

julia> q    = angle_to_quat(angles)
Quaternion{Float64}:
  + 0.7010573846499779 + 0.09229595564125723.i + 0.5609855267969309.j + 0.43045933457687935.k
```

## Small Euler Angles to Direction Cosine Matrices

Small Euler angles can be converted to DCMs using the following function:

```julia
function smallangle_to_dcm(θx::Number, θy::Number, θz::Number; normalize = true)
```

in which the resulting matrix will be orthonormalized if the keyword `normalize`
is `true`.

```jldoctest
julia> dcm = smallangle_to_dcm(0.001, -0.002, +0.003)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  0.999994     0.00299799   0.00200298
 -0.00299998   0.999995     0.000993989
 -0.00199999  -0.000999991  0.999998

julia> dcm = smallangle_to_dcm(0.001, -0.002, +0.003; normalize = false)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  1.0     0.003  0.002
 -0.003   1.0    0.001
 -0.002  -0.001  1.0
```

## Small Euler Angles to Quaternions

Small Euler angles can be converted to quaternions using the following function:

```julia
function smallangle_to_quat(θx::Number, θy::Number, θz::Number)
```

```jldoctest
julia> q = smallangle_to_quat(0.001, -0.002, +0.003)
Quaternion{Float64}:
  + 0.9999982500045936 + 0.0004999991250022968.i - 0.0009999982500045936.j + 0.0014999973750068907.k
```

!!! note

    The computed quaternion **is** normalized.

## Quaternions to Direction Cosine Matrices

A quaternion can be converted to DCM using the following method:

```julia
function quat_to_dcm(q::Quaternion)
```

```jldoctest
julia> q   = Quaternion(cosd(22.5), sind(22.5), 0.0, 0.0);

julia> dcm = quat_to_dcm(q)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
 1.0   0.0       0.0
 0.0   0.707107  0.707107
 0.0  -0.707107  0.707107
```

## Quaternions to Euler Angle and Axis

A quaternion can be converted to Euler Angle and Axis representation using the
following function:

```julia
function quat_to_angleaxis(q::Quaternion)
```

```jldoctest
julia> v = [sqrt(3)/3;sqrt(3)/3;sqrt(3)/3];

julia> a = 60.0*pi/180;

julia> q = Quaternion(cos(a/2), v*sin(a/2));

julia> quat_to_angleaxis(q)
EulerAngleAxis{Float64}:
  Euler angle:   1.0472 rad ( 60.0000 deg)
   Euler axis: [  0.5774,   0.5774,   0.5774]

```

## Quaternions to Euler Angles

There is one method to convert quaternions to Euler Angles:

```julia
function quat_to_angle(q::Quaternion, rot_seq=:ZYX)
```

However, it first transforms the quaternion to DCM using `quat_to_dcm` and then
transforms the DCM into the Euler Angles. Hence, the performance will be poor.
The improvement of this conversion will be addressed in a future version of
**ReferenceFrameRotations.jl**.

```jldoctest
julia> q = Quaternion(cosd(22.5), sind(22.5), 0.0, 0.0);

julia> quat_to_angle(q, :XYZ)
EulerAngles{Float64}:
  R(X):   0.7854 rad (  45.0000 deg)
  R(Y):   0.0000 rad (   0.0000 deg)
  R(Z):   0.0000 rad (   0.0000 deg)

```
