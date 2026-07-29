## Desription ##############################################################################
#
# Tests related to the API function to compose rotations.
#
############################################################################################

# == File: ./src/compose_rotations.jl ======================================================

# -- Functions: compose_rotations ----------------------------------------------------------

@testset "Compose rotations" begin
    for T in (Float32, Float64)
        # == DCMs ==========================================================================

        # Sample 4 DCMs.
        D1 = rand(DCM{T})
        D2 = rand(DCM{T})
        D3 = rand(DCM{T})
        D4 = rand(DCM{T})

        # Test the function `compose_rotation`.
        @test D1 === compose_rotation(D1)
        @test D2 * D1 ≈ compose_rotation(D1, D2)
        @test D3 * D2 * D1 ≈ compose_rotation(D1, D2, D3)
        @test D4 * D3 * D2 * D1 ≈ compose_rotation(D1, D2, D3, D4)

        # == Euler Angle and Axis ==========================================================

        # Sample 4 Euler angle and axis.
        ea1 = rand(EulerAngleAxis{T})
        ea2 = rand(EulerAngleAxis{T})
        ea3 = rand(EulerAngleAxis{T})
        ea4 = rand(EulerAngleAxis{T})

        ear1 = ea2 * ea1
        eac1 = compose_rotation(ea1, ea2)

        ear2 = ea3 * ea2 * ea1
        eac2 = compose_rotation(ea1, ea2, ea3)

        ear3 = ea4 * ea3 * ea2 * ea1
        eac3 = compose_rotation(ea1, ea2, ea3, ea4)

        # Test the function `compose_rotation`.
        @test ea1 === compose_rotation(ea1)
        @test ear1 ≈ eac1
        @test ear2 ≈ eac2
        @test ear3 ≈ eac3

        # == Euler Angles ==================================================================

        # Sample 4 Euler angles.
        Θ1 = rand(EulerAngles{T})
        Θ2 = rand(EulerAngles{T})
        Θ3 = rand(EulerAngles{T})
        Θ4 = rand(EulerAngles{T})

        Θr1 = Θ2 * Θ1
        Θc1 = compose_rotation(Θ1, Θ2)

        Θr2 = Θ3 * Θ2 * Θ1
        Θc2 = compose_rotation(Θ1, Θ2, Θ3)

        Θr3 = Θ4 * Θ3 * Θ2 * Θ1
        Θc3 = compose_rotation(Θ1, Θ2, Θ3, Θ4)

        # Test the function `compose_rotation`.
        @test Θ1 === compose_rotation(Θ1)
        @test Θr1 ≈ Θc1
        @test Θr2 ≈ Θc2
        @test Θr3 ≈ Θc3

        # == Quaternions ===================================================================

        # Sample 4 quaternions.
        q1 = rand(Quaternion{T})
        q2 = rand(Quaternion{T})
        q3 = rand(Quaternion{T})
        q4 = rand(Quaternion{T})

        # Test the function `compose_rotation`.
        @test q1 === compose_rotation(q1)
        @test (q1 * q2)[:] ≈ compose_rotation(q1, q2)[:]
        @test (q1 * q2 * q3)[:] ≈ compose_rotation(q1, q2, q3)[:]
        @test (q1 * q2 * q3 * q4)[:] ≈ compose_rotation(q1, q2, q3, q4)[:]
    end
end

