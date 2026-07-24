## Desription ##############################################################################
#
# Tests related to conversion from direction cosine matrices to MRP.
#
############################################################################################

# == File: ./src/conversions/dcm_to_mrp.jl =================================================

# -- Functions: dcm_to_mrp -----------------------------------------------------------------

@testset "DCM => MRP" begin
    for T in (Float32, Float64)
        # Identity and rotations at and near the π branch cut.
        D = DCM{T}((1, 0, 0, 0, 1, 0, 0, 0, 1))
        @test dcm_to_mrp(D) == MRP(T(0), T(0), T(0))

        for axis in (SVector{3,T}(1, 0, 0), normalize(SVector{3,T}(1, 2, 3)))
            Dπ = angleaxis_to_dcm(T(π), axis)
            mπ = dcm_to_mrp(Dπ)
            v = @SVector randn(T, 3)
            @test Dπ * v ≈ mrp_to_dcm(mπ) * v
            mπold = quat_to_mrp(dcm_to_quat(Dπ))
            @test (mπ.q1, mπ.q2, mπ.q3) ≈ (mπold.q1, mπold.q2, mπold.q3)

            Dnear = angleaxis_to_dcm(T(π) - T(10) * eps(T), axis)
            mnear = dcm_to_mrp(Dnear)
            @test Dnear * v ≈ mrp_to_dcm(mnear) * v
            mnearold = quat_to_mrp(dcm_to_quat(Dnear))
            @test (mnear.q1, mnear.q2, mnear.q3) ≈ (mnearold.q1, mnearold.q2, mnearold.q3)
        end

        # The conversion is tested by creating DCMs from Euler angles and verifying that the
        # resulting MRP represents the same rotation.
        testset = [
            (_rand_ang(T), _rand_ang2(T), _rand_ang(T), :Z, :Y, :X)
            (T(1.0),       T(0.5),        T(-0.2),      :Z, :Y, :X)
            (T(0.5),       T(-0.3),       T(0.4),       :X, :Y, :Z)
        ]

        for test in testset
            a₁, a₂, a₃, r₁, r₂, r₃ = test

            # Create the DCM.
            D = angle_to_dcm(a₃, r₃) * angle_to_dcm(a₂, r₂) * angle_to_dcm(a₁, r₁)

            # Convert to MRP.
            m = dcm_to_mrp(D)
            @test m isa MRP{T}

            # Verify the result by converting back to DCM and comparing vector rotations.
            v  = @SVector randn(T, 3)
            Dm = mrp_to_dcm(m)
            @test D * v ≈ Dm * v
        end
    end
end
