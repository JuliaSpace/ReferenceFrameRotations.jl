export inv_rotation

################################################################################
#                              Inverse Rotations
################################################################################

"""
    @inline function inv_rotation(R)

Compute the inverse rotation of `R`, which can be:

* A direction cosina matrix (`DCM`);
* An Euler angle and axis (`EulerAngleAxis`);
* A set of Euler anlges (`EulerAngles`); or
* A quaternion (`Quaternion`).

The output will have the same type as `R` (DCM or quaternion).

# Remarks

If `R` is a DCM, than its transpose is computed instead of its inverse to reduce
the computational burden. The both are equal if the DCM has unit norm. This must
be verified by the user.

If `R` is a quaternion, than its conjugate is computed instead of its inverse to
reduce the computational burden. The both are equal if the quaternion has unit
norm. This must be verified by the used.

# Example

```julia-repl
julia> D = angle_to_dcm(+pi/3,+pi/4,+pi/5,:ZYX);

julia> inv_rotation(D)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  0.353553  -0.492816  0.795068
  0.612372   0.764452  0.201527
 -0.707107   0.415627  0.572061

julia> ea = EulerAngleAxis(30*pi/180, [1;0;0]);

julia> inv_rotation(ea)
EulerAngleAxis{Float64}:
  Euler angle:   0.5236 rad ( 30.0000 deg)
   Euler axis: [ -1.0000,  -0.0000,  -0.0000]

julia> Θ = EulerAngles(-pi/3, -pi/2, -pi, :YXZ);

julia> inv_rotation(Θ)
EulerAngles{Float64}:
  R(Z):   3.1416 rad ( 180.0000 deg)
  R(X):   1.5708 rad (  90.0000 deg)
  R(Y):   1.0472 rad (  60.0000 deg)

julia> q = angle_to_quat(+pi/3,+pi/4,+pi/5,:ZYX);

julia> inv_rotation(q)
Quaternion{Float64}:
  + 0.8200711519756747 - 0.06526868310243991.i - 0.45794027732580056.j - 0.336918398289752.k
```

"""
@inline inv_rotation(D::DCM) = D'
@inline inv_rotation(ea::EulerAngleAxis) = inv(ea)
@inline inv_rotation(Θ::EulerAngles) = inv(Θ)
@inline inv_rotation(q::Quaternion) = conj(q)
