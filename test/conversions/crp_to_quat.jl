## Desription ##############################################################################
#
# Tests related to conversion from CRP to quaternions.
#
############################################################################################

# == File: ./src/conversions/crp_to_quat.jl ================================================

# -- Functions: crp_to_quat ----------------------------------------------------------------

@testset "CRP => Quaternion" begin
    for T in (Float32, Float64)
        # The conversion is tested by creating CRPs from DCMs and comparing the resulting
        # quaternion against the one obtained directly from the same DCM.
        a₁ = _rand_ang(T)
        a₂ = _rand_ang2(T)
        a₃ = _rand_ang(T)

        D     = angle_to_dcm(a₃, :X) * angle_to_dcm(a₂, :Y) * angle_to_dcm(a₁, :Z)
        c     = dcm_to_crp(D)
        q_ref = dcm_to_quat(D)

        # Convert CRP to quaternion.
        q = crp_to_quat(c)
        @test eltype(q) === T

        # Signs of quaternions can be flipped, so check for both.
        @test isapprox(q, q_ref; atol = 100 * eps(T)) ||
              isapprox(q, -q_ref; atol = 100 * eps(T))
    end
end
