export compose_rotation

################################################################################
#                              Compose Rotations
################################################################################

"""
### @inline function compose_rotation(R1, [, R2, R3, R4, R5, ...])

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

##### Args

* R1: First rotation (DCM or quaternion).
* R2, R3, R4, R5, ...: (OPTIONAL) Other rotations (DCMs or quaternions).

##### Returns

The composed rotation.

"""
@inline compose_rotation(D::DCM) = D
@inline compose_rotation(D::DCM, Ds::DCM...) = compose_rotation(Ds...)*D

@inline compose_rotation(q::Quaternion) = q
@inline compose_rotation(q::Quaternion, qs::Quaternion...) =
    q*compose_rotation(qs...)

# This algorithm was proposed by @Per in
#
#   https://discourse.julialang.org/t/improve-the-performance-of-multiplication-of-an-arbitrary-number-of-matrices/10835/24
