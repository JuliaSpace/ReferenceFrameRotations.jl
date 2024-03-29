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
  R(Z) :  0.0    rad  ( 0.0°)
  R(Y) :  0.0    rad  ( 0.0°)
  R(X) : -1.5708 rad  (-90.0°)

julia> dcm_to_angle(dcm, :XYZ)
EulerAngles{Float64}:
  R(X) : -1.5708 rad  (-90.0°)
  R(Y) :  0.0    rad  ( 0.0°)
  R(Z) :  0.0    rad  ( 0.0°)

julia> D = angle_to_dcm(1, -pi / 2, 2, :ZYX);

julia> dcm_to_angle(D, :ZYX)
EulerAngles{Float64}:
  R(Z) :  3.0    rad  ( 171.887°)
  R(Y) : -1.5708 rad  (-90.0°)
  R(X) :  0.0    rad  ( 0.0°)

julia> D = angle_to_dcm(1, :X) * angle_to_dcm(2, :X);

julia> dcm_to_angle(D, :XYX)
EulerAngles{Float64}:
  R(X) :  3.0 rad  ( 171.887°)
  R(Y) :  0.0 rad  ( 0.0°)
  R(X) :  0.0 rad  ( 0.0°)
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
  Euler angle : 1.5708 rad  (90.0°)
  Euler axis  : [-1.0, 0.0, 0.0]
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
  + 0.707107 - 0.707107⋅i + 0.0⋅j + 0.0⋅k
```

## Euler Angle and Axis to DCMs

An Euler angle and axis representation can be converted to DCM using using these
two methods:

```julia
function angleaxis_to_dcm(a::Number, v::AbstractVector)
function angleaxis_to_dcm(ea::EulerAngleAxis)
```

```jldoctest
julia> a = 60.0 * pi / 180;

julia> v = [sqrt(3) / 3, sqrt(3) / 3, sqrt(3)/3];

julia> angleaxis_to_dcm(a, v)
DCM{Float64}:
  0.666667   0.666667  -0.333333
 -0.333333   0.666667   0.666667
  0.666667  -0.333333   0.666667

julia> angleaxis = EulerAngleAxis(a, v);

julia> angleaxis_to_dcm(angleaxis)
DCM{Float64}:
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
julia> a = 19.86 * pi / 180;

julia> v = [0, 1, 0];

julia> angleaxis_to_angle(a, v, :XYX)
EulerAngles{Float64}:
  R(X) :  0.0      rad  ( 0.0°)
  R(Y) :  0.346622 rad  ( 19.86°)
  R(X) :  0.0      rad  ( 0.0°)

julia> a = 60.0 * pi / 180;

julia> v = [sqrt(3) / 3, sqrt(3) / 3, sqrt(3) / 3];

julia> angleaxis = EulerAngleAxis(a, v)
EulerAngleAxis{Float64}:
  Euler angle : 1.0472 rad  (60.0°)
  Euler axis  : [0.57735, 0.57735, 0.57735]

julia> angleaxis_to_angle(angleaxis, :XYZ)
EulerAngles{Float64}:
  R(X) :  0.463648 rad  ( 26.5651°)
  R(Y) :  0.729728 rad  ( 41.8103°)
  R(Z) :  0.463648 rad  ( 26.5651°)

julia> angleaxis_to_angle(angleaxis, :ZYX)
EulerAngles{Float64}:
  R(Z) :  0.785398 rad  ( 45.0°)
  R(Y) :  0.339837 rad  ( 19.4712°)
  R(X) :  0.785398 rad  ( 45.0°)
```

## Euler Angle and Axis to Quaternions

An Euler angle and axis representation can be converted to quaternion using
these two methods:

```julia
function angleaxis_to_quat(a::Number, v::AbstractVector)
function angleaxis_to_quat(angleaxis::EulerAngleAxis)
```

```jldoctest
julia> a = 60.0 * pi / 180;

