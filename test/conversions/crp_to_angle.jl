## Desription ##############################################################################
#
# Tests related to conversion from CRP to Euler angles.
#
############################################################################################

# == File: ./src/conversions/crp_to_angle.jl ===============================================

# -- Functions: crp_to_angle ---------------------------------------------------------------

@testset "CRP => Euler Angles" begin
    for T in (Float32, Float64)
        # The conversion is tested by creating CRPs from known Euler angles and verifying
        # that the converted angles match the originals.
        a₁ = _rand_ang(T)
        a₂ = _rand_ang2(T)
        a₃ = _rand_ang(T)

        D = angle_to_dcm(a₃, :X) * angle_to_dcm(a₂, :Y) * angle_to_dcm(a₁, :Z)
        c = dcm_to_crp(D)

        # Convert CRP to Euler angles.
        ea = crp_to_angle(c, :ZYX)
        @test eltype(ea) === T

        @test ea.rot_seq == :ZYX
        @test ea.a1 ≈ a₁ atol = 100 * eps(T)
        @test ea.a2 ≈ a₂ atol = 100 * eps(T)
        @test ea.a3 ≈ a₃ atol = 100 * eps(T)
    end
end
