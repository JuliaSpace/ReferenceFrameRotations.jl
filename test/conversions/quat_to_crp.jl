## Desription ##############################################################################
#
# Tests related to conversion from quaternions to CRP.
#
############################################################################################

# == File: ./src/conversions/quat_to_crp.jl ================================================

# -- Functions: quat_to_crp ----------------------------------------------------------------

@testset "Quaternion => CRP" begin
    for T in (Float32, Float64)
        # The conversion is tested by creating quaternions from DCMs and comparing the
        # resulting CRP against the one obtained directly from the same DCM.
        a₁ = _rand_ang(T)
        a₂ = _rand_ang2(T)
        a₃ = _rand_ang(T)

        D     = angle_to_dcm(a₃, :X) * angle_to_dcm(a₂, :Y) * angle_to_dcm(a₁, :Z)
        q     = dcm_to_quat(D)
        c_ref = dcm_to_crp(D)

        # Convert quaternion to CRP.
        c = quat_to_crp(q)
        @test c isa CRP{T}

        @test isapprox(c, c_ref; atol = 100 * eps(T))
    end
end

@testset "Quaternion => CRP (Singularity)" begin
    # A 180° rotation is a singularity for the CRP (quaternion with q0 = 0).
    q = Quaternion(0.0, 1.0, 0.0, 0.0)
    @test_throws ArgumentError quat_to_crp(q)
end
