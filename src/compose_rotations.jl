export compose_rotation

################################################################################
#                              Compose Rotations
################################################################################

#                          Direction Cosine Matrices
# ==============================================================================

"""
### @inline function compose_rotation(R1, R2 [, R3, R4, R5, ...])

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
* R2: Second rotation (DCM or quaternion).
* R3, R4, R5, ...: (OPTIONAL) Other rotations (DCMs or quaternions).

##### Returns

The composed rotation.

"""

# TODO: It turns out that after 5 multiplications, the function with a `for`
# performs better in a specific computer. This needs further verification.

@inline compose_rotation(D1::SMatrix{3,3},
                         D2::SMatrix{3,3}) = D2*D1
@inline compose_rotation(D1::SMatrix{3,3},
                         D2::SMatrix{3,3},
                         D3::SMatrix{3,3}) = D3*D2*D1
@inline compose_rotation(D1::SMatrix{3,3},
                         D2::SMatrix{3,3},
                         D3::SMatrix{3,3},
                         D4::SMatrix{3,3}) =
    D4*D3*D2*D1
@inline compose_rotation(D1::SMatrix{3,3},
                         D2::SMatrix{3,3},
                         D3::SMatrix{3,3},
                         D4::SMatrix{3,3},
                         D5::SMatrix{3,3}) =
    D5*D4*D3*D2*D1

@inline function compose_rotation(D1::SMatrix{3,3}, D2::SMatrix{3,3}, Ds::SMatrix{3,3}...)
    result = D2*D1

    for Di in Ds
        result = Di*result
    end

    result
end

@inline compose_rotation(q1::Quaternion, q2::Quaternion) = q1*q2
@inline compose_rotation(q1::Quaternion,
                         q2::Quaternion,
                         q3::Quaternion) = q1*q2*q3
@inline compose_rotation(q1::Quaternion,
                         q2::Quaternion,
                         q3::Quaternion,
                         q4::Quaternion) = q1*q2*q3*q4
@inline compose_rotation(q1::Quaternion,
                         q2::Quaternion,
                         q3::Quaternion,
                         q4::Quaternion,
                         q5::Quaternion) = q1*q2*q3*q4*q5

@inline function compose_rotation(q1::Quaternion,
                                  q2::Quaternion,
                                  qs::Quaternion...)
    result = q1*q2

    for qi in qs
        result = result*qi
    end

    result
end
