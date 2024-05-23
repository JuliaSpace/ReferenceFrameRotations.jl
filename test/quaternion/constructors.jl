## Desription ##############################################################################
#
# Tests related to the constructors of the quaternions.
#
############################################################################################

# == File: ./src/quaternion.jl =============================================================

# -- Function: Quaternion ------------------------------------------------------------------

@testset "Constructors of the Quaternions" begin
    # Constructors with all the components as arguments.
    q = Quaternion(1, 0, 0, 0)
    @test q.q0 == 1
    @test q.q1 == 0
    @test q.q2 == 0
    @test q.q3 == 0
    @test eltype(q) === Int

    q = Quaternion(1, 0, 0, 0.0)
    @test q.q0 == 1
    @test q.q1 == 0
    @test q.q2 == 0
    @test q.q3 == 0
    @test eltype(q) === promote_type(Int, typeof(0.0))

    # Constructors with one vector.
    q = Quaternion([0, 0, 0])
    @test q.q0 == 0
    @test q.q1 == 0
    @test q.q2 == 0
    @test q.q3 == 0
    @test eltype(q) === Int

    v = [0, cosd(60), sind(60)]
    q = Quaternion(v)
    @test q.q0 == 0
    @test q.q1 == 0
    @test q.q2 == cosd(60)
    @test q.q3 == sind(60)
    @test eltype(q) === eltype(v)

    v = [cosd(60), 0, sind(60), 0]
    q = Quaternion(v)
    @test q.q0 == cosd(60)
    @test q.q1 == 0
    @test q.q2 == sind(60)
    @test q.q3 == 0
    @test eltype(q) === eltype(v)

    # Constructores with one element and one vector.
    r = cosd(60)
    v = [0, sind(60), 0]
    q = Quaternion(r, v)
    @test q.q0 == cosd(60)
    @test q.q1 == 0
    @test q.q2 == sind(60)
    @test q.q3 == 0
    @test eltype(q) === promote_type(eltype(r), eltype(v))

    r = 0
    v = [0, sind(60), cosd(60)]
    q = Quaternion(r, v)
    @test q.q0 == 0
    @test q.q1 == 0
    @test q.q2 == sind(60)
    @test q.q3 == cosd(60)
    @test eltype(q) === promote_type(eltype(r), eltype(v))

    r = 0
    v = [0, 0, 1]
    q = Quaternion(r, v)
    @test q.q0 == 0
    @test q.q1 == 0
    @test q.q2 == 0
    @test q.q3 == 1
    @test eltype(q) === promote_type(eltype(r), eltype(v))

    # Constructors with the uniform scaling.
    q = Quaternion(I)
    @test q.q0 == 1
    @test q.q1 == 0
    @test q.q2 == 0
    @test q.q3 == 0
    @test eltype(q) === eltype(I)

    r = 1.0
    q = Quaternion(r * I)
    @test q.q0 == 1
    @test q.q1 == 0
    @test q.q2 == 0
    @test q.q3 == 0
    @test eltype(q) === eltype(r)

    q = Quaternion{Float32}(I)
    @test q.q0 == 1
    @test q.q1 == 0
    @test q.q2 == 0
    @test q.q3 == 0
    @test eltype(q) === Float32

    q1 = Quaternion{Float64}(I)
    q = Quaternion(I, q1)
    @test q.q0 == 1
    @test q.q1 == 0
    @test q.q2 == 0
    @test q.q3 == 0
    @test eltype(q) === eltype(q1)
end

@testset "Constructors of the Quaternions (Errors)" begin
    @test_throws ArgumentError Quaternion([1, 1])
    @test_throws ArgumentError Quaternion([1, 1, 2, 3, 4])
end
