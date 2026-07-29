## Description #############################################################################
#
# Tests related to the general functions using Euler angle and axis.
#
############################################################################################

# == File: ./src/angleaxis.jl ==============================================================

# -- Functions: inv ------------------------------------------------------------------------

@testset "General Functions of Euler Angle and Axis: inv" begin
    for T in (Float32, Float64)
        av = EulerAngleAxis(deg2rad(T(20)), T[sqrt(2) / 2, 0, sqrt(2) / 2])
        iav = inv(av)
        @test eltype(iav) === T
        @test iav.a ≈ deg2rad(T(20))
        @test iav.v ≈ T[-sqrt(2) / 2, 0, -sqrt(2) / 2]

        av = EulerAngleAxis(deg2rad(T(-20)), T[sqrt(2) / 2, 0, sqrt(2) / 2])
        iav = inv(av)
        @test eltype(iav) === T
        @test iav.a ≈ deg2rad(T(20))
        @test iav.v ≈ T[sqrt(2) / 2, 0, sqrt(2) / 2]
    end
end

# -- Functions: show -----------------------------------------------------------------------

@testset "General Functions of Euler Angle and Axis: show" begin
    buf = IOBuffer()
    io = IOContext(buf)
    av = EulerAngleAxis(π / 3, [sqrt(3) / 3, -sqrt(3) / 3, sqrt(3) / 3])

    # Extended printing.
    show(io, MIME"text/plain"(), av)
    expected = """
        EulerAngleAxis{Float64}:
          Euler angle : 1.0472 rad  (60.0°)
          Euler axis  : [0.57735, -0.57735, 0.57735]"""
    @test String(take!(io.io)) == expected

    # Compact printing.
    show(io, av)
    expected = """
        EulerAngleAxis{Float64}: θ = 1.0472 rad, v = [0.57735, -0.57735, 0.57735]"""
    @test String(take!(io.io)) == expected

    # Colors.
    io = IOContext(buf, :color => true)
    show(io, MIME"text/plain"(), av)
    expected = """
        EulerAngleAxis{Float64}:
        \e[32;1m  Euler angle : \e[0m1.0472 rad  (60.0°)
        \e[33;1m  Euler axis  : \e[0m[0.57735, -0.57735, 0.57735]"""
    @test String(take!(io.io)) == expected
end

@testset "General Functions of Euler Angle and Axis: inv (Extended Precision)" begin
    setprecision(BigFloat, 256) do
        for a in (big"100.0", big"1000.0")
            av = EulerAngleAxis(a, SVector{3, BigFloat}(1, 0, 0))
            D = angleaxis_to_dcm(av)

            # `2π` must be computed at `BigFloat` precision. Otherwise, the modulo operation
            # loses roughly 60 decimal digits per revolution.
            @test maximum(abs, angleaxis_to_dcm(inv(av)) - D') < 1e-70
        end
    end
end
