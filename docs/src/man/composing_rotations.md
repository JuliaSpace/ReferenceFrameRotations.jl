# Composing rotations

```@meta
CurrentModule = ReferenceFrameRotations
```

```@setup composing_rotations
using ReferenceFrameRotations
```

Multiple rotations represented can be composed using the function:

```julia
compose_rotation(R1, R2, R3, R4...)
```

in which `R1`, `R2`, `R3`, ..., must be of the same type. This method returns the following
rotation:

![Composing rotations](../assets/Fig_Composing_Rotations.png)

Currently, this method supports DCMs, Euler angle and axis, Euler angles, and Quaternions.

```@repl composing_rotations
D1 = angle_to_dcm(0.5, 0.5, 0.5, :XYZ)

D2 = angle_to_dcm(-0.5, -0.5, -0.5, :ZYX)

compose_rotation(D1, D2)

ea1 = EulerAngleAxis(30 * pi / 180, [0, 1, 0])

ea2 = EulerAngleAxis(45 * pi / 180, [0, 1, 0])

compose_rotation(ea1, ea2)

Θ1 = EulerAngles(1, 2, 3, :ZYX)

Θ2 = EulerAngles(-3, -2, -1, :XYZ)

compose_rotation(Θ1, Θ2)

q1 = angle_to_quat(0.5, 0.5, 0.5, :XYZ)

q2 = angle_to_quat(-0.5, -0.5, -0.5, :ZYX)

compose_rotation(q1, q2)
```

## Operator ∘

The rotations can also be composed using the operator `∘`, which can be entered by typing
`\circ` and hitting `TAB` in REPL. In this case, the composition order is the same as those
used by DCMs, *i.e.*, the first rotation is the rightmost one.

```julia
R = R5 ∘ R4 ∘ R3 ∘ R2 ∘ R1
```

The advantage of using `∘` lies when composing rotations represented by different entities.
In this case, they will be automatically converted by the type of the left object.

```@repl composing_rotations
D = angle_to_dcm(0.5, 0, 0, :ZYX)

q = angle_to_quat(0.3, 0, 0, :ZXY)

D ∘ q

q ∘ D
```
