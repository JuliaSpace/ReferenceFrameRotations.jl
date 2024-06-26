## Desription ##############################################################################
#
# Tests related to the general functions using quaternions.
#
############################################################################################

# == File: ./src/quaternion.jl =============================================================

# -- Functions: conj -----------------------------------------------------------------------

@testset "General Functions of Quaternions: conj" begin
    q = Quaternion{Int}(1, 2, 3, 4)
    qc = conj(q)
    @test qc.q0 == +1
    @test qc.q1 == -2
    @test qc.q2 == -3
    @test qc.q3 == -4
    @test eltype(qc) === Int

    q = Quaternion{Float32}(randn(), randn(), randn(), randn())
    qc = conj(q)
    @test qc.q0 ≈ +q.q0
    @test qc.q1 ≈ -q.q1
    @test qc.q2 ≈ -q.q2
    @test qc.q3 ≈ -q.q3
    @test eltype(qc) === eltype(q)

    q = Quaternion{Float64}(randn(), randn(), randn(), randn())
    qc = conj(q)
    @test qc.q0 ≈ +q.q0
    @test qc.q1 ≈ -q.q1
    @test qc.q2 ≈ -q.q2
    @test qc.q3 ≈ -q.q3
    @test eltype(qc) === eltype(q)
end

# -- Functions: copy -----------------------------------------------------------------------

@testset "General Functions of Quaternions: copy" begin
    q = Quaternion{Int}(1, 2, 3, 4)
    qc = copy(q)
    @test q === qc
    @test eltype(qc) === Int

    q = Quaternion{Float32}(randn(), randn(), randn(), randn())
    qc = copy(q)
    @test q === qc
    @test eltype(qc) === eltype(q)

    q = Quaternion{Float64}(randn(), randn(), randn(), randn())
    qc = copy(q)
    @test q === qc
    @test eltype(qc) === eltype(q)
end

# -- Functions: imag -----------------------------------------------------------------------

@testset "General Functions of Quaternions: imag" begin
    q = Quaternion{Int}(1, 2, 3, 4)
    v = imag(q)
    @test v[1] == 2
    @test v[2] == 3
    @test v[3] == 4
    @test eltype(v) === Int

    q = Quaternion{Float32}(randn(), randn(), randn(), randn())
    v = imag(q)
    @test v[1] == q.q1
    @test v[2] == q.q2
    @test v[3] == q.q3
    @test eltype(v) === eltype(q)

    q = Quaternion{Float64}(randn(), randn(), randn(), randn())
    v = imag(q)
    @test v[1] == q.q1
    @test v[2] == q.q2
    @test v[3] == q.q3
    @test eltype(v) === eltype(q)
end

# -- Function: inv -------------------------------------------------------------------------

@testset "General Functions of Quaternions: inv" begin
    q = Quaternion{Float64}(randn(), randn(), randn(), randn())
    qi = inv(q)
    norm_q² = q.q0 * q.q0 + q.q1 * q.q1 + q.q2 * q.q2 + q.q3 * q.q3
    @test qi.q0 == +q.q0 / norm_q²
    @test qi.q1 == -q.q1 / norm_q²
    @test qi.q2 == -q.q2 / norm_q²
    @test qi.q3 == -q.q3 / norm_q²
    @test eltype(qi) === Float64

    q = Quaternion{Float32}(randn(), randn(), randn(), randn())
    qi = inv(q)
    norm_q² = q.q0 * q.q0 + q.q1 * q.q1 + q.q2 * q.q2 + q.q3 * q.q3
    @test qi.q0 == +q.q0 / norm_q²
    @test qi.q1 == -q.q1 / norm_q²
    @test qi.q2 == -q.q2 / norm_q²
    @test qi.q3 == -q.q3 / norm_q²
    @test eltype(qi) === Float32
end

# -- Function: norm ------------------------------------------------------------------------

@testset "General Functions of Quaternions: norm" begin
    q = Quaternion{Float64}(randn(), randn(), randn(), randn())
    norm_q = norm(q)
    @test norm(q) ≈ sqrt(q.q0 * q.q0 + q.q1 * q.q1 + q.q2 * q.q2 + q.q3 * q.q3)
    @test norm_q isa Float64

    q = Quaternion{Float32}(randn(), randn(), randn(), randn())
    norm_q = norm(q)
    @test norm(q) ≈ sqrt(q.q0 * q.q0 + q.q1 * q.q1 + q.q2 * q.q2 + q.q3 * q.q3)
    @test norm_q isa Float32
end

# -- Function: real ------------------------------------------------------------------------

