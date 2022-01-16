# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to the kinematics of quaternions.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/quaternion.jl
# =========================

# Functions: dquat
# ----------------

@testset "Kinematics of quaternions" begin
    for T in (Float32, Float64)
        # Create a random quaternion.
        qba₀ = rand(Quaternion{T})

        # Create a random velocity vector.
        wba_a = @SVector randn(T, 3)

        # Propagate the initial DCM using the sampled velocity vector.
        Δ   = T(1e-7)
        qba = qba₀
        num = 20_000

        for k in 1:num
            dqba = dquat(qba, vect(qba \ wba_a * qba))
            qba  = qba + dqba * Δ
            qba  = qba / norm(qba)
        end

        # In the end, the vector aligned with `wba_a` must not change.
        v₀ = vect(qba₀ \ wba_a * qba₀)
        v₁ = vect(qba \ wba_a * qba)
        @test v₁ ≈ v₀ atol = 100 * √(eps(T))
        @test eltype(v₀) === T
        @test eltype(v₁) === T

        # In the end, a vector perpendicular to `wba_a` must rotate the angle
        # compatible with the angular velocity and time of integration.
        aux   = @SVector randn(T , 3)
        aux   = aux / norm(aux)
        vr_a  = wba_a × aux
        vr_a  = vr_a / norm(vr_a)
        vr_b₀ = vect(qba₀ \ vr_a * qba₀)
        vr_b  = vect(qba \ vr_a * qba)
        θ     = acos(clamp(vr_b ⋅ vr_b₀, -1, 1))
        @test eltype(vr_b₀) === T
        @test eltype(vr_b) === T

        # Estimate θ based on the angular velocity.
        θest = mod(norm(wba_a) * Δ * num, T(2π))
        θest > pi && (θest = T(2π) - θest)
        @test θ ≈ θest atol = 100 * √(eps(T))
    end
end

@testset "Kinematics of quaternions (Errors)" begin
    @test_throws ArgumentError dquat(Quaternion(I), [1, 2])
    @test_throws ArgumentError dquat(Quaternion(I), [1, 2, 3, 4])
end
