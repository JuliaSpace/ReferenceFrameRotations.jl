# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to the operations with quaternions.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/quaternion.jl
# =========================

# Functions: +
# ------------

@testset "Operations with quaternions: +"  begin
    q1 = Quaternion(1, 0, 0, 0)
    q2 = Quaternion(0, cosd(60), 0, sind(60))
    q3 = q1 + q2
    @test q3.q0 == 1
    @test q3.q1 == cosd(60)
    @test q3.q2 == 0
    @test q3.q3 == sind(60)
    @test eltype(q3) === promote_type(eltype(q1), eltype(q2))

    q1 = Quaternion{Float32}(1, 0, 0, 0)
    q2 = Quaternion{Float32}(0, cosd(60), 0, sind(60))
    q3 = q1 + q2
    @test q3.q0 == 1
    @test q3.q1 == cosd(60.0f0)
    @test q3.q2 == 0
    @test q3.q3 == sind(60.0f0)
    @test eltype(q3) === Float32

    q3 = q1 + I
    @test q3.q0 == 2
    @test q3.q1 == 0
    @test q3.q2 == 0
    @test q3.q3 == 0
    @test eltype(q3) === promote_type(eltype(q1), eltype(I))

    q4 = I + q1
    @test q3 === q4

    q3 = q1 + 1.0I
    @test q3.q0 == 2
    @test q3.q1 == 0
    @test q3.q2 == 0
    @test q3.q3 == 0
    @test eltype(q3) === promote_type(eltype(q1), eltype(1.0))
end

# Functions: -
# ------------

@testset "Operations with quaternions: -"  begin
    q1 = Quaternion(1, 2, 3, 4)
    q2 = -q1
    @test q2.q0 == -1
    @test q2.q1 == -2
    @test q2.q2 == -3
    @test q2.q3 == -4
    @test eltype(q2) === eltype(q1)

    q1 = Quaternion(1, 0, 0, 0)
    q2 = Quaternion(0, cosd(60), 0, sind(60))
    q3 = q1 - q2
    @test q3.q0 == 1
    @test q3.q1 == -cosd(60)
    @test q3.q2 == 0
    @test q3.q3 == -sind(60)
    @test eltype(q3) === promote_type(eltype(q1), eltype(q2))

    q1 = Quaternion{Float32}(1, 0, 0, 0)
    q2 = Quaternion{Float32}(0, cosd(60), 0, sind(60))
    q3 = q1 - q2
    @test q3.q0 == 1
    @test q3.q1 == -cosd(60.0f0)
    @test q3.q2 == 0
    @test q3.q3 == -sind(60.0f0)
    @test eltype(q3) === Float32

    q3 = q1 - I
    @test q3.q0 == 0
    @test q3.q1 == 0
    @test q3.q2 == 0
    @test q3.q3 == 0
    @test eltype(q3) === promote_type(eltype(q1), eltype(I))

    q4 = I - q1
    @test q4 == -q3

    q3 = q1 - 1.0I
    @test q3.q0 == 0
    @test q3.q1 == 0
    @test q3.q2 == 0
    @test q3.q3 == 0
    @test eltype(q3) === promote_type(eltype(q1), eltype(1.0))
end

# Functions: *
# ------------

@testset "Operations with quaternions: *" begin
    # Scalar multiplication.
    q1 = Quaternion(1, 0, 0, 0)

    q2 = 2q1
    @test q2.q0 == 2
    @test q2.q1 == 0
    @test q2.q2 == 0
    @test q2.q3 == 0
    @test eltype(q2) === eltype(q1)

    q3 = q1 * 2
    @test q3 === q2

    q2 = 2.0q1
    @test q2.q0 == 2
    @test q2.q1 == 0
    @test q2.q2 == 0
    @test q2.q3 == 0
    @test eltype(q2) === eltype(2.0)

    q3 = q1 * 2.0
    @test q3 === q2

    # Quaternion multiplication (Hamilton product).
    q1 = Quaternion{Float64}(randn(), randn(), randn(), randn())
    q2 = Quaternion{Float64}(randn(), randn(), randn(), randn())
    q3 = q1 * q2

    @test q3.q0 == q1.q0 * q2.q0 - q1.q1 * q2.q1 - q1.q2 * q2.q2 - q1.q3 * q2.q3
    @test q3.q1 == q1.q0 * q2.q1 + q1.q1 * q2.q0 + q1.q2 * q2.q3 - q1.q3 * q2.q2
    @test q3.q2 == q1.q0 * q2.q2 - q1.q1 * q2.q3 + q1.q2 * q2.q0 + q1.q3 * q2.q1
    @test q3.q3 == q1.q0 * q2.q3 + q1.q1 * q2.q2 - q1.q2 * q2.q1 + q1.q3 * q2.q0
    @test eltype(q3) === Float64

    q3 = I * q1
    @test q3 === q1

    q3 = q1 * I
    @test q3 === q1

    q1 = Quaternion{Float32}(randn(), randn(), randn(), randn())
    q2 = Quaternion{Int}(1, 1, 1, 1)
    q3 = q1 * q2

    @test q3.q0 == q1.q0 * q2.q0 - q1.q1 * q2.q1 - q1.q2 * q2.q2 - q1.q3 * q2.q3
    @test q3.q1 == q1.q0 * q2.q1 + q1.q1 * q2.q0 + q1.q2 * q2.q3 - q1.q3 * q2.q2
    @test q3.q2 == q1.q0 * q2.q2 - q1.q1 * q2.q3 + q1.q2 * q2.q0 + q1.q3 * q2.q1
    @test q3.q3 == q1.q0 * q2.q3 + q1.q1 * q2.q2 - q1.q2 * q2.q1 + q1.q3 * q2.q0
    @test eltype(q3) === promote_type(Int, Float32)

    # Quaternion multiplication with a vector.
    q1 = Quaternion{Float64}(randn(), randn(), randn(), randn())
    v1 = randn(3)

    q2 = q1 * v1
    q3 = q1 * Quaternion(0, v1)
    @test q2 === q3

    q2 = v1 * q1
    q3 = Quaternion(0, v1) * q1
    @test q2 === q3

    q1 = Quaternion{Float32}(randn(), randn(), randn(), randn())
    v1 = [1, 2, 3]

    q2 = q1 * v1
    q3 = q1 * Quaternion(0, v1)
    @test q2 === q3

    q2 = v1 * q1
    q3 = Quaternion(0, v1) * q1
    @test q2 === q3