julia> v = [sqrt(3) / 3, sqrt(3) / 3, sqrt(3) / 3];

julia> angleaxis_to_quat(a,v)
Quaternion{Float64}:
  + 0.866025 + 0.288675⋅i + 0.288675⋅j + 0.288675⋅k

julia> angleaxis = EulerAngleAxis(a,v);

julia> angleaxis_to_quat(angleaxis)
Quaternion{Float64}:
  + 0.866025 + 0.288675⋅i + 0.288675⋅j + 0.288675⋅k
```

## Euler Angles to Direction Cosine Matrices

Euler angles can be converted to DCMs using the following functions:

```julia
function angle_to_dcm(θ₁::Number[, θ₂::Number[, θ₃::Number]], rot_seq::Symbol = :ZYX)
function angle_to_dcm(Θ::EulerAngles)
```

```jldoctest
julia> dcm = angle_to_dcm(pi / 2, pi / 4, pi / 3, :ZYX)
DCM{Float64}:
  4.32978e-17  0.707107  -0.707107
 -0.5          0.612372   0.612372
  0.866025     0.353553   0.353553

julia> angles = EulerAngles(pi / 2, pi / 4, pi / 3, :ZYX);

julia> dcm = angle_to_dcm(angles)
DCM{Float64}:
  4.32978e-17  0.707107  -0.707107
 -0.5          0.612372   0.612372
  0.866025     0.353553   0.353553
```

Suppose the user desires to obtain the DCM that rotates the coordinate system
about only one or two axes. In that case, it is better to use the following
functions due to improved accuracy in some cases:

```
function angle_to_dcm(θ₁::Number, rot_seq::Symbol)
function angle_to_dcm(θ₁::Number, θ₂::Number, rot_seq::Symbol)
```

```jldoctest
julia> angle_to_dcm(-pi / 4, :Z)
DCM{Float64}:
 0.707107  -0.707107  0.0
 0.707107   0.707107  0.0
 0.0        0.0       1.0

julia> angle_to_dcm(-pi / 4, pi / 7, :XY)
DCM{Float64}:
 0.900969  -0.306802  -0.306802
 0.0        0.707107  -0.707107
 0.433884   0.637081   0.637081
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
julia> angle_to_angle(-pi / 2, -pi / 3, -pi / 4, :ZYX, :XYZ)
EulerAngles{Float64}:
  R(X) : -1.0472   rad  (-60.0°)
  R(Y) :  0.785398 rad  ( 45.0°)
  R(Z) : -1.5708   rad  (-90.0°)

julia> angle_to_angle(-pi / 2, 0, 0, :ZYX, :XYZ)
EulerAngles{Float64}:
  R(X) :  0.0    rad  ( 0.0°)
  R(Y) :  0.0    rad  ( 0.0°)
  R(Z) : -1.5708 rad  (-90.0°)

julia> Θ = EulerAngles(1, 2, 3, :XYX)
EulerAngles{Int64}:
  R(X) :  1 rad  ( 57.2958°)
  R(Y) :  2 rad  ( 114.592°)
  R(X) :  3 rad  ( 171.887°)

julia> angle_to_angle(Θ, :ZYZ)
EulerAngles{Float64}:
  R(Z) : -2.70239 rad  (-154.836°)
  R(Y) :  1.46676 rad  ( 84.0393°)
  R(Z) : -1.05415 rad  (-60.3984°)
```

## Euler Angles to Euler angle and axis

Euler angles can be converted to an Euler angle and axis using the following
functions:

```julia
function angle_to_angleaxis(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol = :ZYX)
function angle_to_angleaxis(Θ::EulerAngles)
```

```jldoctest
julia> angle_to_angleaxis(1, 0, 0, :XYZ)
EulerAngleAxis{Float64}:
  Euler angle : 1.0 rad  (57.2958°)
  Euler axis  : [1.0, 0.0, 0.0]

julia> Θ = EulerAngles(1, 1, 1, :XYZ);

