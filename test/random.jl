# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to the generation of random rotation representations.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/random.jl
# =====================

@testset "DCM (Float64)" begin
    D_exp = DCM(
         0.1770772447942165,
        -0.24937398754945297,
         0.9520799670772275,
        -0.16371156336807055,
        -0.9613536278168439,
        -0.22135430039413143,
         0.9704855348719379,
        -0.11666969022448989,
        -0.21105925705178208
    )

    D = rand(MersenneTwister(1986), DCM)
    @test D ≈ D_exp atol = 1e-15

    D = rand(MersenneTwister(1986), DCM{Float64})
    @test D ≈ D_exp atol = 1e-15
end

@testset "DCM (Float32)" begin
    D_exp = DCM(
         0.9071183f0,
        -0.38511035f0,
         0.1697833f0,
        -0.18077055f0,
         0.0077917147f0,
         0.98349446f0,
        -0.38007677f0,
        -0.9228377f0,
        -0.06254859f0
    )

    D = rand(MersenneTwister(1986), DCM{Float32})

    @test D ≈ D_exp atol = 1e-15
end

@testset "Euler angle and axis (Float64)" begin
    aa_exp = EulerAngleAxis(
        3.0732832539795845,
        @SVector [
             0.7668495688612252,
            -0.13482690249452656,
             0.6275057331220841
        ]
    )

    aa = rand(MersenneTwister(1986), EulerAngleAxis)
    @test aa ≈ aa_exp atol = 1e-15

    aa = rand(MersenneTwister(1986), EulerAngleAxis{Float64})
    @test aa ≈ aa_exp atol = 1e-15
end

@testset "Euler angle and axis (Float32)" begin
    aa_exp = EulerAngleAxis(
        1.6446829f0,
        @SVector [
            -0.9557738f0,
             0.2756822f0,
             0.102449425f0
        ]
    )

    aa = rand(MersenneTwister(1986), EulerAngleAxis{Float32})
    @test aa ≈ aa_exp atol = 1e-15
end

@testset "Euler angles (Float64)" begin
    ea_exp = EulerAngles(
        2.5852880822263606,
        3.1861195131389626,
        2.9299487570635576,
        :YXY
    )

    ea = rand(MersenneTwister(1986), EulerAngles)
    @test ea ≈ ea_exp atol = 1e-15

    ea = rand(MersenneTwister(1986), EulerAngles{Float64})
    @test ea ≈ ea_exp atol = 1e-15
end

@testset "Euler angles (Float32)" begin
    ea_exp = EulerAngles(
        2.5852880822263606,
        3.1861195131389626,
        2.9299487570635576,
        :YXY
    )

    ea = rand(MersenneTwister(1986), EulerAngles)
    @test ea ≈ ea_exp atol = 1e-15

    ea = rand(MersenneTwister(1986), EulerAngles{Float64})
    @test ea ≈ ea_exp atol = 1e-15
end

@testset "Quaternion (Float64)" begin
    q_exp = Quaternion(
        -0.03414805970179898,
        -0.7664023306434491,
         0.1347482694144174,
        -0.6271397623279131
    )

    q = rand(MersenneTwister(1986), Quaternion)
    @test q ≈ q_exp atol = 1e-15

    q = rand(MersenneTwister(1986), Quaternion{Float64})
    @test q ≈ q_exp atol = 1e-15
end

@testset "Quaternion (Float32)" begin
    q_exp = Quaternion(
        -0.6805074f0,
         0.7003348f0,
        -0.2020037f0,
        -0.07506891f0
    )

    q = rand(MersenneTwister(1986), Quaternion{Float32})
    @test q ≈ q_exp atol = 1e-15
end
