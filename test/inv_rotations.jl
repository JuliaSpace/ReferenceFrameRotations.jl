## Description #############################################################################
#
# Tests related to the API function to invert rotations.
#
############################################################################################

# == File: ./src/inv_rotations.jl ==========================================================

# -- Functions: inv_rotation ---------------------------------------------------------------

@testset "Invert rotations" begin
    for T in (Float32, Float64)
        D = angle_to_dcm(T(0.4), T(-0.7), T(1.1), :ZYX)
        rotations = (
            D,
            convert(EulerAngleAxis, D),
            convert(EulerAngles, D),
            convert(Quaternion, D),
            convert(CRP, D),
            convert(MRP, D),
        )
        I_D = DCM(T(1) * I)

        for R in rotations
            Ri = inv_rotation(R)
            @test eltype(Ri) === T

            Rd = R isa DCM ? R : convert(DCM, R)
            Rid = Ri isa DCM ? Ri : convert(DCM, Ri)
            @test Rid * Rd ≈ I_D atol = 100 * sqrt(eps(T))
            @test Rd * Rid ≈ I_D atol = 100 * sqrt(eps(T))
        end

        # Euler-angle singularities must still produce a genuine inverse
        # rotation, even though their angle representation is not unique.
        singular_rotations = (
            EulerAngles(T(0.3), +T(π / 2), T(-0.8), :ZYX),
            EulerAngles(T(0.3), -T(π / 2), T(-0.8), :ZYX),
            EulerAngles(T(0.3), T(0), T(-0.8), :XYX),
            EulerAngles(T(0.3), T(π), T(-0.8), :XYX),
        )
        for R in singular_rotations
            Rd = convert(DCM, R)
            Rid = convert(DCM, inv_rotation(R))
            @test Rid * Rd ≈ I_D atol = 100 * sqrt(eps(T))
            @test Rd * Rid ≈ I_D atol = 100 * sqrt(eps(T))
        end
    end
end
