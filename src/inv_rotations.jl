export inv_rotation

################################################################################
#                              Inverse Rotations
################################################################################

"""
    @inline function inv_rotation(R)

Compute the inverse rotation of `R`, which can be a Direction Cosine Matrix or
Quaternion.

The output will have the same type as `R` (DCM or quaternion).

# Args

* `R`: Rotation that will be inversed.

# Returns

The inverse rotation.

# Remarks

If `R` is a DCM, than its transpose is computed instead of its inverse to reduce
the computational burden. The both are equal if the DCM has unit norm. This must
be verified by the used.

If `R` is a quaternion, than its conjugate is computed instead of its inverse to
reduce the computational burden. The both are equal if the quaternion has unit
norm. This must be verified by the used.

# Example

```julia-repl
julia> D = angle2dcm(+pi/3,+pi/4,+pi/5,:ZYX);

julia> inv_rotation(D)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  0.353553  -0.492816  0.795068
  0.612372   0.764452  0.201527
 -0.707107   0.415627  0.572061

julia> q = angle2quat(+pi/3,+pi/4,+pi/5,:ZYX);

julia> inv_rotation(q)
Quaternion{Float64}:
  + 0.8200711519756747 - 0.06526868310243991.i - 0.45794027732580056.j - 0.336918398289752.k
```

"""
@inline inv_rotation(D::DCM) = D'
@inline inv_rotation(q::Quaternion) = conj(q)
