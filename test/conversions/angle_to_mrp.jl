## Description #############################################################################
#
# Tests related to conversion from Euler angles to MRP.
#
############################################################################################

# == File: ./src/conversions/angle_to_mrp.jl ===============================================

# -- Functions: angle_to_mrp --------------------------------------------------------------

@testset "Euler angles => MRP" begin
    for T in (Float32, Float64)
        for rot_seq in valid_rot_seqs
            ea = EulerAngles(T(0.2), T(-0.1), T(0.3), rot_seq)
            m = angle_to_mrp(ea)
            @test m isa MRP{T}
            @test m ≈ dcm_to_mrp(angle_to_dcm(ea))
            @test m ≈ quat_to_mrp(angle_to_quat(ea))

            m2 = @inferred angle_to_mrp(ea.a1, ea.a2, ea.a3, ea.rot_seq)
            @test m2 ≈ m
        end
    end

    mixed = @inferred angle_to_mrp(Float32(0.2), Float64(-0.1), Float32(0.3), :ZYX)
    @test mixed isa MRP{Float64}
end

@testset "Euler angles => MRP (Quaternion sign boundary)" begin
    for rot_seq in valid_rot_seqs
        at_boundary = angle_to_mrp(π, 0.0, 0.0, rot_seq)
        near_boundary = angle_to_mrp(π + 1e-8, 0.0, 0.0, rot_seq)

        @test at_boundary ≈ quat_to_mrp(angle_to_quat(π, 0.0, 0.0, rot_seq))
        @test near_boundary ≈
              quat_to_mrp(angle_to_quat(π + 1e-8, 0.0, 0.0, rot_seq))
        @test all(isfinite, (near_boundary.q1, near_boundary.q2, near_boundary.q3))
    end
end
