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

@testset "Kinematics of DCMs (Float64)" begin
    T = Float64

    # Create a random DCM.
    Dba₀ = create_rotation_matrix(_rand_ang(), :Z) *
        create_rotation_matrix(_rand_ang(), :Y) *
        create_rotation_matrix(_rand_ang(), :X)

    # Create a random velocity vector.
    wba_a = @SVector randn(3)

    # Propagate the initial DCM using the sampled velocity vector.
    Δ   = 1e-7
    Dba = Dba₀
    num = 2_000_000

    for k in 1:num
        dDba = ddcm(Dba, Dba * wba_a)
        Dba  = Dba + dDba * Δ
        Dba  = orthonormalize(Dba)
    end

    # In the end, the vector aligned with `wba_a` must not change.
    v₀ = Dba₀ * wba_a
    v₁ = Dba * wba_a
    @test v₁ ≈ v₀
    @test eltype(v₀) === T
    @test eltype(v₁) === T

    # In the end, a vector perpendicular to `wba_a` must rotate the angle
    # compatible with the angular velocity and time of integration.
    aux   = @SVector randn(3)
    aux   = aux / norm(aux)
    vr_a  = wba_a × aux
    vr_a  = vr_a / norm(vr_a)
    vr_b₀ = Dba₀ * vr_a
    vr_b  = Dba  * vr_a
    θ     = acos(vr_b ⋅ vr_b₀)
    @test eltype(vr_b₀) === T
    @test eltype(vr_b) === T

    # Estimate θ based on the angular velocity.
    θest = mod(norm(wba_a) * Δ * num, 2π)
    θest > pi && (θest = 2π - θest)
    @test θ ≈ θest atol = 1e-6
end

@testset "Kinematics of DCMs (Float32)" begin
    T = Float32

    # Create a random DCM.
    Dba₀ = create_rotation_matrix(_rand_ang(T), :Z) *
        create_rotation_matrix(_rand_ang(T), :Y) *
        create_rotation_matrix(_rand_ang(T), :X)

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
    @test v₁ ≈ v₀ rtol = 1e-3
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
    θ     = acos(vr_b ⋅ vr_b₀)
    @test eltype(vr_b₀) === T
    @test eltype(vr_b) === T

    # Estimate θ based on the angular velocity.
    θest = mod(norm(wba_a) * Δ * num, T(2π))
    θest > pi && (θest = T(2π) - θest)
    @test θ ≈ θest atol = 1e-3
end

