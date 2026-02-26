## Description #############################################################################
#
# Functions related to the conversion from Euler angles to CRP.
#
############################################################################################

export angle_to_crp

"""
    angle_to_crp(θ₁::Number, θ₂::Number, θ₃::Number, rot_seq::Symbol = :ZYX) -> CRP
    angle_to_crp(Θ::EulerAngles) -> CRP

Convert the Euler angles `θ₁`, `θ₂`, and `θ₃` [rad] with the rotation sequence `rot_seq` to
classical Rodrigues parameters.

Those values can also be passed inside the structure `Θ` (see [`EulerAngles`](@ref)).

The rotation sequence is defined by a `:Symbol`. The possible values are: `:XYX`, `XYZ`,
`:XZX`, `:XZY`, `:YXY`, `:YXZ`, `:YZX`, `:YZY`, `:ZXY`, `:ZXZ`, `:ZYX`, and `:ZYZ`. If no
value is specified, it defaults to `:ZYX`.
"""
@inline function angle_to_crp(
    θ₁::Number,
    θ₂::Number,
    θ₃::Number,
    rot_seq::Symbol = :ZYX
)
    return dcm_to_crp(angle_to_dcm(θ₁, θ₂, θ₃, rot_seq))
end

@inline angle_to_crp(Θ::EulerAngles) = angle_to_crp(Θ.a1, Θ.a2, Θ.a3, Θ.rot_seq)
