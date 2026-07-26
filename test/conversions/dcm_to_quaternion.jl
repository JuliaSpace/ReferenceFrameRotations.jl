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
            (T(-0.3), T(+0.5), T(+π), :Z, :Y, :X)
            (T(+0.3), T(+0.5), T(+π), :Z, :Y, :X)
            (T(+0.5), T(+π), T(-0.3), :Z, :Y, :X)
            (T(+0.5), T(+π), T(+0.3), :Z, :Y, :X)
            (T(+π), T(+0.5), T(-0.3), :Z, :Y, :X)
            (T(+π), T(+0.5), T(+0.3), :Z, :Y, :X)
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

            # The real part is nonnegative; it is zero for exact half-turns.
            @test q.q0 >= 0

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


@testset "DCM => Quaternion (generic numeric stability and half-turn convention)" begin
    for T in (Int, Rational{Int}, Float32, Float64, BigFloat)
        Tf = float(T)
        I₃ = DCM(T[1 0 0; 0 1 0; 0 0 1])
        qI = @inferred dcm_to_quat(I₃)
        @test qI isa Quaternion{Tf}
        @test (qI.q0, qI.q1, qI.q2, qI.q3) ==
              (one(Tf), zero(Tf), zero(Tf), zero(Tf))

        D = DCM(T[0 1 0; 0 0 1; 1 0 0])
        q = @inferred dcm_to_quat(D)
        @test q isa Quaternion{Tf}
        @test quat_to_dcm(q) ≈ D atol = 20sqrt(eps(Tf))
        @test q.q0 >= zero(Tf)

        Dπ = DCM(T[1 0 0; 0 -1 0; 0 0 -1])
        qπ = @inferred dcm_to_quat(Dπ)
        @test qπ isa Quaternion{Tf}
        @test qπ.q0 == zero(Tf)
        @test !signbit(qπ.q0)
        @test (qπ.q1, qπ.q2, qπ.q3) == (one(Tf), zero(Tf), zero(Tf))
    end

    for T in (Float32, Float64, BigFloat)
        # A one-ULP negative radicand excursion is guarded rather than sent to sqrt.
        D = DCM(T[-1 - eps(T) 0 0; 0 1 0; 0 0 -1])
        q = @inferred dcm_to_quat(D)
        @test q isa Quaternion{T}
        @test all(isfinite, (q.q0, q.q1, q.q2, q.q3))
    end
end
