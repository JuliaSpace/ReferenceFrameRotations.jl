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

@testset "DCM orthonormalization" begin
    for T in (Float32, Float64)
        α = 1 + rand(T)
        D = rand(DCM{T})

        v₁ = D[:, 1]
        v₂ = D[:, 2]
        v₃ = D[:, 3]

        D1 = DCM(hcat(v₁ * α, v₂,     v₃    ))
        D2 = DCM(hcat(v₁,     v₂ * α, v₃    ))
        D3 = DCM(hcat(v₁,     v₂,     v₃ * α))
        D4 = DCM(hcat(v₁ * α, v₂ * α, v₃    ))
        D5 = DCM(hcat(v₁,     v₂ * α, v₃ * α))
        D6 = DCM(hcat(v₁ * α, v₂,     v₃ * α))

        @test norm(D - orthonormalize(D1)) ≈ 0 atol = 10 * eps(T)
        @test norm(D - orthonormalize(D2)) ≈ 0 atol = 10 * eps(T)
        @test norm(D - orthonormalize(D3)) ≈ 0 atol = 10 * eps(T)
        @test norm(D - orthonormalize(D4)) ≈ 0 atol = 10 * eps(T)
        @test norm(D - orthonormalize(D5)) ≈ 0 atol = 10 * eps(T)
        @test norm(D - orthonormalize(D6)) ≈ 0 atol = 10 * eps(T)

        Do = orthonormalize(D1)
        @test eltype(Do) === T
    end
end
