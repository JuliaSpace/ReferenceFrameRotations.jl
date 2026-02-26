## Desription ##############################################################################
#
# Tests related to conversion from MRP to CRP.
#
############################################################################################

# == File: ./src/conversions/mrp_to_crp.jl ================================================

# -- Functions: mrp_to_crp -----------------------------------------------------------------

@testset "MRP => CRP" begin
    for T in (Float32, Float64)
        # The conversion is tested by creating MRPs from DCMs and comparing the resulting
        # CRP against the one obtained directly from the same DCM.
        a₁ = _rand_ang(T)
        a₂ = _rand_ang2(T)
        a₃ = _rand_ang(T)

        D     = angle_to_dcm(a₃, :X) * angle_to_dcm(a₂, :Y) * angle_to_dcm(a₁, :Z)
        m     = dcm_to_mrp(D)
        c_ref = dcm_to_crp(D)

        # Convert MRP to CRP.
        c = mrp_to_crp(m)
        @test c isa CRP{T}

        @test isapprox(c, c_ref; atol = 1000 * eps(T), rtol = 1000 * eps(T))
    end
end

@testset "MRP => CRP (Singularity)" begin
    # A 180° rotation is a singularity for the CRP (MRP with |m| = 1).
    m = MRP(1.0, 0.0, 0.0)
    @test_throws ArgumentError mrp_to_crp(m)
end
