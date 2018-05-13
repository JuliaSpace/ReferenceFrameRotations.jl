export inv_rotation

################################################################################
#                              Inverse Rotations
################################################################################

"""
### @inline function inv_rotation(R)

Compute the inverse rotation of `R`, which can be a Direction Cosine Matrix or
Quaternion.

The output will have the same type as `R` (DCM or quaternion).

##### Args

* R: Rotation that will be inversed.

##### Returns

The inverse rotation.

##### Remarks

If `R` is a DCM, than its transpose is computed instead of its inverse to reduce
the computational burden. The both are equal if the DCM has unit norm. This must
be verified by the used.

If `R` is a quaternion, than its conjugate is computed instead of its inverse to
reduce the computational burden. The both are equal if the quaternion has unit
norm. This must be verified by the used.

"""
@inline inv_rotation(D::DCM) = D'
@inline inv_rotation(q::Quaternion) = conj(q)
