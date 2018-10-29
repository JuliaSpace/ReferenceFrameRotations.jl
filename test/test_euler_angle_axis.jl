################################################################################
#                          TEST: Euler Angle and Axis
################################################################################

# Test constructions.
for k = 1:samples
    # Sample a random vector and angle.
    a = rand()
    v = rand(3)

    angleaxis = EulerAngleAxis(a,v)

    # Check if the representation was created correctly.
    @test angleaxis.a == a
    @test angleaxis.v == v

    # Test multiplication.
    a1  = -π + 2*π*rand()
    v1  = rand(3)
    v1 /= norm(v1)

    a2  = -π + 2*π*rand()
    v2  = rand(3)
    v2 /= norm(v2)

    ea1 = EulerAngleAxis(a1, v1)
    ea2 = EulerAngleAxis(a2, v2)
    ear = ea2*ea1

    q1  = angleaxis_to_quat(ea1)
    q2  = angleaxis_to_quat(ea2)
    qr  = q1*q2
    eaq = quat_to_angleaxis(qr)

    s = sign(ear.v[1])*sign(eaq.v[1])

    @test mod(ear.a, 2π)    ≈ mod(eaq.a, 2π)
    @test       ear.v[1]    ≈ s*eaq.v[1]
    @test       ear.v[2]    ≈ s*eaq.v[2]
    @test       ear.v[3]    ≈ s*eaq.v[3]
end

# Test types.
@test typeof(EulerAngleAxis(1, [1;1;1])) <: EulerAngleAxis{Int}
@test typeof(EulerAngleAxis(1.f0, Float32[1;1;1])) <: EulerAngleAxis{Float32}
@test typeof(EulerAngleAxis(1.f0, [1;1;1])) <: EulerAngleAxis{Float32}

# Test multiplication that leads to unitary rotation.
let
    ea1 = EulerAngleAxis(pi, [1.0,0.0,0.0])
    ear = ea1*ea1

    @test norm(ear.v) ≈ 0
    @test       ear.a ≈ 0
end

# Test `Float16` and `Float32` multiplications.
let
    v   = SVector{3,Float32}(1,0,0)
    a   = Float32(1)
    ea1 = EulerAngleAxis(a,v)
    ear = ea1*ea1

    @test eltype(ear.a) == eltype(ear.v) == Float32

    v   = SVector{3,Float16}(1,0,0)
    a   = Float16(1)
    ea1 = EulerAngleAxis(a,v)
    ear = ea1*ea1

    @test eltype(ear.a) == eltype(ear.v) == Float16
end

# Test exceptions.
@test_throws Exception EulerAngleAxis(randn(), [1;1;1;1])
@test_throws Exception EulerAngleAxis(randn(), [1;1])
@test_throws Exception EulerAngleAxis(randn(), SVector{4,Int}[1;1;1;1])
@test_throws Exception EulerAngleAxis(randn(), SVector{4,Float32}[1;1;1;1])
@test_throws Exception EulerAngleAxis(randn(), SVector{4,Float64}[1;1;1;1])
@test_throws Exception EulerAngleAxis(randn(), SVector{2,Int}[1;1])
@test_throws Exception EulerAngleAxis(randn(), SVector{2,Float32}[1;1])
@test_throws Exception EulerAngleAxis(randn(), SVector{2,Float64}[1;1])
