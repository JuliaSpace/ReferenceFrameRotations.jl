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

@testset "CRP Conversions" begin
    # Helper to compare DCMs
    function isapprox_dcm(d1, d2; atol = 1e-12)
        return maximum(abs.(d1 - d2)) < atol
    end

    # Random rotation
    eul = EulerAngles(1.0, 0.5, -0.2, :ZYX)
    dcm = angle_to_dcm(eul)
    q = angle_to_quat(eul)

    # DCM -> Quaternion -> CRP
    c = dcm_to_crp(dcm)
    
    # CRP -> DCM
    dcm_c = crp_to_dcm(c)
    @test isapprox_dcm(dcm, dcm_c)

    # CRP -> Quaternion
    q_c = crp_to_quat(c)
    # Signs of quaternions can be flipped, so check if they Are approximately equal or opposite
    @test isapprox(q, q_c; atol=1e-12) || isapprox(q, -q_c; atol=1e-12)

    # Quaternion -> CRP
    c_q = quat_to_crp(q)
    @test isapprox(c, c_q; atol=1e-12)

    # CRP -> EulerAngles
    ang_c = crp_to_angle(c, :ZYX)
    @test isapprox(ang_c.a1, eul.a1; atol=1e-12)
    @test isapprox(ang_c.a2, eul.a2; atol=1e-12)
    @test isapprox(ang_c.a3, eul.a3; atol=1e-12)

    # CRP -> EulerAngleAxis
    eaa_c = crp_to_angleaxis(c)
    eaa = angle_to_angleaxis(eul)
    @test isapprox(eaa_c.a, eaa.a; atol=1e-12)
    @test isapprox(eaa_c.v, eaa.v; atol=1e-12)

    # 180 degree rotation singularity check
    q_180 = Quaternion(0.0, 1.0, 0.0, 0.0) # 180 deg about X
    @test_throws ArgumentError quat_to_crp(q_180)
end

@testset "CRP Composition" begin
    # c3 = c2 * c1 (apply c1 then c2) -> R3 = R2 * R1
    
    eul1 = EulerAngles(0.3, 0.2, 0.1, :ZYX)
    eul2 = EulerAngles(-0.2, 0.4, -0.3, :ZYX)
    
    c1 = dcm_to_crp(angle_to_dcm(eul1))
    c2 = dcm_to_crp(angle_to_dcm(eul2))

    c3 = c2 * c1
    
    # Verify with DCM
    dcm1 = angle_to_dcm(eul1)
    dcm2 = angle_to_dcm(eul2)
    dcm3 = dcm2 * dcm1

    dcm_c3 = crp_to_dcm(c3)
    @test maximum(abs.(dcm3 - dcm_c3)) < 1e-12

    # Verify compose_rotation
    c_comp = compose_rotation(c1, c2) # Apply c1 then c2
    @test isapprox(c_comp, c3; atol=1e-12)
end

@testset "CRP Arithmetic" begin
    c1 = CRP(1.0, 2.0, 3.0)
    c2 = CRP(0.5, -0.5, 1.0)
    
    # +
    c3 = c1 + c2
    @test isapprox(c3.q1, 1.5; atol=1e-12)
    @test isapprox(c3.q2, 1.5; atol=1e-12)
    @test isapprox(c3.q3, 4.0; atol=1e-12)
    
    # - (binary)
    c4 = c1 - c2
    @test c4.q1 == 0.5
    @test c4.q2 == 2.5
    @test c4.q3 == 2.0
    
    # - (unary)
    c_neg = -c1
    @test c_neg.q1 == -1.0
    @test c_neg.q2 == -2.0
    @test c_neg.q3 == -3.0
    
    # * (scalar)
    c_scaled = 2.0 * c1
    @test c_scaled.q1 == 2.0
    @test c_scaled.q2 == 4.0
    @test c_scaled.q3 == 6.0
    
    c_scaled2 = c1 * 2.0
    @test c_scaled2 == c_scaled
    
    # / (scalar)
    c_div = c1 / 2.0
    @test c_div.q1 == 0.5
    @test c_div.q2 == 1.0
    @test c_div.q3 == 1.5
end

@testset "CRP Inverse and Division" begin
    c1 = CRP(1.0, 2.0, 3.0)
    c2 = CRP(0.5, -0.5, 1.0)
    
    # inv
    c_inv = inv(c1)
    # The inverse of a CRP q is -q
    @test c_inv == -c1
    
    # Identity
    # c * inv(c) should be identity (0, 0, 0)
    c_identity = c1 * c_inv
    @test isapprox(c_identity.q1, 0.0; atol=1e-12)
    @test isapprox(c_identity.q2, 0.0; atol=1e-12)
    @test isapprox(c_identity.q3, 0.0; atol=1e-12)
    
    # / (c1 / c2 = c1 * inv(c2))
    c_div = c1 / c2
    c_mult = c1 * inv(c2)
    @test isapprox(c_div, c_mult)
    
    # \ (c1 \ c2 = inv(c1) * c2)
    c_backdiv = c1 \ c2
    c_mult_back = inv(c1) * c2
    @test isapprox(c_backdiv, c_mult_back)
end

@testset "CRP Utils" begin
    c = CRP(3.0, 0.0, 4.0)
    @test norm(c) == 5.0
    
    @test one(CRP) == CRP(0.0, 0.0, 0.0)
    @test one(c) == CRP(0.0, 0.0, 0.0)
    
    @test zero(CRP) == CRP(0.0, 0.0, 0.0)
    @test zero(c) == CRP(0.0, 0.0, 0.0)
end

@testset "CRP Random" begin
    Random.seed!(123)
    c = rand(CRP)
    @test c isa CRP{Float64}
    
    c_float32 = rand(CRP{Float32})
    @test c_float32 isa CRP{Float32}
end
