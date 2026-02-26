# Inverting rotations

```@meta
CurrentModule = ReferenceFrameRotations
```

```@setup inv_rotations
using ReferenceFrameRotations
```

A rotation represented by DCM, Euler angle and axis, Euler angles, quaternion, CRP, or MRP
can be inverted using the function:

```julia
inv_rotation(R)
```

in which `R` must be one of the supported rotation types.

!!! note

    If `R` is a DCM, then the transpose matrix will be returned. Hence, the user must ensure
    that the input matrix is ortho-normalized. Otherwise, the result will not be the inverse
    matrix of the input.

    If `R` is a Quaternion, then the conjugate quaternion will be returned. Hence, the user
    must ensure that the input quaternion is normalized (have unit norm). Otherwise, the
    result will not be the inverse quaternion of the input.

    For Euler angle and axis, Euler angles, CRP, and MRP, the type-specific `inv` method is
    used.

    These behaviors were selected to alleviate the computational burden.

```@repl inv_rotations
D1 = angle_to_dcm(0.5, 0.5, 0.5, :XYZ)

D2 = inv_rotation(D1)

D2 * D1

q1 = angle_to_quat(0.5, 0.5, 0.5, :XYZ)

q2 = inv_rotation(q1)

q2 * q1

c1 = angle_to_crp(0.5, 0.2, -0.1, :XYZ)

c2 = inv_rotation(c1)

c2 * c1

m1 = angle_to_mrp(0.5, 0.2, -0.1, :XYZ)

m2 = inv_rotation(m1)

m2 * m1
```
