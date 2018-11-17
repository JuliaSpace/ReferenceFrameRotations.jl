export compose_rotation

################################################################################
#                              Compose Rotations
################################################################################

"""
    @inline function compose_rotation(R1, [, R2, R3, R4, R5, ...])

Compute a composed rotation using the rotations `R1`, `R2`, `R3`, `R4`, ..., in
the following order:

     First rotation
     |
     |
    R1 => R2 => R3 => R4 => ...
           |
           |
           Second rotation

The rotations can be described by:

* A direction cosina matrix (`DCM`);
* An Euler angle and axis (`EulerAngleAxis`);
* A set of Euler anlges (`EulerAngles`); or
* A quaternion (`Quaternion`).

Notice, however, that all rotations **must be** of the same type (DCM or
quaternion).

The output will have the same type as the inputs.

# Example

```julia-repl
julia> D1 = angle_to_dcm(+pi/3,+pi/4,+pi/5,:ZYX);

julia> D2 = angle_to_dcm(-pi/5,-pi/4,-pi/3,:XYZ);

julia> compose_rotation(D1,D2)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
 1.0          0.0          5.55112e-17
 0.0          1.0          5.55112e-17
 5.55112e-17  5.55112e-17  1.0

julia> ea1 = EulerAngleAxis(30*pi/180, [0;1;0]);

julia> ea2 = EulerAngleAxis(45*pi/180, [0;1;0]);

julia> compose_rotation(ea1,ea2)
EulerAngleAxis{Float64}:
  Euler angle:   1.3090 rad ( 75.0000 deg)
   Euler axis: [  0.0000,   1.0000,   0.0000]

julia> Θ1 = EulerAngles(1,2,3,:ZYX);

julia> Θ2 = EulerAngles(-3,-2,-1,:XYZ);

julia> compose_rotation(Θ1, Θ2)
EulerAngles{Float64}:
  R(X):  -0.0000 rad (  -0.0000 deg)
  R(Y):   0.0000 rad (   0.0000 deg)
  R(Z):  -0.0000 rad (  -0.0000 deg)

julia> q1 = angle_to_quat(+pi/3,+pi/4,+pi/5,:ZYX);

julia> q2 = angle_to_quat(-pi/5,-pi/4,-pi/3,:XYZ);

julia> compose_rotation(q1,q2)
Quaternion{Float64}:
  + 1.0 + 0.0.i + 2.0816681711721685e-17.j + 5.551115123125783e-17.k
```
"""
@inline compose_rotation(D::DCM) = D
@inline compose_rotation(D::DCM, Ds::DCM...) = compose_rotation(Ds...)*D

@inline compose_rotation(ea::EulerAngleAxis) = ea
@inline compose_rotation(ea::EulerAngleAxis, eas::EulerAngleAxis...) =
    compose_rotation(eas...)*ea

@inline compose_rotation(Θ::EulerAngles) = Θ
@inline compose_rotation(Θ::EulerAngles, Θs::EulerAngles...) =
    compose_rotation(Θs...)*Θ

@inline compose_rotation(q::Quaternion) = q
@inline compose_rotation(q::Quaternion, qs::Quaternion...) =
    q*compose_rotation(qs...)

# This algorithm was proposed by @Per in
#
#   https://discourse.julialang.org/t/improve-the-performance-of-multiplication-of-an-arbitrary-number-of-matrices/10835/24
