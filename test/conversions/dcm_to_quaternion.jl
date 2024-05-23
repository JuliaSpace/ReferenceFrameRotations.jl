## Desription ##############################################################################
#
# Tests related to conversion from direction cosine matrices to quaternion.
#
############################################################################################

# == File: ./src/conversions/dcm_to_quaternion.jl ==========================================

# -- Functions: dcm_to_quat ----------------------------------------------------------------

@testset "DCM => Quaternion" begin
    for T in (Float32, Float64)
        # The conversion between DCM and quaternion is tested by observing if the rotation
        # of a vector is consistent in both representations. In the testset, we add all the
        # special cases in the conversion.
        testset = [
            (_rand_ang(T), _rand_ang2(T), _rand_ang(T), :Z, :Y, :X)
            (T(-0.3),      T(+0.5),       T(+π),        :Z, :Y, :X)
            (T(+0.3),      T(+0.5),       T(+π),        :Z, :Y, :X)
            (T(+0.5),      T(+π),         T(-0.3),      :Z, :Y, :X)
            (T(+0.5),      T(+π),         T(+0.3),      :Z, :Y, :X)
            (T(+π),        T(+0.5),       T(-0.3),      :Z, :Y, :X)
            (T(+π),        T(+0.5),       T(+0.3),      :Z, :Y, :X)
        ]

        for test in testset
            # Unpack values in tuple.
            a₁, a₂, a₃, r₁, r₂, r₃ = test

            # Create the DCM.
            D = angle_to_dcm(a₃, r₃) * angle_to_dcm(a₂, r₂) * angle_to_dcm(a₁, r₁)

            # Convert it to a quaternion.
            q = dcm_to_quat(D)

            # Test quaternion type.
            @test eltype(q) === T

            # The real part must always be positive.
            @test q.q0 > 0

            # The quaternion must be unitary.
            @test √(q.q0^2 + q.q1^2 + q.q2^2 + q.q3^2) ≈ 1

            # Compare the rotations between the DCM and quaternion.
            v = @SVector randn(T, 3)

            vrd = D * v
            vrq = vect(q \ v * q)

            @test vrd ≈ vrq
            @test eltype(vrd) === eltype(vrq) === T
        end
    end
end
