## Description #############################################################################
#
# Generic function to inverse rotations.
#
############################################################################################

export inv_rotation

############################################################################################
#                                    Inverse Rotations                                     #
############################################################################################

"""
    inv_rotation(R::T) -> T

Compute the inverse rotation of `R`, which can be:

- A direction cosine matrix (`DCM`);
- An Euler angle and axis (`EulerAngleAxis`);
- A set of Euler angles (`EulerAngles`);
- A quaternion (`Quaternion`);
- A classical Rodrigues parameter (`CRP`); or
- A modified Rodrigues parameter (`MRP`).

The output will have the same type as `R`.

!!! note

    If `R` is a DCM, than its transpose is computed instead of its inverse to reduce the
    computational burden. The both are equal if the DCM has unit norm. This must be verified
    by the user.

!!! note

    If `R` is a quaternion, than its conjugate is computed instead of its inverse to reduce
    the computational burden. The both are equal if the quaternion has unit norm. This must
    be verified by the user.

# Example

```jldoctest
julia> D = angle_to_dcm(pi / 3, pi / 4, pi / 5, :ZYX);

julia> inv_rotation(D)
DCM{Float64}:
  0.353553  -0.492816  0.795068
  0.612372   0.764452  0.201527
 -0.707107   0.415627  0.572061

julia> ea = EulerAngleAxis(30 * pi / 180, [1, 0, 0]);

julia> inv_rotation(ea)
EulerAngleAxis{Float64}:
  Euler angle : 0.523599 rad  (30.0°)
  Euler axis  : [-1.0, -0.0, -0.0]

julia> Θ = EulerAngles(-pi / 3, -pi / 2, -pi, :YXZ);

julia> inv_rotation(Θ)
EulerAngles{Float64}:
  R(Z) :  3.14159 rad  ( 180.0°)
  R(X) :  1.5708  rad  ( 90.0°)
  R(Y) :  1.0472  rad  ( 60.0°)

julia> q = angle_to_quat(pi / 3, pi / 4, pi / 5, :ZYX);

julia> inv_rotation(q)
Quaternion{Float64}:
  + 0.820071 - 0.0652687⋅i - 0.45794⋅j - 0.336918⋅k
```
"""
@inline inv_rotation(D::DCM) = D'
@inline inv_rotation(ea::EulerAngleAxis) = inv(ea)
@inline inv_rotation(Θ::EulerAngles) = inv(Θ)
@inline inv_rotation(q::Quaternion) = conj(q)
@inline inv_rotation(q::CRP) = inv(q)
@inline inv_rotation(s::MRP) = inv(s)
