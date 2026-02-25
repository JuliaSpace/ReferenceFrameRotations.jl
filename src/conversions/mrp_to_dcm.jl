## Description #############################################################################
#
# Functions related to the conversion from MRP to DCM.
#
############################################################################################

export mrp_to_dcm

"""
    mrp_to_dcm(m::MRP) -> DCM

Convert MRP `m` to a Direction Cosine Matrix (DCM).
"""
function mrp_to_dcm(m::MRP)
    # Direct formula from the provided image:
    # [C] = [I] + (8 [skew(m)]^2 - 4(1 - |m|^2)[skew(m)]) / (1 + |m|^2)^2

    s_sq = m.q1^2 + m.q2^2 + m.q3^2
    denom = (1 + s_sq)^2

    fac1 = 8 / denom
    fac2 = 4 * (1 - s_sq) / denom

    # Skew symmetric matrix components
    # [ 0  -q3  q2]
    # [ q3  0  -q1]
    # [-q2  q1  0 ]

    # Precompute skew terms
    sk_12 = -m.q3
    sk_13 = m.q2
    sk_21 = m.q3
    sk_23 = -m.q1
    sk_31 = -m.q2
    sk_32 = m.q1

    # Skew^2 terms
    # Row 1
    # sk2_11 = sk_12 * sk_21 + sk_13 * sk_31 = -q3*q3 + q2*(-q2) = -q3^2 - q2^2
    # sk2_12 = sk_13 * sk_32 = q2 * q1
    # sk2_13 = sk_12 * sk_23 = -q3 * -q1 = q1q3

    sk2_11 = -m.q3^2 - m.q2^2
    sk2_12 = m.q1 * m.q2
    sk2_13 = m.q1 * m.q3

    sk2_21 = sk2_12
    sk2_22 = -m.q3^2 - m.q1^2
    sk2_23 = m.q2 * m.q3

    sk2_31 = sk2_13
    sk2_32 = sk2_23
    sk2_33 = -m.q2^2 - m.q1^2

    # Combine
    d11 = 1 + fac1 * sk2_11
    d12 = fac1 * sk2_12 - fac2 * sk_12
    d13 = fac1 * sk2_13 - fac2 * sk_13

    d21 = fac1 * sk2_21 - fac2 * sk_21
    d22 = 1 + fac1 * sk2_22
    d23 = fac1 * sk2_23 - fac2 * sk_23

    d31 = fac1 * sk2_31 - fac2 * sk_31
    d32 = fac1 * sk2_32 - fac2 * sk_32
    d33 = 1 + fac1 * sk2_33

    return DCM(d11, d12, d13, d21, d22, d23, d31, d32, d33)'
end
