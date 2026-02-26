# Conversions

```@meta
CurrentModule = ReferenceFrameRotations
```

```@setup conversions
using LinearAlgebra
using ReferenceFrameRotations
```

There are several functions available to convert between the different types of 3D rotation
representations.

## CRPs to DCMs

A Classical Rodrigues Parameter (CRP) can be converted to DCM using the following method:

```julia
function crp_to_dcm(c::CRP)
```

```@repl conversions
c = CRP(0.1, 0.2, -0.1)

crp_to_dcm(c)
```

## CRPs to Euler Angle and Axis

A CRP can be converted to Euler angle and axis using the following method:

```julia
function crp_to_angleaxis(c::CRP)
```

```@repl conversions
c = CRP(0.1, 0.2, -0.1)

crp_to_angleaxis(c)
```

## CRPs to Euler Angles

A CRP can be converted to Euler angles using the following method:

```julia
function crp_to_angle(c::CRP, rot_seq::Symbol = :ZYX)
```

```@repl conversions
c = CRP(0.1, 0.2, -0.1)

crp_to_angle(c, :XYZ)
```

## CRPs to MRPs

A CRP can be converted to MRP using the following method:

```julia
function crp_to_mrp(c::CRP)
```

```@repl conversions
c = CRP(0.1, 0.2, -0.1)

crp_to_mrp(c)
```

## CRPs to Quaternions

A CRP can be converted to quaternions using the following method:

```julia
function crp_to_quat(c::CRP)
```

```@repl conversions
c = CRP(0.1, 0.2, -0.1)

crp_to_quat(c)
```

## DCMs to CRP

A Direct Cosine Matrix (DCM) can be converted to CRP using the following method:

```julia
function dcm_to_crp(dcm::DCM)
```

```@repl conversions
dcm = angle_to_dcm(0.2, -0.1, 0.3, :ZYX)

dcm_to_crp(dcm)
```

## DCMs to Euler Angles

A DCM can be converted to Euler Angles using the following function:

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

```@repl conversions
dcm = DCM([1 0 0; 0 0 -1; 0 1 0])

dcm_to_angle(dcm)

dcm_to_angle(dcm, :XYZ)

D = angle_to_dcm(1, -pi / 2, 2, :ZYX)

dcm_to_angle(D, :ZYX)

D = angle_to_dcm(1, :X) * angle_to_dcm(2, :X)

dcm_to_angle(D, :XYX)
```

## DCMs to Euler Angle and Axis

A DCM can be converto to an Euler angle and axis representation using the following method:

```julia
function dcm_to_angleaxis(dcm::DCM)
```

```@repl conversions
dcm = DCM([1.0 0.0 0.0; 0.0 0.0 -1.0; 0.0 1.0 0.0])

ea  = dcm_to_angleaxis(dcm)
```

## DCMs to MRP

A DCM can be converted to MRP using the following method:

```julia
function dcm_to_mrp(dcm::DCM)
```

```@repl conversions
dcm = angle_to_dcm(0.2, -0.1, 0.3, :ZYX)

dcm_to_mrp(dcm)
```

## DCMs to Quaternions

A DCM can be converted to quaternion using the following method:

```julia
function dcm_to_quat(dcm::DCM)
```

```@repl conversions
dcm = DCM([1.0 0.0 0.0; 0.0 0.0 -1.0; 0.0 1.0 0.0])

q = dcm_to_quat(dcm)
```

## Euler Angles to CRP

Euler angles can be converted to CRP using the following functions:

```julia
function angle_to_crp(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol = :ZYX)
function angle_to_crp(Θ::EulerAngles)
```

```@repl conversions
angle_to_crp(0.2, -0.1, 0.3, :ZYX)

Θ = EulerAngles(0.2, -0.1, 0.3, :XYZ)

angle_to_crp(Θ)
```

!!! note

    CRP is singular for rotations of ``180^\circ``.

## Euler Angle and Axis to DCMs

An Euler angle and axis representation can be converted to DCM using using these two
methods:

```julia
function angleaxis_to_dcm(a::Number, v::AbstractVector)
function angleaxis_to_dcm(ea::EulerAngleAxis)
```

```@repl conversions
a = 60.0 * pi / 180;

v = [sqrt(3) / 3, sqrt(3) / 3, sqrt(3)/3]

angleaxis_to_dcm(a, v)

angleaxis = EulerAngleAxis(a, v)

angleaxis_to_dcm(angleaxis)
```

## Euler Angle and Axis to Euler Angles

An Euler angle and axis representation can be converto to Euler angles using these two
methods:

```julia
function angleaxis_to_angle(θ::Number, v::AbstractVector, rot_seq::Symbol)
function angleaxis_to_angle(ea::EulerAngleAxis, rot_seq::Symbol)
```

```@repl conversions
a = 19.86 * pi / 180

v = [0, 1, 0]

angleaxis_to_angle(a, v, :XYX)

a = 60.0 * pi / 180

v = [sqrt(3) / 3, sqrt(3) / 3, sqrt(3) / 3]

angleaxis = EulerAngleAxis(a, v)

angleaxis_to_angle(angleaxis, :XYZ)

angleaxis_to_angle(angleaxis, :ZYX)
```

