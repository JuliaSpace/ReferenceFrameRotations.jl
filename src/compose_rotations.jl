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

The rotations can be described by Direction Cosine Matrices or Quaternions.
Notice, however, that all rotations **must be** of the same type (DCM or
quaternion).

The output will have the same type as the inputs (DCM or quaternion).

# Example

```julia-repl
julia> D1 = angle2dcm(+pi/3,+pi/4,+pi/5,:ZYX);

julia> D2 = angle2dcm(-pi/5,-pi/4,-pi/3,:XYZ);

julia> compose_rotation(D1,D2)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
 1.0          0.0          5.55112e-17
 0.0          1.0          5.55112e-17
 5.55112e-17  5.55112e-17  1.0

julia> q1 = angle2quat(+pi/3,+pi/4,+pi/5,:ZYX);

julia> q2 = angle2quat(-pi/5,-pi/4,-pi/3,:XYZ);

julia> compose_rotation(q1,q2)
Quaternion{Float64}:
  + 1.0 + 0.0.i + 2.0816681711721685e-17.j + 5.551115123125783e-17.k
```

"""
@inline compose_rotation(D::DCM) = D
@inline compose_rotation(D::DCM, Ds::DCM...) = compose_rotation(Ds...)*D

@inline compose_rotation(q::Quaternion) = q
@inline compose_rotation(q::Quaternion, qs::Quaternion...) =
    q*compose_rotation(qs...)

# This algorithm was proposed by @Per in
#
#   https://discourse.julialang.org/t/improve-the-performance-of-multiplication-of-an-arbitrary-number-of-matrices/10835/24
