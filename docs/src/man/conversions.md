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

```jldoctest
julia> dcm = DCM([1 0 0; 0 0 -1; 0 1 0]);

julia> dcm_to_angle(dcm)
EulerAngles{Float64}(0.0, 0.0, -1.5707963267948966, :ZYX)

julia> dcm_to_angle(dcm, :XYZ)
EulerAngles{Float64}(-1.5707963267948966, 0.0, 0.0, :XYZ)
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

```
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

### Euler Angles to Quaternions

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
function smallangle_to_dcm(θx::Number, θy::Number, θz::Number)
```

```jldoctest
julia> dcm = smallangle_to_dcm(0.001, -0.002, +0.003)
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

### Quaternions to Euler Angle and Axis

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
EulerAngleAxis{Float64}(1.0471975511965974, [0.57735, 0.57735, 0.57735])
```

### Quaternions to Euler Angles

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
EulerAngles{Float64}(0.7853981633974484, 0.0, 0.0, :XYZ)
```
