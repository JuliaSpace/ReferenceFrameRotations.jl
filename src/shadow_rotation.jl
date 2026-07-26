## Description #############################################################################
#
# Functions to compute the shadow rotation.
#
############################################################################################

export shadow_rotation

"""
    shadow_rotation(c::CRP) -> CRP

Compute the shadow rotation of the CRP `c`.

The shadow rotation of a CRP is the rotation itself: `c`.
"""
@inline shadow_rotation(c::CRP) = c

"""
    shadow_rotation(m::MRP) -> MRP

Compute the shadow rotation `-m / |m|²` of the MRP `m`. It represents the same rotation as
`m`, and its norm is the reciprocal of the norm of `m`. Hence, a unit MRP maps to its
antipode.

The shadow set is undefined for the zero MRP, for which this function throws a
`DomainError`. For nonzero inputs, scalar types whose reciprocal remains in the same type,
such as `Rational` and `BigFloat`, are preserved.
"""
@inline function shadow_rotation(m::MRP)
    norm² = m.q1 * m.q1 + m.q2 * m.q2 + m.q3 * m.q3
    iszero(norm²) && throw(DomainError(m, "The zero MRP does not have a shadow rotation."))

    inv_norm² = inv(norm²)
    return MRP(-m.q1 * inv_norm², -m.q2 * inv_norm², -m.q3 * inv_norm²)
end
