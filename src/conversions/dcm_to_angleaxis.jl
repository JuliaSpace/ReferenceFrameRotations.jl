## Description #############################################################################
#
# Functions related to the conversion from DCM to Euler angle and axis.
#
############################################################################################

export dcm_to_angleaxis

"""
    dcm_to_angleaxis(dcm::DCM) -> EulerAngleAxis

Convert the `dcm` to an Euler angle and axis representation.

Return an angle in the interval `[0, π]` [rad] by convention.
"""
function dcm_to_angleaxis(dcm::DCM{T}) where {T <: Number}
    Tf = float(T)
    dcm = _float_dcm(dcm)
    z = zero(Tf)
    o = one(Tf)
    two = Tf(2)
    cθ = (dcm[1, 1] + dcm[2, 2] + dcm[3, 3] - o) / two

    # Check the undefined case.
    if cθ ≥ o - eps(Tf)
        return EulerAngleAxis(z, SVector{3, Tf}(z, z, z))
    elseif cθ <= -o + eps(Tf)
        v₁ = sqrt(max(z, (o + dcm[1, 1]) / two))
        v₂ = sqrt(max(z, (o + dcm[2, 2]) / two))
        v₃ = sqrt(max(z, (o + dcm[3, 3]) / two))

        # Compute the sign of the vector components.
        if dcm[1, 2] ≥ 0
            if dcm[1, 3] ≥ 0
                s₁ = s₂ = s₃ = +1
            else
                s₁ = s₂ = +1
                s₃ = -1
            end
        else
            if dcm[1, 3] ≥ 0
                s₁ = s₃ = +1
                s₂ = -1
            else
                s₁ = +1
                s₂ = s₃ = -1
            end
        end

        return EulerAngleAxis(Tf(π), SVector{3, Tf}(s₁ * v₁, s₂ * v₂, s₃ * v₃))
    else
        cθc = clamp(cθ, -o, o)
        sθ2 = two * sqrt(max(z, o - cθc * cθc))

        v₁ = (dcm[2, 3] - dcm[3, 2]) / sθ2
        v₂ = (dcm[3, 1] - dcm[1, 3]) / sθ2
        v₃ = (dcm[1, 2] - dcm[2, 1]) / sθ2

        return EulerAngleAxis(acos(cθc), SVector{3, Tf}(v₁, v₂, v₃))
    end
end
