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

    # Test indexing and iteration
    @test m[1] == 0
    @test m[2] == 0
    @test m[3] == 0
    @test collect(m) == [0, 0, 0]
    @test length(m) == 3
end

@testset "MRP Show" begin
    m = MRP(1.0, 2.0, 3.0)
    io = IOBuffer()
    show(io, m)
    s = String(take!(io))
    @test occursin("MRP{Float64}", s)
    @test occursin("1.0", s)
    @test occursin("2.0", s)
    @test occursin("3.0", s)
end