julia> angle_to_angleaxis(Θ)
EulerAngleAxis{Float64}:
  Euler angle : 1.93909 rad  (111.102°)
  Euler axis  : [0.692363, 0.203145, 0.692363]
```

## Euler Angles to Quaternions

Euler angles can be converted to quaternions using the following functions:

```julia
function angle_to_quat(θ₁::Number[, θ₂::Number[, θ₃::Number]], rot_seq::Symbol = :ZYX)
function angle_to_quat(Θ::EulerAngles)
```

```jldoctest
julia> q = angle_to_quat(pi / 2, pi / 4, pi / 3, :ZYX)
Quaternion{Float64}:
  + 0.701057 + 0.092296⋅i + 0.560986⋅j + 0.430459⋅k

julia> angles = EulerAngles(pi / 2, pi / 4, pi / 3, :ZYX);

julia> q = angle_to_quat(angles)
Quaternion{Float64}:
  + 0.701057 + 0.092296⋅i + 0.560986⋅j + 0.430459⋅k
```

Suppose the user desires to obtain the quaternion that rotates the coordinate
system about only one or two axes. In that case, it is better to use the
following functions due to improved accuracy in some cases:

```
function angle_to_quat(θ₁::Number, rot_seq::Symbol)
function angle_to_quat(θ₁::Number, θ₂::Number, rot_seq::Symbol)
```

```jldoctest
julia> angle_to_quat(-pi / 4, :Z)
Quaternion{Float64}:
  + 0.92388 + 0.0⋅i + 0.0⋅j - 0.382683⋅k

julia> angle_to_quat(-pi / 4, pi / 7, :XY)
Quaternion{Float64}:
  + 0.900716 - 0.373089⋅i + 0.205583⋅j - 0.0851551⋅k
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
DCM{Float64}:
  0.999994     0.00299799   0.00200298
 -0.00299998   0.999995     0.000993989
 -0.00199999  -0.000999991  0.999998

julia> dcm = smallangle_to_dcm(0.001, -0.002, +0.003; normalize = false)
DCM{Float64}:
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
  + 0.999998 + 0.000499999⋅i - 0.000999998⋅j + 0.0015⋅k
```

!!! note
    The computed quaternion **is** normalized.

## Quaternions to Direction Cosine Matrices

A quaternion can be converted to DCM using the following method:

```julia
function quat_to_dcm(q::Quaternion)
```

```jldoctest
julia> q = Quaternion(cosd(22.5), sind(22.5), 0.0, 0.0);

julia> dcm = quat_to_dcm(q)
DCM{Float64}:
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
julia> v = [sqrt(3) / 3, sqrt(3) / 3, sqrt(3) / 3];

julia> a = 60.0 * pi / 180;

julia> q = Quaternion(cos(a / 2), v * sin(a / 2));

julia> quat_to_angleaxis(q)
EulerAngleAxis{Float64}:
  Euler angle : 1.0472 rad  (60.0°)
  Euler axis  : [0.57735, 0.57735, 0.57735]
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
  R(X) :  0.785398 rad  ( 45.0°)
  R(Y) :  0.0      rad  ( 0.0°)
  R(Z) :  0.0      rad  ( 0.0°)
```

# Julia API

All the rotation representations can be converted using the Julia API function
`convert`:

```jldoctest
julia> dcm = angle_to_dcm(pi / 4, pi / 7, pi / 5)
DCM{Float64}:
  0.637081   0.637081  -0.433884
 -0.391728   0.752395   0.529576
  0.663835  -0.167419   0.728899

julia> convert(Quaternion, dcm)
Quaternion{Float64}:
  + 0.882946 + 0.197349⋅i + 0.310811⋅j + 0.2913⋅k

julia> convert(EulerAngleAxis, dcm)
EulerAngleAxis{Float64}:
  Euler angle : 0.977391 rad  (56.0004°)
  Euler axis  : [0.420362, 0.662041, 0.620481]