@testset "Collection rotation composition" begin
    for T in (Float32, Float64)
        # Distinct, small rotations make changes to the multiplication order observable
        # while keeping CRP and MRP compositions away from singularities.
        Ds = [
            angle_to_dcm(T(0.0007 * i), T(-0.0009 * i), T(0.0005 * i), :ZYX) for i in 1:64
        ]
        rotations = (
            Ds,
            [convert(EulerAngleAxis, D) for D in Ds],
            [convert(EulerAngles(:ZYX), D) for D in Ds],
            [convert(Quaternion, D) for D in Ds],
            [convert(CRP, D) for D in Ds],
            [convert(MRP, D) for D in Ds],
        )

        for Rs in rotations
            for n in (1, 4, 33, 64)
                vector = Rs[1:n]
                tuple = Tuple(vector)

                if eltype(Rs) <: Quaternion
                    reference = vector[end]
                    for i in (n - 1):-1:1
                        reference = vector[i] * reference
                    end
                else
                    reference = vector[end]
                    for i in (n - 1):-1:1
                        reference = reference * vector[i]
                    end
                end

                tuple_result = compose_rotation(tuple)
                vector_result = compose_rotation(vector)
                tolerance = 200 * sqrt(eps(T))

                @test typeof(tuple_result) === eltype(Rs)
                @test typeof(vector_result) === eltype(Rs)
                @test convert(DCM, tuple_result) ≈ convert(DCM, reference) atol = tolerance
                @test convert(DCM, vector_result) ≈ convert(DCM, reference) atol = tolerance

                if eltype(Rs) <: EulerAngles
                    @test tuple_result.rot_seq === :ZYX
                    @test vector_result.rot_seq === :ZYX
                end
            end

            @test_throws ArgumentError compose_rotation(Tuple{}())
            @test_throws ArgumentError compose_rotation(eltype(Rs)[])
        end

        D32 = angle_to_dcm(Float32(0.01), Float32(-0.02), Float32(0.03), :ZYX)
        D64 = angle_to_dcm(0.04, -0.05, 0.06, :ZYX)
        mixed = (D32, D64)
        @test compose_rotation(mixed) ≈ compose_rotation(mixed...)
    end
end

@testset "CRP collection singular intermediate" begin
    singularity_message = "The composition of these CRPs results in a singularity (180° rotation)."

    for T in (Float32, Float64)
        # A CRP for a 90° rotation about X is exactly [1, 0, 0]. Thus, the required
        # tree `(c90 * c90) * c30` encounters a singular 180° intermediate. The
        # alternate tree `c90 * (c90 * c30)` does not encounter that intermediate.
        c30 = CRP(tan(T(π) / T(12)), zero(T), zero(T))
        c90 = CRP(one(T), zero(T), zero(T))
        rotations = (c30, c90, c90)

        vararg_error = try
            compose_rotation(rotations...)
        catch error
            error
        end
        tuple_error = try
            compose_rotation(rotations)
        catch error
            error
        end
        vector_error = try
            compose_rotation(collect(rotations))
        catch error
            error
        end

        @test vararg_error isa ArgumentError
        @test tuple_error isa ArgumentError
        @test vector_error isa ArgumentError
        @test vararg_error.msg == singularity_message
        @test tuple_error.msg == vararg_error.msg
        @test vector_error.msg == vararg_error.msg
        @test c90 * (c90 * c30) isa CRP{T}
    end
end

# -- Operator ∘ ----------------------------------------------------------------------------

@testset "Operator ∘" begin
    for T in (Float32, Float64)
        D  = rand(DCM{T})
        ea = rand(EulerAngles{T})
        av = rand(EulerAngleAxis{T})
        q  = rand(Quaternion{T})

        D_ea = convert(DCM, ea)
        D_av = convert(DCM, av)
        D_q  = convert(DCM, q)

        # == DCM ===========================================================================

        R = D ∘ ea ∘ av ∘ q
        R_exp = D * D_ea * D_av * D_q
        @test R ≈ R_exp atol = √(eps(T))

        # == Euler Angle and Axis ==========================================================

        R = av ∘ D ∘ ea ∘ q
        R_exp = convert(EulerAngleAxis, D_av * D * D_ea * D_q)
        @test R ≈ R_exp atol = 100 * √(eps(T))

        # == Euler Angles ==================================================================

        R = ea ∘ D ∘ av ∘ q
        R_exp = convert(EulerAngles(R.rot_seq), D_ea * D * D_av * D_q)

        # When converting to Euler angles, we normalize the angles. We need to make the same
        # with the composition for the sake of testing.
        R = convert(EulerAngles, R)

        @test R ≈ R_exp atol = 100 * √(eps(T))

        # == Quaternion ====================================================================

        R = q ∘ ea ∘ av ∘ D
        R_exp = convert(Quaternion, D_q * D_ea * D_av * D)

        # When converting to quaternion, we make sure that the real part is always positive.
        # Hence, we need to do the same with the composition for the sake of testing.
        if R.q0 < 0
            R = -R
        end

        @test R ≈ R_exp atol = √(eps(T))
    end
end
