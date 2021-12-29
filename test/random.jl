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

@testset "Euler angles (Float64)" begin
    ea_exp = EulerAngles(
        2.5852880822263606,
        3.1861195131389626,
        2.9299487570635576,
        :YXY
    )

    ea = rand(MersenneTwister(1986), EulerAngles)
    @test ea.a1 ≈ ea_exp.a1 atol = 1e-15
    @test ea.a2 ≈ ea_exp.a2 atol = 1e-15
    @test ea.a3 ≈ ea_exp.a3 atol = 1e-15
    @test ea.rot_seq == ea_exp.rot_seq

    ea = rand(MersenneTwister(1986), EulerAngles{Float64})
    @test ea.a1 ≈ ea_exp.a1 atol = 1e-15
    @test ea.a2 ≈ ea_exp.a2 atol = 1e-15
    @test ea.a3 ≈ ea_exp.a3 atol = 1e-15
    @test ea.rot_seq == ea_exp.rot_seq
end

@testset "Euler angles (Float32)" begin
    ea_exp = EulerAngles(
        2.5852880822263606,
        3.1861195131389626,
        2.9299487570635576,
        :YXY
    )

    ea = rand(MersenneTwister(1986), EulerAngles)
    @test ea.a1 ≈ ea_exp.a1 atol = 1e-15
    @test ea.a2 ≈ ea_exp.a2 atol = 1e-15
    @test ea.a3 ≈ ea_exp.a3 atol = 1e-15
    @test ea.rot_seq == ea_exp.rot_seq

    ea = rand(MersenneTwister(1986), EulerAngles{Float64})
    @test ea.a1 ≈ ea_exp.a1 atol = 1e-15
    @test ea.a2 ≈ ea_exp.a2 atol = 1e-15
    @test ea.a3 ≈ ea_exp.a3 atol = 1e-15
    @test ea.rot_seq == ea_exp.rot_seq
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
