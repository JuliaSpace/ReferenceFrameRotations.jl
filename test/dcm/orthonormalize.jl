## Desription ##############################################################################
#
# Tests related to the orthonormalization of DCMs.
#
############################################################################################

# == File: ./src/dcm.jl ====================================================================

# -- Functions: orthonormalize -------------------------------------------------------------

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

    # A genuinely nonorthogonal, full-rank matrix checks the modified
    # Gram-Schmidt result rather than only column-wise rescaling.
    for T in (Float32, Float64)
        A = DCM(
            T(1), T(2), T(2),
            T(2), T(5), T(6),
            T(1), T(0), T(0)
        )
        Q = orthonormalize(A)
        Q_expected = DCM(
            T(1) / 3, T(2) / 3, T(2) / 3,
            -T(2) / 3, -T(1) / 3, T(2) / 3,
            T(2) / 3, -T(2) / 3, T(1) / 3
        )

        @test Q ≈ Q_expected atol = 10 * eps(T)
        @test Q' * Q ≈ DCM(I) atol = 10 * eps(T)
        @test det(Q) ≈ one(T) atol = 10 * eps(T)
    end
end