## Euler Angle and Axis to Quaternions

An Euler angle and axis representation can be converted to quaternion using these two
methods:

```julia
function angleaxis_to_quat(a::Number, v::AbstractVector)
function angleaxis_to_quat(angleaxis::EulerAngleAxis)
```

```@repl conversions
a = 60.0 * pi / 180

v = [sqrt(3) / 3, sqrt(3) / 3, sqrt(3) / 3]

angleaxis_to_quat(a,v)

angleaxis = EulerAngleAxis(a,v)

angleaxis_to_quat(angleaxis)
```

## Euler Angles to DCMs

Euler angles can be converted to DCMs using the following functions:

```julia
function angle_to_dcm(θ₁::Number[, θ₂::Number[, θ₃::Number]], rot_seq::Symbol = :ZYX)
function angle_to_dcm(Θ::EulerAngles)
```

```@repl conversions
dcm = angle_to_dcm(pi / 2, pi / 4, pi / 3, :ZYX)

angles = EulerAngles(pi / 2, pi / 4, pi / 3, :ZYX);

dcm = angle_to_dcm(angles)
```

Suppose the user desires to obtain the DCM that rotates the coordinate system about only one
or two axes. In that case, it is better to use the following functions due to improved
accuracy in some cases:

```julia
function angle_to_dcm(θ₁::Number, rot_seq::Symbol)
function angle_to_dcm(θ₁::Number, θ₂::Number, rot_seq::Symbol)
```

```@repl conversions
angle_to_dcm(-pi / 4, :Z)

angle_to_dcm(-pi / 4, pi / 7, :XY)
```

## Euler Angles to Euler Angles

It is possible to change the rotation sequence of a set of Euler angles using the following
functions:

```julia
function angle_to_angle(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq_orig::Symbol, rot_seq_dest::Symbol)
function angle_to_angle(Θ::EulerAngles, rot_seq_dest::Symbol)
```

in which `rot_seq_dest` is the desired rotation sequence of the result.

```@repl conversions
angle_to_angle(-pi / 2, -pi / 3, -pi / 4, :ZYX, :XYZ)

angle_to_angle(-pi / 2, 0, 0, :ZYX, :XYZ)

Θ = EulerAngles(1, 2, 3, :XYX)

angle_to_angle(Θ, :ZYZ)
```

## Euler Angles to Euler Angle and Axis

Euler angles can be converted to an Euler angle and axis using the following functions:

```julia
function angle_to_angleaxis(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol = :ZYX)
function angle_to_angleaxis(Θ::EulerAngles)
```

```@repl conversions
angle_to_angleaxis(1, 0, 0, :XYZ)

Θ = EulerAngles(1, 1, 1, :XYZ)

angle_to_angleaxis(Θ)
```

## Euler Angles to MRP

Euler angles can be converted to MRP using the following functions:

```julia
function angle_to_mrp(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol = :ZYX)
function angle_to_mrp(Θ::EulerAngles)
```

```@repl conversions
angle_to_mrp(0.2, -0.1, 0.3, :ZYX)

Θ = EulerAngles(0.2, -0.1, 0.3, :XYZ)

angle_to_mrp(Θ)
```

## Euler Angles to Quaternions

Euler angles can be converted to quaternions using the following functions:

```julia
function angle_to_quat(θ₁::Number[, θ₂::Number[, θ₃::Number]], rot_seq::Symbol = :ZYX)
function angle_to_quat(Θ::EulerAngles)
```

```@repl conversions
q = angle_to_quat(pi / 2, pi / 4, pi / 3, :ZYX)

angles = EulerAngles(pi / 2, pi / 4, pi / 3, :ZYX)

q = angle_to_quat(angles)
```

Suppose the user desires to obtain the quaternion that rotates the coordinate system about
only one or two axes. In that case, it is better to use the following functions due to
improved accuracy in some cases:

```julia
function angle_to_quat(θ₁::Number, rot_seq::Symbol)
function angle_to_quat(θ₁::Number, θ₂::Number, rot_seq::Symbol)
```

```@repl conversions
angle_to_quat(-pi / 4, :Z)

angle_to_quat(-pi / 4, pi / 7, :XY)
```

## MRPs to CRP

A Modified Rodrigues Parameter (MRP) can be converted to CRP using the following method:

```julia
function mrp_to_crp(m::MRP)
```

```@repl conversions
m = MRP(0.1, 0.2, -0.1)

mrp_to_crp(m)
```

!!! note

    CRP is singular for rotations of ``180^\circ``. Therefore, `mrp_to_crp` is singular for
    MRP vectors with norm equal to 1.


## MRPs to DCMs

A MRP can be converted to DCM using the following method:

```julia
function mrp_to_dcm(m::MRP)
```

```@repl conversions
m = MRP(0.1, 0.2, -0.1)

mrp_to_dcm(m)
```

