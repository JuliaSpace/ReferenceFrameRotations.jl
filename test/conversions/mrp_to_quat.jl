## Desription ##############################################################################
#
# Tests related to conversion from MRP to quaternions.
#
############################################################################################

# == File: ./src/conversions/mrp_to_quat.jl ================================================

# -- Functions: mrp_to_quat ----------------------------------------------------------------

@testset "MRP => Quaternion" begin
    for T in (Float32, Float64)
        # The conversion is tested by creating MRPs from DCMs and comparing the resulting
        # quaternion against the one obtained directly from the same DCM.
        a₁ = _rand_ang(T)
        a₂ = _rand_ang2(T)
        a₃ = _rand_ang(T)

        D     = angle_to_dcm(a₃, :X) * angle_to_dcm(a₂, :Y) * angle_to_dcm(a₁, :Z)
        m     = dcm_to_mrp(D)
        q_ref = dcm_to_quat(D)

        # Convert MRP to quaternion.
        q = mrp_to_quat(m)
        @test eltype(q) === T

        # Signs of quaternions can be flipped, so check for both.
        @test isapprox(q, q_ref; atol = 1000 * eps(T)) ||
              isapprox(q, -q_ref; atol = 1000 * eps(T))
    end
end
