## Description #############################################################################
#
# Tests related to conversion from MRP to Euler angle and axis.
#
############################################################################################

# == File: ./src/conversions/mrp_to_angleaxis.jl ============================================

# -- Functions: mrp_to_angleaxis -----------------------------------------------------------

@testset "MRP => Euler Angle and Axis" begin
    for T in (Float32, Float64)
        # The conversion is tested by creating MRPs from known rotations and comparing the
        # resulting rotation against the source DCM.
        a₁ = _rand_ang(T)
        a₂ = _rand_ang2(T)
        a₃ = _rand_ang(T)

        D = angle_to_dcm(a₃, :X) * angle_to_dcm(a₂, :Y) * angle_to_dcm(a₁, :Z)
        m = dcm_to_mrp(D)

        # Convert MRP to Euler angle and axis.
        eaa = mrp_to_angleaxis(m)
        @test eaa isa EulerAngleAxis{T}

        @test angleaxis_to_dcm(eaa) ≈ D atol = 1000eps(T) rtol = 1000eps(T)
    end
end
