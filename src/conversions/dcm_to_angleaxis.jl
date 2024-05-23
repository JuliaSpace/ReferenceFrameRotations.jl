## Description #############################################################################
#
# Functions related to the conversion from DCM to Euler angle and axis.
#
############################################################################################

export dcm_to_angleaxis

"""
    dcm_to_angleaxis(dcm::DCM{T}) where T<:Number -> EulerAngleAxis

Convert the `dcm` to an Euler angle and axis representation.

By convention, the returned Euler angle will always be in the interval [0, π].
"""
function dcm_to_angleaxis(dcm::DCM{T}) where T<:Number
    cθ = (dcm[1, 1] + dcm[2, 2] + dcm[3, 3] - 1) / 2

    # Check the undefined case.
    if cθ ≥ 1 - eps()
        return EulerAngleAxis(T(0), SVector{3,T}(0, 0, 0))
    elseif cθ <= -1 + eps()
        v₁ = sqrt((1 + dcm[1, 1]) / 2)
        v₂ = sqrt((1 + dcm[2, 2]) / 2)
        v₃ = sqrt((1 + dcm[3, 3]) / 2)

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

        return EulerAngleAxis(T(π), [s₁ * v₁, s₂ * v₂, s₃ * v₃ ])
    else
        sθ2 = 2sqrt(1 - cθ * cθ)

        v₁ = (dcm[2, 3] - dcm[3, 2]) / sθ2
        v₂ = (dcm[3, 1] - dcm[1, 3]) / sθ2
        v₃ = (dcm[1, 2] - dcm[2, 1]) / sθ2

        return EulerAngleAxis(acos(cθ), [v₁, v₂, v₃])
    end
end
