# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to the kinematics of DCMs.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/dcm.jl
# ==================

# Functions: ddcm
# ---------------

@testset "Kinematics of DCMs" begin
    for T in (Float32, Float64)
        # Create a random DCM.
        Dba₀ = rand(DCM{T})

        # Create a random velocity vector.
        wba_a = @SVector randn(T, 3)

        # Propagate the initial DCM using the sampled velocity vector.
        Δ   = 1f-7
        Dba = Dba₀
        num = 20_000

        for k in 1:num
            dDba = ddcm(Dba, Dba * wba_a)
            Dba  = Dba + dDba * Δ
            Dba  = orthonormalize(Dba)
        end

        # In the end, the vector aligned with `wba_a` must not change.
        v₀ = Dba₀ * wba_a
        v₁ = Dba * wba_a
        @test v₁ ≈ v₀ atol = 100√(eps(T))
        @test eltype(v₀) === T
        @test eltype(v₁) === T

        # In the end, a vector perpendicular to `wba_a` must rotate the angle
        # compatible with the angular velocity and time of integration.
        aux   = @SVector randn(T, 3)
        aux   = aux / norm(aux)
        vr_a  = wba_a × aux
        vr_a  = vr_a / norm(vr_a)
        vr_b₀ = Dba₀ * vr_a
        vr_b  = Dba  * vr_a
        θ     = acos(clamp(vr_b ⋅ vr_b₀, -1, 1))
        @test eltype(vr_b₀) === T
        @test eltype(vr_b) === T

        # Estimate θ based on the angular velocity.
        θest = mod(norm(wba_a) * Δ * num, T(2π))
        θest > pi && (θest = T(2π) - θest)
        @test θ ≈ θest atol = 100√(eps(T))
    end
end

@testset "Kinematics of DCMs (Errors)" begin
    @test_throws ArgumentError ddcm(DCM(I), [1, 2])
    @test_throws ArgumentError ddcm(DCM(I), [1, 2, 3, 4])
end
