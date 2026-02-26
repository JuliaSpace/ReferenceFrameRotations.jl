## Desription ##############################################################################
#
# Tests related to the Modified Rodrigues Parameters (MRP).
#
############################################################################################

# == File: ./src/mrp.jl ====================================================================

# -- Functions: MRP ------------------------------------------------------------------------

@testset "MRP Constructors" begin
    m = MRP(1.0, 2.0, 3.0)
    @test m.q1 == 1.0
    @test m.q2 == 2.0
    @test m.q3 == 3.0
    @test eltype(m) == Float64

    m = MRP(1, 2, 3)
    @test m.q1 == 1
    @test m.q2 == 2
    @test m.q3 == 3
    @test eltype(m) == Int

    m = MRP([1.0, 2.0, 3.0])
    @test m.q1 == 1.0
    @test m.q2 == 2.0
    @test m.q3 == 3.0

    m = MRP(I)
    @test m.q1 == 0
    @test m.q2 == 0
    @test m.q3 == 0

    @test m[1] == 0
    @test m[2] == 0
    @test m[3] == 0
    @test collect(m) == [0, 0, 0]
    @test length(m) == 3
end

# -- Functions: show -----------------------------------------------------------------------

@testset "MRP Show" begin
    buf = IOBuffer()
    io  = IOContext(buf)
    m   = MRP(1.0, -2.0, 3.0)

    # Extended printing.
    show(io, MIME"text/plain"(), m)
    expected = """
        MRP{Float64}:
          X : + 1.0
          Y : - 2.0
          Z : + 3.0"""
    @test String(take!(io.io)) == expected

    # Compact printing.
    show(io, m)
    expected = "MRP{Float64}: [1.0, 2.0, 3.0]"
    @test String(take!(io.io)) == expected

    # Colors.
    io = IOContext(buf, :color => true)
    show(io, MIME"text/plain"(), m)
    expected = """
        MRP{Float64}:
          \e[1mX : \e[0m+ 1.0
          \e[1mY : \e[0m- 2.0
          \e[1mZ : \e[0m+ 3.0"""
    @test String(take!(io.io)) == expected
end

# -- Operators: * --------------------------------------------------------------------------

@testset "MRP Composition" begin
    eul1 = EulerAngles(0.3, 0.2, 0.1, :ZYX)
    eul2 = EulerAngles(-0.2, 0.4, -0.3, :ZYX)

    m1 = dcm_to_mrp(angle_to_dcm(eul1))
    m2 = dcm_to_mrp(angle_to_dcm(eul2))

    m3 = m2 * m1

    # Verify with DCM.
    dcm1  = angle_to_dcm(eul1)
    dcm2  = angle_to_dcm(eul2)
    dcm3  = dcm2 * dcm1
    dcm_m3 = mrp_to_dcm(m3)
    @test maximum(abs.(dcm3 - dcm_m3)) < 1e-12

    # Verify compose_rotation.
    m_comp = compose_rotation(m1, m2)
    @test isapprox(m_comp, m3; atol = 1e-12)
end

# -- Operators: +, -, *, / ----------------------------------------------------------------

@testset "MRP Arithmetic" begin
    m1 = MRP(0.1, 0.2, 0.3)
    m2 = MRP(0.05, -0.05, 0.1)

    m3 = m1 + m2
    @test isapprox(m3.q1, 0.15; atol = 1e-12)
    @test isapprox(m3.q2, 0.15; atol = 1e-12)
    @test isapprox(m3.q3, 0.4;  atol = 1e-12)

    m4 = m1 - m2
    @test isapprox(m4.q1, 0.05; atol = 1e-12)
    @test isapprox(m4.q2, 0.25; atol = 1e-12)
    @test isapprox(m4.q3, 0.2;  atol = 1e-12)

    m_neg = -m1
    @test m_neg.q1 == -0.1
    @test m_neg.q2 == -0.2
    @test m_neg.q3 == -0.3

    m_scaled = 2.0 * m1
    @test m_scaled.q1 == 0.2
    @test m_scaled.q2 == 0.4
    @test m_scaled.q3 == 0.6
    @test m1 * 2.0 == m_scaled

    m_div = m1 / 2.0
    @test m_div.q1 == 0.05
    @test m_div.q2 == 0.1
    @test m_div.q3 == 0.15
end

# -- Operators: inv, /, \ -----------------------------------------------------------------

@testset "MRP Inverse and Division" begin
    m1 = MRP(0.1, 0.2, 0.3)
    m2 = MRP(0.05, -0.05, 0.1)

    m_inv = inv(m1)
    @test m_inv == -m1

    m_identity = m1 * m_inv
    @test isapprox(m_identity.q1, 0.0; atol = 1e-12)
    @test isapprox(m_identity.q2, 0.0; atol = 1e-12)
    @test isapprox(m_identity.q3, 0.0; atol = 1e-12)

    @test isapprox(m1 / m2, m1 * inv(m2))
    @test isapprox(m1 \ m2, inv(m1) * m2)
end

# -- Functions: norm, one, zero, copy, vect -----------------------------------------------

@testset "MRP Utils" begin
    m = MRP(3.0, 0.0, 4.0)
    @test norm(m) == 5.0

    @test one(MRP)  == MRP(0.0, 0.0, 0.0)
    @test one(m)    == MRP(0.0, 0.0, 0.0)
    @test zero(MRP) == MRP(0.0, 0.0, 0.0)
    @test zero(m)   == MRP(0.0, 0.0, 0.0)

    m_copy = copy(m)
    @test m_copy == m

    v = vect(m)
    @test v isa SVector{3, Float64}
    @test v[1] == m.q1
    @test v[2] == m.q2
    @test v[3] == m.q3

    @test I * m  == m
    @test m * I  == m
    @test I / m  == inv(m)
    @test m / I  == m
    @test I \ m  == m
    @test m \ I  == inv(m)
end

# -- Functions: shadow_rotation -----------------------------------------------------------

@testset "MRP Shadow Rotation" begin
    m = MRP(0.1, 0.2, 0.3)
    m_shadow = shadow_rotation(m)

    @test norm(m_shadow) > 1.0
    @test isapprox(norm(m_shadow), 1 / norm(m); atol = 1e-12)

    # The shadow rotation must represent the same rotation.
    dcm        = mrp_to_dcm(m)
    dcm_shadow = mrp_to_dcm(m_shadow)
    @test maximum(abs.(dcm - dcm_shadow)) < 1e-12
end

# -- Functions: rand -----------------------------------------------------------------------

@testset "MRP Random" begin
    Random.seed!(123)
    m = rand(MRP)
    @test m isa MRP{Float64}

    m_float32 = rand(MRP{Float32})
    @test m_float32 isa MRP{Float32}
end

# -- Functions: dmrp -----------------------------------------------------------------------

@testset "MRP Kinematics" begin
    for T in (Float64,)
        Random.seed!(123)

        m  = rand(MRP{T})
        w  = @SVector randn(T, 3)
        dm = dmrp(m, w)

        dt = 1e-8

        D      = mrp_to_dcm(m)
        dD     = ddcm(D, w)
        D_next = orthonormalize(D + dD * dt)

        m_next = dcm_to_mrp(D_next)

        # Switch to the shadow set if necessary to ensure continuity.
        if norm(m_next - m) > 0.1
            m_next = shadow_rotation(m_next)
        end

        dm_num = (m_next - m) / dt

        @test isapprox(dm, dm_num; rtol = 1e-4, atol = 1e-6)
    end
end
