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

@testset "MRP Conversions" begin
    # Helper to compare DCMs
    function isapprox_dcm(d1, d2; atol = 1e-12)
        return maximum(abs.(d1 - d2)) < atol
    end

    # Random rotation
    eul = EulerAngles(1.0, 0.5, -0.2, :ZYX)
    dcm = angle_to_dcm(eul)
    q = angle_to_quat(eul)

    # DCM -> MRP
    m = dcm_to_mrp(dcm)
    
    # MRP -> DCM
    dcm_m = mrp_to_dcm(m)
    @test isapprox_dcm(dcm, dcm_m)

    # MRP -> Quaternion
    q_m = mrp_to_quat(m)
    # Signs of quaternions can be flipped, so check if they Are approximately equal or opposite
    @test isapprox(q, q_m; atol=1e-12) || isapprox(q, -q_m; atol=1e-12)

    # Quaternion -> MRP
    m_q = quat_to_mrp(q)
    @test isapprox(m, m_q; atol=1e-12)

    # MRP -> EulerAngles
    ang_m = mrp_to_angle(m, :ZYX)
    @test isapprox(ang_m.a1, eul.a1; atol=1e-12)
    @test isapprox(ang_m.a2, eul.a2; atol=1e-12)
    @test isapprox(ang_m.a3, eul.a3; atol=1e-12)

    # MRP -> EulerAngleAxis
    eaa_m = mrp_to_angleaxis(m)
    eaa = angle_to_angleaxis(eul)
    @test isapprox(eaa_m.a, eaa.a; atol=1e-12)
    @test isapprox(eaa_m.v, eaa.v; atol=1e-12)

    # 360 degree rotation singularity check (MRP singular at 360)
    q_360 = Quaternion(-1.0, 0.0, 0.0, 0.0) # 360 deg is q0 = -1 (since angle is 2*acos(q0), q0=-1 => angle=360)
    @test_throws ArgumentError quat_to_mrp(q_360)
end

@testset "MRP Composition" begin
    # m3 = m2 * m1
    
    eul1 = EulerAngles(0.3, 0.2, 0.1, :ZYX)
    eul2 = EulerAngles(-0.2, 0.4, -0.3, :ZYX)
    
    m1 = dcm_to_mrp(angle_to_dcm(eul1))
    m2 = dcm_to_mrp(angle_to_dcm(eul2))

    m3 = m2 * m1
    
    # Verify with DCM
    dcm1 = angle_to_dcm(eul1)
    dcm2 = angle_to_dcm(eul2)
    dcm3 = dcm2 * dcm1

    dcm_m3 = mrp_to_dcm(m3)
    @test maximum(abs.(dcm3 - dcm_m3)) < 1e-12

    # Verify compose_rotation
    m_comp = compose_rotation(m1, m2) # Apply m1 then m2
    @test isapprox(m_comp, m3; atol=1e-12)
end

@testset "MRP Arithmetic" begin
    m1 = MRP(0.1, 0.2, 0.3)
    m2 = MRP(0.05, -0.05, 0.1)
    
    # +
    m3 = m1 + m2
    @test isapprox(m3.q1, 0.15; atol=1e-12)
    @test isapprox(m3.q2, 0.15; atol=1e-12)
    @test isapprox(m3.q3, 0.4; atol=1e-12)
    
    # - (binary)
    m4 = m1 - m2
    @test isapprox(m4.q1, 0.05; atol=1e-12)
    @test isapprox(m4.q2, 0.25; atol=1e-12)
    @test isapprox(m4.q3, 0.2; atol=1e-12)
    
    # - (unary)
    m_neg = -m1
    @test m_neg.q1 == -0.1
    @test m_neg.q2 == -0.2
    @test m_neg.q3 == -0.3
    
    # * (scalar)
    m_scaled = 2.0 * m1
    @test m_scaled.q1 == 0.2
    @test m_scaled.q2 == 0.4
    @test m_scaled.q3 == 0.6
    
    m_scaled2 = m1 * 2.0
    @test m_scaled2 == m_scaled
    
    # / (scalar)
    m_div = m1 / 2.0
    @test m_div.q1 == 0.05
    @test m_div.q2 == 0.1
    @test m_div.q3 == 0.15
