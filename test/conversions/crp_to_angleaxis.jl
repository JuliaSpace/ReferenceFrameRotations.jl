## Desription ##############################################################################
#
# Tests related to conversion from CRP to Euler angle and axis.
#
############################################################################################

# == File: ./src/conversions/crp_to_angleaxis.jl ============================================

# -- Functions: crp_to_angleaxis -----------------------------------------------------------

@testset "CRP => Euler Angle and Axis" begin
    for T in (Float32, Float64)
        # The conversion is tested by creating CRPs from known rotations and comparing the
        # resulting Euler angle and axis against the one obtained directly from the same DCM.
        a₁ = _rand_ang(T)
        a₂ = _rand_ang2(T)
        a₃ = _rand_ang(T)

        D       = angle_to_dcm(a₃, :X) * angle_to_dcm(a₂, :Y) * angle_to_dcm(a₁, :Z)
        c       = dcm_to_crp(D)
        eaa_ref = dcm_to_angleaxis(D)

        # Convert CRP to Euler angle and axis.
        eaa = crp_to_angleaxis(c)
        @test eaa isa EulerAngleAxis{T}

        @test isapprox(eaa, eaa_ref; atol = 1000 * eps(T))
    end
end
