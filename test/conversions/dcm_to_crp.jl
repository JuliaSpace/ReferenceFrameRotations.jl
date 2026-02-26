## Desription ##############################################################################
#
# Tests related to conversion from direction cosine matrices to CRP.
#
############################################################################################

# == File: ./src/conversions/dcm_to_crp.jl =================================================

# -- Functions: dcm_to_crp -----------------------------------------------------------------

@testset "DCM => CRP" begin
    for T in (Float32, Float64)
        # The conversion is tested by creating DCMs from Euler angles and verifying that the
        # resulting CRP represents the same rotation.
        testset = [
            (_rand_ang(T), _rand_ang2(T), _rand_ang(T), :Z, :Y, :X)
            (T(1.0),       T(0.5),        T(-0.2),      :Z, :Y, :X)
            (T(0.5),       T(-0.3),       T(0.4),       :X, :Y, :Z)
        ]

        for test in testset
            a₁, a₂, a₃, r₁, r₂, r₃ = test

            # Create the DCM.
            D = angle_to_dcm(a₃, r₃) * angle_to_dcm(a₂, r₂) * angle_to_dcm(a₁, r₁)

            # Convert to CRP.
            c = dcm_to_crp(D)
            @test c isa CRP{T}

            # Verify the result by converting back to DCM and comparing vector rotations.
            v  = @SVector randn(T, 3)
            Dc = crp_to_dcm(c)
            @test D * v ≈ Dc * v
        end
    end
end
