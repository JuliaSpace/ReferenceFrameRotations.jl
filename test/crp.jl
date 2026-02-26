## Desription ##############################################################################
#
# Tests related to the Classical Rodrigues Parameters (CRP).
#
############################################################################################

# == File: ./src/crp.jl ====================================================================

# -- Functions: CRP ------------------------------------------------------------------------

@testset "CRP Constructors" begin
    c = CRP(1.0, 2.0, 3.0)
    @test c.q1 == 1.0
    @test c.q2 == 2.0
    @test c.q3 == 3.0
    @test eltype(c) == Float64

    c = CRP(1.0, 2, 3)
    @test c.q1 == 1.0
    @test c.q2 == 2.0
    @test c.q3 == 3.0
    @test eltype(c) == Float64

    c = CRP(1.0f0, 2, 3)
    @test c.q1 == 1.0
    @test c.q2 == 2.0
    @test c.q3 == 3.0
    @test eltype(c) == Float32

    c = CRP(1, 2, 3)
    @test c.q1 == 1
    @test c.q2 == 2
    @test c.q3 == 3
    @test eltype(c) == Int

    c = CRP([1.0, 2.0, 3.0])
    @test c.q1 == 1.0
    @test c.q2 == 2.0
    @test c.q3 == 3.0

    c = CRP(I)
    @test c.q1 == 0
    @test c.q2 == 0
    @test c.q3 == 0

    @test c[1] == 0
    @test c[2] == 0
    @test c[3] == 0
    @test collect(c) == [0, 0, 0]
    @test length(c) == 3
end

# -- Functions: show -----------------------------------------------------------------------

@testset "CRP Show" begin
    buf = IOBuffer()
    io  = IOContext(buf)
    c   = CRP(1.0, -2.0, 3.0)

    # Extended printing.
    show(io, MIME"text/plain"(), c)
    expected = """
        CRP{Float64}:
          X : + 1.0
          Y : - 2.0
          Z : + 3.0"""
    @test String(take!(io.io)) == expected

    # Compact printing.
    show(io, c)
    expected = "CRP{Float64}: [1.0, 2.0, 3.0]"
    @test String(take!(io.io)) == expected

    # Colors.
    io = IOContext(buf, :color => true)
    show(io, MIME"text/plain"(), c)
    expected = """
        CRP{Float64}:
          \e[1mX : \e[0m+ 1.0
          \e[1mY : \e[0m- 2.0
          \e[1mZ : \e[0m+ 3.0"""
    @test String(take!(io.io)) == expected
end

# -- Operators: * --------------------------------------------------------------------------

@testset "CRP Composition" begin
    eul1 = EulerAngles(0.3, 0.2, 0.1, :ZYX)
    eul2 = EulerAngles(-0.2, 0.4, -0.3, :ZYX)

    c1 = dcm_to_crp(angle_to_dcm(eul1))
    c2 = dcm_to_crp(angle_to_dcm(eul2))

    c3 = c2 * c1

    # Verify with DCM.
    dcm1  = angle_to_dcm(eul1)
    dcm2  = angle_to_dcm(eul2)
    dcm3  = dcm2 * dcm1
    dcm_c3 = crp_to_dcm(c3)
    @test maximum(abs.(dcm3 - dcm_c3)) < 1e-12

    # Verify compose_rotation.
    c_comp = compose_rotation(c1, c2)
    @test isapprox(c_comp, c3; atol = 1e-12)
end

# -- Operators: +, -, *, / ----------------------------------------------------------------

@testset "CRP Arithmetic" begin
    c1 = CRP(1.0, 2.0, 3.0)
    c2 = CRP(0.5, -0.5, 1.0)

    c3 = c1 + c2
    @test isapprox(c3.q1, 1.5; atol = 1e-12)
    @test isapprox(c3.q2, 1.5; atol = 1e-12)
    @test isapprox(c3.q3, 4.0; atol = 1e-12)

    c4 = c1 - c2
    @test c4.q1 == 0.5
    @test c4.q2 == 2.5
    @test c4.q3 == 2.0

    c_neg = -c1
    @test c_neg.q1 == -1.0
    @test c_neg.q2 == -2.0
    @test c_neg.q3 == -3.0

    c_scaled = 2.0 * c1
    @test c_scaled.q1 == 2.0
    @test c_scaled.q2 == 4.0
    @test c_scaled.q3 == 6.0
    @test c1 * 2.0 == c_scaled

    c_div = c1 / 2.0
    @test c_div.q1 == 0.5
    @test c_div.q2 == 1.0
    @test c_div.q3 == 1.5
end

# -- Operators: inv, /, \ -----------------------------------------------------------------

@testset "CRP Inverse and Division" begin
    c1 = CRP(1.0, 2.0, 3.0)
    c2 = CRP(0.5, -0.5, 1.0)

    c_inv = inv(c1)
    @test c_inv == -c1

    c_identity = c1 * c_inv
    @test isapprox(c_identity.q1, 0.0; atol = 1e-12)
    @test isapprox(c_identity.q2, 0.0; atol = 1e-12)
    @test isapprox(c_identity.q3, 0.0; atol = 1e-12)

    @test isapprox(c1 / c2, c1 * inv(c2))
    @test isapprox(c1 \ c2, inv(c1) * c2)
end

# -- Functions: norm, one, zero, copy, vect -----------------------------------------------

@testset "CRP Utils" begin
    c = CRP(3.0, 0.0, 4.0)
    @test norm(c) == 5.0

    @test one(CRP)  == CRP(0.0, 0.0, 0.0)
    @test one(c)    == CRP(0.0, 0.0, 0.0)
    @test zero(CRP) == CRP(0.0, 0.0, 0.0)
    @test zero(c)   == CRP(0.0, 0.0, 0.0)

    c_copy = copy(c)
    @test c_copy == c

    v = vect(c)
    @test v isa SVector{3, Float64}
    @test v[1] == c.q1
    @test v[2] == c.q2
    @test v[3] == c.q3

    @test I * c  == c
    @test c * I  == c
    @test I / c  == inv(c)
    @test c / I  == c
    @test I \ c  == c
    @test c \ I  == inv(c)
end

# -- Functions: shadow_rotation -----------------------------------------------------------

@testset "CRP Shadow Rotation" begin
    c = CRP(1.0, 2.0, 3.0)
    c_shadow = shadow_rotation(c)
    @test c == c_shadow
end

# -- Functions: rand -----------------------------------------------------------------------

@testset "CRP Random" begin
    Random.seed!(123)
    c = rand(CRP)
    @test c isa CRP{Float64}

    c_float32 = rand(CRP{Float32})
    @test c_float32 isa CRP{Float32}
end

# -- Functions: dcrp -----------------------------------------------------------------------

@testset "CRP Kinematics" begin
    for T in (Float64,)
        Random.seed!(123)

        c  = rand(CRP{T})
        w  = @SVector randn(T, 3)
        dc = dcrp(c, w)

        dt = 1e-8

        D      = crp_to_dcm(c)
        dD     = ddcm(D, w)
        D_next = orthonormalize(D + dD * dt)

        c_next = dcm_to_crp(D_next)
        dc_num = (c_next - c) / dt

        @test isapprox(dc, dc_num; rtol = 1e-4, atol = 1e-6)
    end
end
