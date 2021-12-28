# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to the orthonormalization of DCMs.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/dcm.jl
# ==================

# Functions: orthonormalize
# -------------------------

@testset "DCM orthonormalization (Float64)" begin
    ang_x = -π + 2π * rand()
    ang_y = -π + 2π * rand()
    ang_z = -π + 2π * rand()
    α     = 1 + rand()

    D = angle_to_dcm(ang_x, :X) *
        angle_to_dcm(ang_y, :Y) *
        angle_to_dcm(ang_z, :Z)

    v₁ = D[:, 1]
    v₂ = D[:, 2]
    v₃ = D[:, 3]

    D1 = DCM(hcat(v₁ * α, v₂,     v₃    ))
    D2 = DCM(hcat(v₁,     v₂ * α, v₃    ))
    D3 = DCM(hcat(v₁,     v₂,     v₃ * α))
    D4 = DCM(hcat(v₁ * α, v₂ * α, v₃    ))
    D5 = DCM(hcat(v₁,     v₂ * α, v₃ * α))
    D6 = DCM(hcat(v₁ * α, v₂,     v₃ * α))

    @test norm(D - orthonormalize(D1)) ≈ 0 atol=1e-15
    @test norm(D - orthonormalize(D2)) ≈ 0 atol=1e-15
    @test norm(D - orthonormalize(D3)) ≈ 0 atol=1e-15
    @test norm(D - orthonormalize(D4)) ≈ 0 atol=1e-15
    @test norm(D - orthonormalize(D5)) ≈ 0 atol=1e-15
    @test norm(D - orthonormalize(D6)) ≈ 0 atol=1e-15

    Do = orthonormalize(D1)
    @test eltype(Do) === Float64
end

@testset "DCM orthonormalization (Float32)" begin
    T = Float32
    ang_x = T(-π) + T(2π) * rand(T)
    ang_y = T(-π) + T(2π) * rand(T)
    ang_z = T(-π) + T(2π) * rand(T)
    α     = 1 + rand(T)

    D = angle_to_dcm(ang_x, :X) *
        angle_to_dcm(ang_y, :Y) *
        angle_to_dcm(ang_z, :Z)

    v₁ = D[:, 1]
    v₂ = D[:, 2]
    v₃ = D[:, 3]

    D1 = DCM(hcat(v₁ * α, v₂,     v₃    ))
    D2 = DCM(hcat(v₁,     v₂ * α, v₃    ))
    D3 = DCM(hcat(v₁,     v₂,     v₃ * α))
    D4 = DCM(hcat(v₁ * α, v₂ * α, v₃    ))
    D5 = DCM(hcat(v₁,     v₂ * α, v₃ * α))
    D6 = DCM(hcat(v₁ * α, v₂,     v₃ * α))

    @test norm(D - orthonormalize(D1)) ≈ 0 atol=1e-5
    @test norm(D - orthonormalize(D2)) ≈ 0 atol=1e-5
    @test norm(D - orthonormalize(D3)) ≈ 0 atol=1e-5
    @test norm(D - orthonormalize(D4)) ≈ 0 atol=1e-5
    @test norm(D - orthonormalize(D5)) ≈ 0 atol=1e-5
    @test norm(D - orthonormalize(D6)) ≈ 0 atol=1e-5

    Do = orthonormalize(D1)
    @test eltype(Do) === Float32
end
