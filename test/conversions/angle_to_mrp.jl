## Desription ##############################################################################
#
# Tests related to conversion from Euler angles to MRP.
#
############################################################################################

# == File: ./src/conversions/angle_to_mrp.jl ===============================================

# -- Functions: angle_to_mrp --------------------------------------------------------------

@testset "Euler angles => MRP" begin
    for T in (Float32, Float64)
        # We do not need comprehensive tests here because `angle_to_mrp` first converts the
        # Euler angles to DCM and then to MRP. Those two operations are already heavily
        # tested.
        testset = [
            EulerAngles(T( 0.2), T(-0.1), T( 0.3), :ZYX)
            EulerAngles(T( 0.5), T( 0.4), T(-0.2), :XYZ)
            EulerAngles(T(-0.3), T( 0.2), T( 0.6), :ZXZ)
        ]

        for ea in testset
            m = angle_to_mrp(ea)
            @test m isa MRP{T}
            @test m ≈ dcm_to_mrp(angle_to_dcm(ea))

            m2 = angle_to_mrp(ea.a1, ea.a2, ea.a3, ea.rot_seq)
            @test m2 ≈ m
        end
    end
end
