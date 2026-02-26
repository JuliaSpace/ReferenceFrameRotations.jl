## Desription ##############################################################################
#
# Tests related to conversion from quaternions to MRP.
#
############################################################################################

# == File: ./src/conversions/quat_to_mrp.jl ================================================

# -- Functions: quat_to_mrp ----------------------------------------------------------------

@testset "Quaternion => MRP" begin
    for T in (Float32, Float64)
        # The conversion is tested by creating quaternions from DCMs and comparing the
        # resulting MRP against the one obtained directly from the same DCM.
        a₁ = _rand_ang(T)
        a₂ = _rand_ang2(T)
        a₃ = _rand_ang(T)

        D     = angle_to_dcm(a₃, :X) * angle_to_dcm(a₂, :Y) * angle_to_dcm(a₁, :Z)
        q     = dcm_to_quat(D)
        m_ref = dcm_to_mrp(D)

        # Convert quaternion to MRP.
        m = quat_to_mrp(q)
        @test m isa MRP{T}

        @test isapprox(m, m_ref; atol = 100 * eps(T))
    end
end

@testset "Quaternion => MRP (Singularity)" begin
    # A 360° rotation is a singularity for the MRP (quaternion with q0 = -1).
    q = Quaternion(-1.0, 0.0, 0.0, 0.0)
    @test_throws ArgumentError quat_to_mrp(q)
end