## MRPs to Euler Angle and Axis

A MRP can be converted to Euler angle and axis using the following method:

```julia
function mrp_to_angleaxis(m::MRP)
```

```@repl conversions
m = MRP(0.1, 0.2, -0.1)

mrp_to_angleaxis(m)
```

## MRPs to Euler Angles

A MRP can be converted to Euler angles using the following method:

```julia
function mrp_to_angle(m::MRP, rot_seq::Symbol = :ZYX)
```

```@repl conversions
m = MRP(0.1, 0.2, -0.1)

mrp_to_angle(m, :XYZ)
```

## MRPs to Quaternions

A MRP can be converted to quaternions using the following method:

```julia
function mrp_to_quat(m::MRP)
```

```@repl conversions
m = MRP(0.1, 0.2, -0.1)

mrp_to_quat(m)
```

## Small Euler Angles to DCMs

Small Euler angles can be converted to DCMs using the following function:

```julia
function smallangle_to_dcm(θx::Number, θy::Number, θz::Number; normalize = true)
```

in which the resulting matrix will be orthonormalized if the keyword `normalize`
is `true`.

```@repl conversions
dcm = smallangle_to_dcm(0.001, -0.002, +0.003)

dcm = smallangle_to_dcm(0.001, -0.002, +0.003; normalize = false)
```

## Small Euler Angles to Quaternions

Small Euler angles can be converted to quaternions using the following function:

```julia
function smallangle_to_quat(θx::Number, θy::Number, θz::Number)
```

```@repl conversions
q = smallangle_to_quat(0.001, -0.002, +0.003)
```

!!! note

    The computed quaternion **is** normalized.

## Quaternions to DCMs

A quaternion can be converted to DCM using the following method:

```julia
function quat_to_dcm(q::Quaternion)
```

```@repl conversions
q = Quaternion(cosd(22.5), sind(22.5), 0.0, 0.0)

dcm = quat_to_dcm(q)
```

## Quaternions to Euler Angle and Axis

A quaternion can be converted to Euler Angle and Axis representation using the following
function:

```julia
function quat_to_angleaxis(q::Quaternion)
```

```@repl conversions
v = [sqrt(3) / 3, sqrt(3) / 3, sqrt(3) / 3]

a = 60.0 * pi / 180

q = Quaternion(cos(a / 2), v * sin(a / 2))

quat_to_angleaxis(q)
```

## Quaternions to Euler Angles

There is one method to convert quaternions to Euler Angles:

```julia
function quat_to_angle(q::Quaternion, rot_seq=:ZYX)
```

However, it first transforms the quaternion to DCM using `quat_to_dcm` and then transforms
the DCM into the Euler Angles. Hence, the performance will be poor. The improvement of this
conversion will be addressed in a future version of **ReferenceFrameRotations.jl**.

```@repl conversions
q = Quaternion(cosd(22.5), sind(22.5), 0.0, 0.0)

quat_to_angle(q, :XYZ)
```

## Quaternions to MRP

A quaternion can be converted to MRP using the following method:

```julia
function quat_to_mrp(q::Quaternion)
```

```@repl conversions
q = angle_to_quat(0.2, -0.1, 0.3, :ZYX)

quat_to_mrp(q)
```

## Julia API

All the rotation representations can be converted using the Julia API function `convert`:

```@repl conversions
dcm = angle_to_dcm(pi / 4, pi / 7, pi / 5)

convert(Quaternion, dcm)

convert(EulerAngleAxis, dcm)

q = Quaternion(cos(pi / 4), 0, sin(pi / 4), 0)

convert(DCM, q)

convert(CRP, q)

convert(MRP, q)
```

If it is desired to convert to `EulerAngles`, then one should use the help function
`EulerAngles(rot_seq)`, where `rot_seq` is a symbol specifying the rotation sequence. If
`EulerAngles` is used, then it defaults to `ZYX` rotation sequence:

```@repl conversions
dcm = angle_to_dcm(pi / 4, pi / 7, pi / 5)

convert(EulerAngles, dcm)

convert(EulerAngles(:YXY), dcm)

convert(EulerAngles(:XYX), dcm)
```

Supporting this API enables us to perform interesting conversions like:

```@repl conversions
v = [
    Quaternion(cos(pi / 5), sin(pi / 5), 0, 0),
    angle_to_dcm(pi / 5, pi / 10, 1),
    EulerAngleAxis(0.54, [sqrt(2)/2, sqrt(2)/2, 0])
]

v = Quaternion[
    Quaternion(cos(pi / 5), sin(pi / 5), 0, 0),
    angle_to_dcm(pi / 5, pi / 10, 1),
    EulerAngleAxis(0.54, [sqrt(2)/2, sqrt(2)/2, 0])
]

v = EulerAngleAxis[
    Quaternion(cos(pi / 5), sin(pi / 5), 0, 0),
    angle_to_dcm(pi / 5, pi / 10, 1),
    EulerAngleAxis(0.54, [sqrt(2)/2, sqrt(2)/2, 0])
]
```