@testset "General Functions of Quaternions: real" begin
    q = Quaternion{Float64}(randn(), randn(), randn(), randn())
    real_q = real(q)
    @test real_q == q.q0
    @test real_q isa Float64

    q = Quaternion{Float32}(randn(), randn(), randn(), randn())
    real_q = real(q)
    @test real_q == q.q0
    @test real_q isa Float32

    q = Quaternion{Int}(1, 0, 0, 0)
    real_q = real(q)
    @test real_q == 1
    @test real_q isa Int
end

# -- Functions: vect -----------------------------------------------------------------------

@testset "General Functions of Quaternions: vect" begin
    q = Quaternion{Int}(1, 2, 3, 4)
    v = vect(q)
    @test v[1] == 2
    @test v[2] == 3
    @test v[3] == 4
    @test eltype(v) === Int

    q = Quaternion{Float32}(randn(), randn(), randn(), randn())
    v = vect(q)
    @test v[1] == q.q1
    @test v[2] == q.q2
    @test v[3] == q.q3
    @test eltype(v) === eltype(q)

    q = Quaternion{Float64}(randn(), randn(), randn(), randn())
    v = vect(q)
    @test v[1] == q.q1
    @test v[2] == q.q2
    @test v[3] == q.q3
    @test eltype(v) === eltype(q)
end

# -- Functions: one ------------------------------------------------------------------------

@testset "General Functions of Quaternions: one" begin
    q = one(Quaternion)
    @test q.q0 == 1
    @test q.q1 == 0
    @test q.q2 == 0
    @test q.q3 == 0
    @test eltype(q) === Float64

    q = one(Quaternion{Float32})
    @test q.q0 == 1
    @test q.q1 == 0
    @test q.q2 == 0
    @test q.q3 == 0
    @test eltype(q) === Float32

    qi = Quaternion(1, 0, 0, 0)
    q = one(qi)
    @test q.q0 == 1
    @test q.q1 == 0
    @test q.q2 == 0
    @test q.q3 == 0
    @test eltype(q) === Int
end

# -- Functions: zero -----------------------------------------------------------------------

@testset "General Functions of Quaternions: zero" begin
    q = zero(Quaternion)
    @test q.q0 == 0
    @test q.q1 == 0
    @test q.q2 == 0
    @test q.q3 == 0
    @test eltype(q) === Float64

    q = zero(Quaternion{Float32})
    @test q.q0 == 0
    @test q.q1 == 0
    @test q.q2 == 0
    @test q.q3 == 0
    @test eltype(q) === Float32

    qi = Quaternion(1, 0, 0, 0)
    q = zero(qi)
    @test q.q0 == 0
    @test q.q1 == 0
    @test q.q2 == 0
    @test q.q3 == 0
    @test eltype(q) === Int
end

# -- Functions: getindex, length, setindex! ------------------------------------------------

@testset "General Functions of Quaternions: Iterable Object API" begin
    q = Quaternion{Float64}(randn(), randn(), randn(), randn())
    @test length(q) == 4
    @test q[1] == q.q0
    @test q[2] == q.q1
    @test q[3] == q.q2
    @test q[4] == q.q3

    @test_throws BoundsError q[0]
    @test_throws BoundsError q[5]

    v = zeros(10)

    v[4:7] = q

    @test v[1]  == 0
    @test v[2]  == 0
    @test v[3]  == 0
    @test v[4]  == q.q0
    @test v[5]  == q.q1
    @test v[6]  == q.q2
    @test v[7]  == q.q3
    @test v[8]  == 0
    @test v[9]  == 0
    @test v[10] == 0

    @test firstindex(q) === 1
    @test lastindex(q) === 4
end

# -- Functions: show -----------------------------------------------------------------------

@testset "General Functions of Quaternions: show" begin
    buf = IOBuffer()
    io = IOContext(buf)
    q = Quaternion{Float64}(1, 2, exp(1), π)

    # Extended printing.
    show(io, MIME"text/plain"(), q)
    expected = """
        Quaternion{Float64}:
          + 1.0 + 2.0⋅i + 2.71828⋅j + 3.14159⋅k"""
    @test String(take!(io.io)) == expected

    # Comapct printing.
    show(io, q)
    expected = """
        Quaternion{Float64}: + 1.0 + 2.0⋅i + 2.71828⋅j + 3.14159⋅k"""
    @test String(take!(io.io)) == expected

    # Colors.
    io = IOContext(buf, :color => true)
    show(io, MIME"text/plain"(), q)
    expected = """
        Quaternion{Float64}:
          + 1.0 + 2.0⋅\e[1mi\e[0m + 2.71828⋅\e[1mj\e[0m + 3.14159⋅\e[1mk\e[0m"""
    @test String(take!(io.io)) == expected
end
