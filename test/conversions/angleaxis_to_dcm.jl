# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to conversion from Euler angle and axis to DCM.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/conversions/angleaxis_to_dcm.jl
# ===========================================

# Functions: angleaxis_to_dcm
# ---------------------------

@testset "Euler angle and axis => DCM" begin
    for T in (Float32, Float64)
        # Sample a random Euler angle and axis.
        v = @SVector randn(T, 3)
        v = v / norm(v)
        a = _rand_ang(T)
        av = EulerAngleAxis(a, v)
        D = angleaxis_to_dcm(av)
        @test eltype(D) === T

        # Test the conversion using the theory.
        sθ, cθ = sincos(a)
        aux = 1 - cθ
        @test D[1, 1] ≈ cθ + v[1] * v[1] * aux
        @test D[1, 2] ≈ v[1] * v[2] * aux + v[3] * sθ
        @test D[1, 3] ≈ v[1] * v[3] * aux - v[2] * sθ
        @test D[2, 1] ≈ v[1] * v[2] * aux - v[3] * sθ
        @test D[2, 2] ≈ cθ + v[2] * v[2] * aux
        @test D[2, 3] ≈ v[2] * v[3] * aux + v[1] * sθ
        @test D[3, 1] ≈ v[1] * v[3] * aux + v[2] * sθ
        @test D[3, 2] ≈ v[2] * v[3] * aux - v[1] * sθ
        @test D[3, 3] ≈ cθ + v[3] * v[3] * aux
    end
end

@testset "Euler angle and axis => DCM (Errors)" begin
    @test_throws ArgumentError angleaxis_to_dcm(0, [1, 2])
    @test_throws ArgumentError angleaxis_to_dcm(0, [1, 2, 3, 4])
end
