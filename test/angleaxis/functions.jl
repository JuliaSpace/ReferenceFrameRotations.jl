# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to the general functions using Euler angle and axis.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/angleaxis.jl
# ========================

# Functions: inv
# --------------

@testset "General functions of Euler angle and axis: inv" begin
    # Float64
    # ==========================================================================
    T = Float64
    av = EulerAngleAxis(deg2rad(T(20)), T[sqrt(2) / 2, 0, sqrt(2) / 2])
    iav = inv(av)
    @test eltype(iav) === T
    @test iav.a ≈ deg2rad(T(20))
    @test iav.v ≈ T[-sqrt(2) / 2, 0, -sqrt(2)/2]

    av = EulerAngleAxis(deg2rad(T(-20)), T[sqrt(2) / 2, 0, sqrt(2) / 2])
    iav = inv(av)
    @test eltype(iav) === T
    @test iav.a ≈ deg2rad(T(20))
    @test iav.v ≈ T[sqrt(2) / 2, 0, sqrt(2)/2]

    # Float32
    # ==========================================================================
    T = Float32
    av = EulerAngleAxis(deg2rad(T(20)), T[sqrt(2) / 2, 0, sqrt(2) / 2])
    iav = inv(av)
    @test eltype(iav) === T
    @test iav.a ≈ deg2rad(T(20))
    @test iav.v ≈ T[-sqrt(2) / 2, 0, -sqrt(2)/2]

    av = EulerAngleAxis(deg2rad(T(-20)), T[sqrt(2) / 2, 0, sqrt(2) / 2])
    iav = inv(av)
    @test eltype(iav) === T
    @test iav.a ≈ deg2rad(T(20))
    @test iav.v ≈ T[sqrt(2) / 2, 0, sqrt(2)/2]
end

# Functions: show
# ---------------

@testset "General functions of Euler angle and axis: show" begin
    buf = IOBuffer()
    io = IOContext(buf)
    av = EulerAngleAxis(π / 3, [sqrt(3) / 3, -sqrt(3) / 3, sqrt(3) / 3])

    # Extended printing.
    show(io, MIME"text/plain"(), av)
    expected = """
        EulerAngleAxis{Float64}:
          Euler angle : 1.0472 rad  (0.018277°)
          Euler axis  : [0.57735, -0.57735, 0.57735]"""
    @test String(take!(io.io)) == expected

    # Comapct printing.
    show(io, av)
    expected = """
        EulerAngleAxis{Float64}: θ = 1.0472 rad, v = [1.41421, 1.41421, 0.0]"""
    @test String(take!(io.io)) == expected

    # Colors.
    io = IOContext(buf, :color => true)
    show(io, MIME"text/plain"(), av)
    expected = """
        EulerAngleAxis{Float64}:
        \e[32;1m  Euler angle : \e[0m1.0472 rad  (0.018277°)
        \e[33;1m  Euler axis  : \e[0m[0.57735, -0.57735, 0.57735]"""
    @test String(take!(io.io)) == expected
end
