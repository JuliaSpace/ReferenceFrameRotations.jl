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

Compute the shadow rotation of the MRP `m`.

The shadow rotation of a MRP `m` is formed by the values `q` such that:

    |q| > 1

and represents the same rotation as `m`.
"""
@inline shadow_rotation(m::MRP) = -m / (norm(m)^2)