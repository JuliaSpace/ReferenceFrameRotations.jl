## Desription ##############################################################################
#
# Tests related to conversion from CRP to direction cosine matrices.
#
############################################################################################

# == File: ./src/conversions/crp_to_dcm.jl =================================================

# -- Functions: crp_to_dcm -----------------------------------------------------------------

@testset "CRP => DCM" begin
    for T in (Float32, Float64)
        # The conversion is tested by creating CRPs from known DCMs and comparing the
        # resulting DCM against the reference.
        testset = [
            (_rand_ang(T), _rand_ang2(T), _rand_ang(T), :Z, :Y, :X)
            (T(1.0),       T(0.5),        T(-0.2),      :Z, :Y, :X)
            (T(0.5),       T(-0.3),       T(0.4),       :X, :Y, :Z)
        ]

        for test in testset
            a₁, a₂, a₃, r₁, r₂, r₃ = test

            # Create the reference DCM and convert to CRP.
            D_ref = angle_to_dcm(a₃, r₃) * angle_to_dcm(a₂, r₂) * angle_to_dcm(a₁, r₁)
            c     = dcm_to_crp(D_ref)

            # Convert the CRP to a DCM.
            D = crp_to_dcm(c)
            @test eltype(D) === T

            # Verify the DCM against the reference entry by entry.
            @test maximum(abs.(D_ref - D)) < 100 * eps(T)
        end
    end
end
