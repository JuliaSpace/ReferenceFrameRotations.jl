@testset "CRP Constructors" begin
    c = CRP(1.0, 2.0, 3.0)
    @test c.q1 == 1.0
    @test c.q2 == 2.0
    @test c.q3 == 3.0
    @test eltype(c) == Float64

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

    # Test indexing and iteration
    @test c[1] == 0
    @test c[2] == 0
    @test c[3] == 0
    @test collect(c) == [0, 0, 0]
    @test length(c) == 3
end

@testset "CRP Show" begin
    c = CRP(1.0, 2.0, 3.0)
    io = IOBuffer()
    show(io, c)
    s = String(take!(io))
    @test occursin("CRP{Float64}", s)
    @test occursin("1.0", s)
    @test occursin("2.0", s)
    @test occursin("3.0", s)
end