julia> q = Quaternion(cos(pi / 4), 0, sin(pi / 4), 0)
Quaternion{Float64}:
  + 0.707107 + 0.0⋅i + 0.707107⋅j + 0.0⋅k

julia> convert(DCM, q)
DCM{Float64}:
 2.22045e-16  0.0  -1.0
 0.0          1.0   0.0
 1.0          0.0   2.22045e-16
```

If it is desired to convert to `EulerAngles`, then one should use the help
function `EulerAngles(rot_seq)`, where `rot_seq` is a symbol specifying the
rotation sequence. If `EulerAngles` is used, then it defaults to `ZYX` rotation
sequence:

```jldoctest
julia> dcm = angle_to_dcm(pi / 4, pi / 7, pi / 5)
DCM{Float64}:
  0.637081   0.637081  -0.433884
 -0.391728   0.752395   0.529576
  0.663835  -0.167419   0.728899

julia> convert(EulerAngles, dcm)
EulerAngles{Float64}:
  R(Z) :  0.785398 rad  ( 45.0°)
  R(Y) :  0.448799 rad  ( 25.7143°)
  R(X) :  0.628319 rad  ( 36.0°)

julia> convert(EulerAngles(:YXY), dcm)
EulerAngles{Float64}:
  R(Y) : -0.636877 rad  (-36.4903°)
  R(X) :  0.719106 rad  ( 41.2017°)
  R(Y) :  1.31382  rad  ( 75.2761°)

julia> convert(EulerAngles(:XYX), dcm)
EulerAngles{Float64}:
  R(X) :  0.972902 rad  ( 55.7432°)
  R(Y) :  0.880091 rad  ( 50.4255°)
  R(X) : -0.533107 rad  (-30.5448°)
```

Supporting this API enables us to perform interesting conversions like:

```jldoctest
julia> v = [
           Quaternion(cos(pi / 5), sin(pi / 5), 0, 0),
           angle_to_dcm(pi / 5, pi / 10, 1),
           EulerAngleAxis(0.54, [sqrt(2)/2, sqrt(2)/2, 0])
       ]
3-element Vector{Any}:
 Quaternion{Float64}: + 0.809017 + 0.587785⋅i + 0.0⋅j + 0.0⋅k
 [0.7694208842938134 0.5590169943749475 -0.3090169943749474; -0.10721398096693543 0.5899548616836684 0.8002864633748501; 0.6296798115691402 -0.5826261761848704 0.5138580287651915]
 EulerAngleAxis{Float64}: θ = 0.54 rad, v = [0.707107, 0.707107, 0.0]

julia> v = Quaternion[
           Quaternion(cos(pi / 5), sin(pi / 5), 0, 0),
           angle_to_dcm(pi / 5, pi / 10, 1),
           EulerAngleAxis(0.54, [sqrt(2)/2, sqrt(2)/2, 0])
       ]
3-element Vector{Quaternion}:
 Quaternion{Float64}: + 0.809017 + 0.587785⋅i + 0.0⋅j + 0.0⋅k
 Quaternion{Float64}: + 0.847531 + 0.407924⋅i + 0.276892⋅j + 0.196521⋅k
 Quaternion{Float64}: + 0.963771 + 0.188608⋅i + 0.188608⋅j + 0.0⋅k

julia> v = EulerAngleAxis[
           Quaternion(cos(pi / 5), sin(pi / 5), 0, 0),
           angle_to_dcm(pi / 5, pi / 10, 1),
           EulerAngleAxis(0.54, [sqrt(2)/2, sqrt(2)/2, 0])
       ]
3-element Vector{EulerAngleAxis}:
 EulerAngleAxis{Float64}: θ = 1.25664 rad, v = [1.0, 0.0, 0.0]
 EulerAngleAxis{Float64}: θ = 1.11896 rad, v = [0.768586, 0.521703, 0.370273]
 EulerAngleAxis{Float64}: θ = 0.54 rad, v = [0.707107, 0.707107, 0.0]
```
