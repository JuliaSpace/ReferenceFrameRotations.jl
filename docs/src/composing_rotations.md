Composing rotations
===================

```@meta
CurrentModule = ReferenceFrameRotations
DocTestSetup = quote
    using ReferenceFrameRotations
end
```

Multiple rotations represented by direction cosine matrices or quaternions can
be composed using the function:

```julia
compose_rotation(R1,R2,R3,R4...)
```

in which `R1`, `R2`, `R3`, ..., must be simultaneously DCMs or Quaternions. This
method returns the following rotation:

![](./assets/Fig_Composing_Rotations.png)

```jldoctest
julia> D1 = angle2dcm(0.5,0.5,0.5,:XYZ)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  0.770151   0.622447  -0.139381
 -0.420735   0.659956   0.622447
  0.479426  -0.420735   0.770151

julia> D2 = angle2dcm(-0.5,-0.5,-0.5,:ZYX)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
  0.770151  -0.420735   0.479426
  0.622447   0.659956  -0.420735
 -0.139381   0.622447   0.770151

julia> compose_rotation(D1,D2)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
 1.0          2.77556e-17  0.0
 2.77556e-17  1.0          5.55112e-17
 0.0          5.55112e-17  1.0

julia> q1 = angle2quat(0.5,0.5,0.5,:XYZ);

julia> q2 = angle2quat(-0.5,-0.5,-0.5,:ZYX);

julia> compose_rotation(q1,q2)
Quaternion{Float64}:
  + 0.9999999999999998 + 0.0.i + 0.0.j + 0.0.k
```
