## Description #############################################################################
#
# Tests related to the operations with Euler angle and axis.
#
############################################################################################

# == File: ./src/angleaxis.jl ==============================================================

# -- Functions: * --------------------------------------------------------------------------

@testset "Operations with Euler Angle and Axis: *" begin
    for T in (Float32, Float64)
        av1 = EulerAngleAxis(deg2rad(T(45)), T[sqrt(2) / 2, sqrt(2) / 2, 0])
        av2 = EulerAngleAxis(deg2rad(T(45)), T[sqrt(2) / 2, sqrt(2) / 2, 0])

        av3 = av1 * av2
        @test eltype(av3) === T
        @test av3.a ≈ deg2rad(90)
        @test av3.v ≈ [sqrt(2)/2, sqrt(2)/2, 0]

        av3 = av1 * av1 * av1 * av1 * av1 * av1 * av3
        @test eltype(av3) === T
        @test av3.a ≈ deg2rad(0) atol = 10 * √(eps(T))
        @test av3.v ≈ [0, 0, 0] atol = √(eps(T))

        inferred = @inferred av1 * av2
        @test inferred isa EulerAngleAxis{T}

        # Roundoff or a slightly non-unit input axis must not make acos or sqrt fail.
        almost_unit = EulerAngleAxis(T(π), T[one(T) + eps(T), 0, 0])
        identity = @inferred almost_unit * almost_unit
        @test identity == EulerAngleAxis(zero(T), T[0, 0, 0])
    end

    mixed = @inferred EulerAngleAxis(1, [1, 0, 0]) * EulerAngleAxis(1.0f0, Float32[1, 0, 0])
    @test mixed isa EulerAngleAxis{float(promote_type(Int, Float32))}
end
