# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to the support of Julia API (iterators, broadcast, etc.).
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/quaternion.jl
# =========================

# Broadcast
# ---------

@testset "Broadcast" begin
    function quat_bcast!(v::AbstractVector, q::Quaternion)
        v .= q
        return nothing
    end

    # Precompile to avoid counting allocations related to compilation.
    precompile(quat_bcast!, (Vector{Float64}, Quaternion{Float64}))
    precompile(quat_bcast!, (Vector{Float32}, Quaternion{Float32}))

    # Float64, Float32
    # --------------------------------------------------------------------------

    for T in (Float32, Float64)
        q = Quaternion{T}(randn(), randn(), randn(), randn())
        q = q / norm(q)
        v = zeros(T, 4)

        alloc = @allocated quat_bcast!(v, q)

        @test v[1]  == q[1]
        @test v[2]  == q[2]
        @test v[3]  == q[3]
        @test v[4]  == q[4]
        @test alloc == 0
    end
end

@testset "setindex!" begin
    function quat_setindex!(v::AbstractVector, q::Quaternion)
        v[4:7] = q[:]
        return nothing
    end

    # Precompile to avoid counting allocations related to compilation.
    precompile(quat_setindex!, (Vector{Float64}, Quaternion{Float64}))
    precompile(quat_setindex!, (Vector{Float32}, Quaternion{Float32}))

    # Float64, Float32
    # --------------------------------------------------------------------------

    for T in (Float32, Float64)
        q = Quaternion{T}(randn(), randn(), randn(), randn())
        q = q / norm(q)
        v = zeros(T, 20)

        alloc = @allocated quat_setindex!(v, q)

        @test v[4]  == q[1]
        @test v[5]  == q[2]
        @test v[6]  == q[3]
        @test v[7]  == q[4]
        @test alloc == 0
    end
end

@testset "Other API functions" begin
    q = Quaternion(1.0, 2.0, 3.0, 4.0)

    @test axes(q) === (Base.OneTo(4),)
    @test ndims(q) === 1
    @test ndims(Quaternion) === 1
    @test length(q) === 4
    @test size(q) === (4,)
    @test Broadcast.broadcastable(q) === q
    @test Base.IndexStyle(Quaternion) === IndexLinear()
end

