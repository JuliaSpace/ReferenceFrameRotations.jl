# Inverting rotations

```@meta
CurrentModule = ReferenceFrameRotations
```

```@setup inv_rotations
using ReferenceFrameRotations
```

A rotation represented by direction cosine matrix or quaternion can be inverted using the
function:

```julia
inv_rotation(R)
```

in which `R` must be a DCM or a Quaternion.

!!! note

    If `R` is a DCM, then the transpose matrix will be returned. Hence, the user must ensure
    that the input matrix is ortho-normalized. Otherwise, the result will not be the inverse
    matrix of the input.

    If `R` is a Quaternion, then the conjugate quaternion will be returned. Hence, the user
    must ensure that the input quaternion is normalized (have unit norm). Otherwise, the
    result will not be the inverse quaternion of the input.

    These behaviors were selected to alleviate the computational burden.

```@repl inv_rotations
D1 = angle_to_dcm(0.5, 0.5, 0.5, :XYZ)

D2 = inv_rotation(D1)

D2 * D1

q1 = angle_to_quat(0.5, 0.5, 0.5, :XYZ)

q2 = inv_rotation(q1)

q2 * q1
```
