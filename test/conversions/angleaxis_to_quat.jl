# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to conversion from Euler angle and axis to quaternion.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/conversions/angleaxis_to_quat.jl
# ============================================

# Functions: angleaxis_to_quat
# ----------------------------

@testset "Euler angle and axis => Quaternion (Float64)" begin
    T = Float64

    # Sample a random Euler angle and axis.
    v = @SVector randn(T, 3)
    v = v / norm(v)
    a = _rand_ang(T)
    av = EulerAngleAxis(a, v)
    q = angleaxis_to_quat(av)
    s = (cos(a / 2) < 0) ? -1 : 1
    @test eltype(q) === T
    @test q.q0 ≈ s * cos(a / 2)
    @test q.q1 ≈ v[1] * sin(a / 2)
    @test q.q2 ≈ v[2] * sin(a / 2)
    @test q.q3 ≈ v[3] * sin(a / 2)
end

@testset "Euler angle and axis => Quaternion (Float32)" begin
    T = Float32

    # Sample a random Euler angle and axis.
    v = @SVector randn(T, 3)
    v = v / norm(v)
    a = _rand_ang(T)
    av = EulerAngleAxis(a, v)
    q = angleaxis_to_quat(av)
    s = (cos(a / 2) < 0) ? -1 : 1
    @test eltype(q) === T
    @test q.q0 ≈ s * cos(a / 2)
    @test q.q1 ≈ v[1] * sin(a / 2)
    @test q.q2 ≈ v[2] * sin(a / 2)
    @test q.q3 ≈ v[3] * sin(a / 2)
end
