## Desription ##############################################################################
#
# Tests related to the generation of random rotation representations.
#
############################################################################################

using StableRNGs

# Julia random number generator can change its output with the same seed accross minor
# versions. Hence, we need to use StableRNGs.jl to ensure that the tests are consistent. For
# more information, see:
#
#   https://docs.julialang.org/en/v1/stdlib/Random/#Reproducibility

# == File: ./src/random.jl =================================================================

@testset "DCM (Float64)" begin
    D_exp = DCM(
        -0.9855423399595813,
         0.1610947375575752,
        -0.05248601412042554,
         0.13225259369505987,
         0.9250801678356908,
         0.35599990805900494,
         0.10590348251083596,
         0.3439115709137256,
        -0.9330108701316029,
    )

    D = rand(StableRNG(1986), DCM)
    @test D ≈ D_exp atol = 1e-15

    D = rand(StableRNG(1986), DCM{Float64})
    @test D ≈ D_exp atol = 1e-15
end

@testset "DCM (Float32)" begin
    D_exp = DCM(
         0.13128565f0,
         0.6157909f0,
         0.77689487f0,
        -0.5353275f0,
         0.7036309f0,
        -0.4672559f0,
        -0.83437914f0,
        -0.35454917f0,
         0.4220264f0,
    )

    D = rand(StableRNG(1986), DCM{Float32})

    @test D ≈ D_exp atol = 1e-15
end

@testset "Euler Angle and Axis (Float64)" begin
    aa_exp = EulerAngleAxis(
        3.0607810768487105,
        @SVector [
            -0.0748748188948659,
            -0.9810600691052008,
            -0.17864742456234697,
        ]
    )

    aa = rand(StableRNG(1986), EulerAngleAxis)
    @test aa ≈ aa_exp atol = 1e-15

    aa = rand(StableRNG(1986), EulerAngleAxis{Float64})
    @test aa ≈ aa_exp atol = 1e-15
end

@testset "Euler Angle and Axis (Float32)" begin
    aa_exp = EulerAngleAxis(
        1.4419688f0,
        @SVector [
             0.056824237f0,
             0.812369f0,
            -0.5803686f0,
        ]
    )

    aa = rand(StableRNG(1986), EulerAngleAxis{Float32})
    @test aa ≈ aa_exp atol = 1e-15
end

@testset "Euler Angles (Float64)" begin
    ea_exp = EulerAngles(
        6.237765228608508,
        2.646507063149075,
        4.53226625968865,
        :YZY
    )

    ea = rand(StableRNG(1986), EulerAngles)
    @test ea ≈ ea_exp atol = 1e-15

    ea = rand(StableRNG(1986), EulerAngles{Float64})
    @test ea ≈ ea_exp atol = 1e-15
end

@testset "Euler Angles (Float32)" begin
    ea_exp = EulerAngles(
        2.7291467f0,
        1.5209f0,
        2.1911314f0,
        :YZY
    )

    ea = rand(StableRNG(1986), EulerAngles{Float32})
    @test ea ≈ ea_exp atol = 1e-15
end

@testset "Quaternion (Float64)" begin
    q_exp = Quaternion(
         0.04039479466622753,
        -0.07481370585716751,
        -0.9802593251184702,
        -0.17850161203213802,
    )

    q = rand(StableRNG(1986), Quaternion)
    @test q ≈ q_exp atol = 1e-15

    q = rand(StableRNG(1986), Quaternion{Float64})
    @test q ≈ q_exp atol = 1e-15
end

@testset "Quaternion (Float32)" begin
    q_exp = Quaternion(
         0.7511563f0,
         0.037511066f0,
         0.5362646f0,
        -0.38311547f0,
    )

    q = rand(StableRNG(1986), Quaternion{Float32})
    @test q ≈ q_exp atol = 1e-15
end

@testset "CRP (Float64)" begin
    c_exp = CRP(
         -1.8520630312725974,
        -24.266971356535347,
         -4.418926089538365
    )

    c = rand(StableRNG(1986), CRP)
    @test c ≈ c_exp atol = 1e-15

    c = rand(StableRNG(1986), CRP{Float64})
    @test c ≈ c_exp atol = 1e-15
end

@testset "CRP (Float32)" begin
    c_exp = CRP(
         0.049937766f0,
         0.7139188f0,
        -0.5100343f0
    )

    c = rand(StableRNG(1986), CRP{Float32})
    @test c ≈ c_exp atol = 1e-15
end

@testset "MRP (Float64)" begin
    m_exp = MRP(
        -0.07190895825384126,
        -0.9421993748372708,
        -0.17157103529089043
    )

    m = rand(StableRNG(1986), MRP)
    @test m ≈ m_exp atol = 1e-15

    m = rand(StableRNG(1986), MRP{Float64})
    @test m ≈ m_exp atol = 1e-15
end

@testset "MRP (Float32)" begin
    m_exp = MRP(
         0.021420741f0,
         0.30623457f0,
        -0.21877857f0
    )

    m = rand(StableRNG(1986), MRP{Float32})
    @test m ≈ m_exp atol = 1e-15
end