end

# Functions: /
# ------------

@testset "Operations with quaternions: /" begin
    # Scalar division.
    q1 = Quaternion(2, 0, 0, 0)
    q2 = q1 / 2
    @test q2.q0 == 1
    @test q2.q1 == 0
    @test q2.q2 == 0
    @test q2.q3 == 0

    q1 = Quaternion(2, 1, 0, 1)
    q2 = 2 / q1
    @test q2.q0 == +2 / 3
    @test q2.q1 == -1 / 3
    @test q2.q2 == 0
    @test q2.q3 == -1 / 3

    q1 = Quaternion(1, 0, 1, 0)
    q2 = 2.0q1
    @test q2.q0 == 2
    @test q2.q1 == 0
    @test q2.q2 == 2
    @test q2.q3 == 0
    @test eltype(q2) === eltype(2.0)

    # Quaternion division (Hamilton product).
    q1 = Quaternion{Float64}(randn(), randn(), randn(), randn())
    q2 = Quaternion{Float64}(randn(), randn(), randn(), randn())
    q3 = q1 / q2
    norm_q2² = norm(q2) * norm(q2)

    @test q3.q0 ≈ (+ q1.q0 * q2.q0 + q1.q1 * q2.q1 + q1.q2 * q2.q2 + q1.q3 * q2.q3)/norm_q2²
    @test q3.q1 ≈ (- q1.q0 * q2.q1 + q1.q1 * q2.q0 - q1.q2 * q2.q3 + q1.q3 * q2.q2)/norm_q2²
    @test q3.q2 ≈ (- q1.q0 * q2.q2 + q1.q1 * q2.q3 + q1.q2 * q2.q0 - q1.q3 * q2.q1)/norm_q2²
    @test q3.q3 ≈ (- q1.q0 * q2.q3 - q1.q1 * q2.q2 + q1.q2 * q2.q1 + q1.q3 * q2.q0)/norm_q2²
    @test eltype(q3) === Float64

    q3 = I / q1
    @test q3 ≈ inv(q1)

    q3 = q1 / I
    @test q3 === q1

    q1 = Quaternion{Float32}(randn(), randn(), randn(), randn())
    q2 = Quaternion{Float32}(1, 1, 1, 1)
    q3 = q1 / q2
    norm_q2² = norm(q2) * norm(q2)

    @test q3.q0 ≈ (+ q1.q0 * q2.q0 + q1.q1 * q2.q1 + q1.q2 * q2.q2 + q1.q3 * q2.q3)/norm_q2²
    @test q3.q1 ≈ (- q1.q0 * q2.q1 + q1.q1 * q2.q0 - q1.q2 * q2.q3 + q1.q3 * q2.q2)/norm_q2²
    @test q3.q2 ≈ (- q1.q0 * q2.q2 + q1.q1 * q2.q3 + q1.q2 * q2.q0 - q1.q3 * q2.q1)/norm_q2²
    @test q3.q3 ≈ (- q1.q0 * q2.q3 - q1.q1 * q2.q2 + q1.q2 * q2.q1 + q1.q3 * q2.q0)/norm_q2²
    @test eltype(q3) === promote_type(Int, Float32)
end

# Functions: \
# ------------

@testset "Operations with quaternions: \\" begin
    # Quaternion division (Hamilton product).
    q1 = Quaternion{Float64}(randn(), randn(), randn(), randn())
    q2 = Quaternion{Float64}(randn(), randn(), randn(), randn())
    q3 = q1 \ q2
    q4 = inv(q1) * q2
    @test q3 ≈ q4

    q1 = Quaternion{Float32}(randn(), randn(), randn(), randn())
    q2 = Quaternion{Float32}(randn(), randn(), randn(), randn())
    q3 = q1 \ q2
    q4 = inv(q1) * q2
    @test q3 ≈ q4
    @test eltype(q3) == Float32

    # Quaternion multiplication with a vector.
    q1 = Quaternion{Float64}(randn(), randn(), randn(), randn())
    v1 = randn(3)
    q2 = v1 \ q1
    q3 = inv(Quaternion(0, v1)) * q1
    @test q2 ≈ q3
    @test eltype(q2) == Float64

    q2 = q1 \ v1
    q3 = inv(q1) * Quaternion(0, v1)
    @test q2 ≈ q3
    @test eltype(q2) == Float64

    q1 = Quaternion{Float32}(randn(), randn(), randn(), randn())
    v1 = randn(Float32, 3)
    q2 = v1 \ q1
    q3 = inv(Quaternion(0, v1)) * q1
    @test q2 ≈ q3
    @test eltype(q2) == Float32

    q2 = q1 \ v1
    q3 = inv(q1) * Quaternion(0, v1)
    @test q2 ≈ q3
    @test eltype(q2) == Float32
end
