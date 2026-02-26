## Desription ##############################################################################
#
# Tests related to conversion from Euler angles to CRP.
#
############################################################################################

# == File: ./src/conversions/angle_to_crp.jl ===============================================

# -- Functions: angle_to_crp ---------------------------------------------------------------

@testset "Euler angles => CRP" begin
    for T in (Float32, Float64)
        # We do not need comprehensive tests here because `angle_to_crp` first converts the
        # Euler angles to DCM and then to CRP. Those two operations are already heavily
        # tested.
        testset = [
            EulerAngles(T( 0.2), T(-0.1), T( 0.3), :ZYX)
            EulerAngles(T( 0.5), T( 0.4), T(-0.2), :XYZ)
            EulerAngles(T(-0.3), T( 0.2), T( 0.6), :ZXZ)
        ]

        for ea in testset
            c = angle_to_crp(ea)
            @test c isa CRP{T}
            @test c ≈ dcm_to_crp(angle_to_dcm(ea))

            c2 = angle_to_crp(ea.a1, ea.a2, ea.a3, ea.rot_seq)
            @test c2 ≈ c
        end
    end
end

@testset "Euler angles => CRP (Singularity)" begin
    @test_throws ArgumentError angle_to_crp(π, 0.0, 0.0, :XYZ)
    @test_throws ArgumentError angle_to_crp(EulerAngles(π, 0.0, 0.0, :XYZ))
end