end

@testset "MRP Inverse and Division" begin
    m1 = MRP(0.1, 0.2, 0.3)
    m2 = MRP(0.05, -0.05, 0.1)
    
    # inv
    m_inv = inv(m1)
    # The inverse of a MRP q is -q
    @test m_inv == -m1
    
    # Identity
    # m * inv(m) should be identity (0, 0, 0)
    m_identity = m1 * m_inv
    @test isapprox(m_identity.q1, 0.0; atol=1e-12)
    @test isapprox(m_identity.q2, 0.0; atol=1e-12)
    @test isapprox(m_identity.q3, 0.0; atol=1e-12)
    
    # / (m1 / m2 = m1 * inv(m2))
    m_div = m1 / m2
    m_mult = m1 * inv(m2)
    @test isapprox(m_div, m_mult)
    
    # \ (m1 \ m2 = inv(m1) * m2)
    m_backdiv = m1 \ m2
    m_mult_back = inv(m1) * m2
    @test isapprox(m_backdiv, m_mult_back)
end

@testset "MRP Utils" begin
    # 3-4-5 triangle? no, just simple numbers
    m = MRP(3.0, 0.0, 4.0)
    @test norm(m) == 5.0
    
    @test one(MRP) == MRP(0.0, 0.0, 0.0)
    @test one(m) == MRP(0.0, 0.0, 0.0)
    
    @test zero(MRP) == MRP(0.0, 0.0, 0.0)
    @test zero(m) == MRP(0.0, 0.0, 0.0)
    
    # copy
    m_copy = copy(m)
    @test m_copy == m
    
    # vect
    v = vect(m)
    @test v isa SVector{3, Float64}
    @test v[1] == m.q1
    @test v[2] == m.q2
    @test v[3] == m.q3
    
    # UniformScaling
    @test I * m == m
    @test m * I == m
    @test I / m == inv(m)
    @test m / I == m
    @test I \ m == m
    @test m \ I == inv(m)
end

@testset "MRP Shadow Rotation" begin
    m = MRP(0.1, 0.2, 0.3)
    m_shadow = shadow_rotation(m)
    
    # Check if the shadow rotation is indeed the shadow
    @test norm(m_shadow) > 1.0
    @test isapprox(norm(m_shadow), 1/norm(m); atol=1e-12)
    
    # Check if they represent the same rotation
    dcm = mrp_to_dcm(m)
    dcm_shadow = mrp_to_dcm(m_shadow)
    
    @test maximum(abs.(dcm - dcm_shadow)) < 1e-12
end

@testset "MRP Random" begin
    Random.seed!(123)
    m = rand(MRP)
    @test m isa MRP{Float64}
    
    m_float32 = rand(MRP{Float32})
    @test m_float32 isa MRP{Float32}
end

@testset "MRP Kinematics" begin
    # Test analytical derivative against numerical derivative
    for T in (Float64,)
        # We need a seed to ensure reproducibility
        Random.seed!(123)
        
        m = rand(MRP{T})
        w = @SVector randn(T, 3)
        
        dm = dmrp(m, w)
        
        dt = 1e-8
        
        # Use DCM mapping for propagation to avoid circular dependency if we were to use dmrp for integration,
        # but here we want to verify dmrp.
        D = mrp_to_dcm(m)
        
        # In the existing tests (kinematics.jl), they use:
        # dDba = ddcm(Dba, Dba * wba_a)
        # Dba  = Dba + dDba * Δ
        # Dba  = orthonormalize(Dba)
        
        dD = ddcm(D, w) # w is in body frame? Make sure. ddcm says wba_b. dmrp says wba_b. Matches.
        D_next = D + dD * dt
        D_next = orthonormalize(D_next)
        
        m_next = dcm_to_mrp(D_next)
        
        # Check if we switched to the shadow set (norm > 1 or just large jump)
        # If m_next is far from m, try shadow
        if norm(m_next - m) > 0.1
             m_next = shadow_rotation(m_next)
        end
        
        dm_num = (m_next - m) / dt
        
        # Check alignment
        @test isapprox(dm, dm_num[:]; rtol = 1e-4, atol=1e-6)
    end
end




