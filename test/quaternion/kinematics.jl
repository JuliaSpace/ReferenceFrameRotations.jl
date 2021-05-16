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

@testset "Kinematics of quaternions (Float64)" begin
    T = Float64

    # Create a random quaternion.
    qba₀ = Quaternion(randn(T), randn(T), randn(T), randn(T))
    qba₀ = qba₀ / norm(qba₀)

    # Create a random velocity vector.
    wba_a = @SVector randn(T, 3)

    # Propagate the initial DCM using the sampled velocity vector.
    Δ   = 1e-7
    qba = qba₀
    num = 2_000_000

    for k in 1:num
        dqba = dquat(qba, vect(qba \ wba_a * qba))
        qba  = qba + dqba * Δ
        qba  = qba / norm(qba)
    end

    # In the end, the vector aligned with `wba_a` must not change.
    v₀ = vect(qba₀ \ wba_a * qba₀)
    v₁ = vect(qba \ wba_a * qba)
    @test v₁ ≈ v₀ rtol = 1e-6
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
    θ     = acos(vr_b ⋅ vr_b₀)
    @test eltype(vr_b₀) === T
    @test eltype(vr_b) === T

    # Estimate θ based on the angular velocity.
    θest = mod(norm(wba_a) * Δ * num, 2π)
    θest > pi && (θest = 2π - θest)
    @test θ ≈ θest atol = 1e-6
end

@testset "Kinematics of quaternions (Float32)" begin
    T = Float32

    # Create a random quaternion.
    qba₀ = Quaternion(randn(T), randn(T), randn(T), randn(T))
    qba₀ = qba₀ / norm(qba₀)

    # Create a random velocity vector.
    wba_a = @SVector randn(T, 3)

    # Propagate the initial DCM using the sampled velocity vector.
    Δ   = 1f-7
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
    @test v₁ ≈ v₀ rtol = 1e-3
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
    θ     = acos(vr_b ⋅ vr_b₀)
    @test eltype(vr_b₀) === T
    @test eltype(vr_b) === T

    # Estimate θ based on the angular velocity.
    θest = mod(norm(wba_a) * Δ * num, T(2π))
    θest > pi && (θest = T(2π) - θest)
    @test θ ≈ θest atol = 1e-3
end
