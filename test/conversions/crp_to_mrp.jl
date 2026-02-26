## Desription ##############################################################################
#
# Tests related to conversion from CRP to MRP.
#
############################################################################################

# == File: ./src/conversions/crp_to_mrp.jl ================================================

# -- Functions: crp_to_mrp -----------------------------------------------------------------

@testset "CRP => MRP" begin
    for T in (Float32, Float64)
        # The conversion is tested by creating CRPs from DCMs and comparing the resulting
        # MRP against the one obtained directly from the same DCM.
        a₁ = _rand_ang(T)
        a₂ = _rand_ang2(T)
        a₃ = _rand_ang(T)

        D     = angle_to_dcm(a₃, :X) * angle_to_dcm(a₂, :Y) * angle_to_dcm(a₁, :Z)
        c     = dcm_to_crp(D)
        m_ref = dcm_to_mrp(D)

        # Convert CRP to MRP.
        m = crp_to_mrp(c)
        @test m isa MRP{T}

        @test isapprox(m, m_ref; atol = 100 * eps(T))
    end
end
