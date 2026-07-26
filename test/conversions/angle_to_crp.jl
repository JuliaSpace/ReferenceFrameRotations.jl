## Desription ##############################################################################
#
# Tests related to conversion from Euler angles to CRP.
#
############################################################################################

# == File: ./src/conversions/angle_to_crp.jl ===============================================

# -- Functions: angle_to_crp ---------------------------------------------------------------

@testset "Euler angles => CRP" begin
    for T in (Float32, Float64)
        for rot_seq in valid_rot_seqs
            ea = EulerAngles(T(0.2), T(-0.1), T(0.3), rot_seq)
            c = angle_to_crp(ea)
            @test c isa CRP{T}
            @test c ≈ dcm_to_crp(angle_to_dcm(ea))
            @test c ≈ quat_to_crp(angle_to_quat(ea))

            c2 = @inferred angle_to_crp(ea.a1, ea.a2, ea.a3, ea.rot_seq)
            @test c2 ≈ c
        end
    end

    mixed = @inferred angle_to_crp(Float32(0.2), Float64(-0.1), Float32(0.3), :ZYX)
    @test mixed isa CRP{Float64}
end

@testset "Euler angles => CRP (Singularity)" begin
    @test_throws ArgumentError angle_to_crp(π, 0.0, 0.0, :XYZ)
    @test_throws ArgumentError angle_to_crp(EulerAngles(π, 0.0, 0.0, :XYZ))

    for rot_seq in valid_rot_seqs
        @test_throws ArgumentError angle_to_crp(π, 0.0, 0.0, rot_seq)

        near = angle_to_crp(π - 1e-8, 0.0, 0.0, rot_seq)
        @test near ≈ quat_to_crp(angle_to_quat(π - 1e-8, 0.0, 0.0, rot_seq))
        @test all(isfinite, (near.q1, near.q2, near.q3))
    end
end
