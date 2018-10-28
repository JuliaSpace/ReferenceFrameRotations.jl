Inverting rotations
===================

```@meta
CurrentModule = ReferenceFrameRotations
DocTestSetup = quote
    using ReferenceFrameRotations
end
```

A rotation represented by direction cosine matrix or quaternion can be inverted
using the function:

```julia
inv_rotation(R)
```

in which `R` must be a DCM or a Quaternion.

!!! note

    If `R` is a DCM, then the transpose matrix will be returned. Hence, the user
    must ensure that the input matrix is ortho-normalized. Otherwise, the result
    will not be the inverse matrix of the input.
    
    If `R` is a Quaternion, then the conjugate quaternion will be returned.
    Hence, the user must ensure that the input quaternion is normalized (have
    unit norm). Otherwise, the result will not be the inverse quaternion of the
    input.

    These behaviors were selected to alleviate the computational burden.


```jldoctest
julia> D1 = angle_to_dcm(0.5,0.5,0.5,:XYZ);

julia> D2 = inv_rotation(D1)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  0.770151  -0.420735   0.479426
  0.622447   0.659956  -0.420735
 -0.139381   0.622447   0.770151

julia> D2*D1
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
 1.0          2.77556e-17  0.0
 2.77556e-17  1.0          5.55112e-17
 0.0          5.55112e-17  1.0

julia> q1 = angle_to_quat(0.5,0.5,0.5,:XYZ);

julia> q2 = inv_rotation(q1)
Quaternion{Float64}:
  + 0.89446325406638 - 0.29156656802867026.i - 0.17295479161025828.j - 0.29156656802867026.k

julia> q2*q1
Quaternion{Float64}:
  + 0.9999999999999998 + 0.0.i - 1.3877787807814457e-17.j + 0.0.k
```
