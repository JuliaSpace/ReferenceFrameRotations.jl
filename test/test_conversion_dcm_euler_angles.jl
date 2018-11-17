################################################################################
#                          TEST: DCM <=> Euler Angles
################################################################################

for k = 1:samples
    for rot_seq in rot_seq_array
        # Sample three angles form a uniform distribution [-pi,pi].
        θx = -pi + 2*pi*rand()
        θy = -pi + 2*pi*rand()
        θz = -pi + 2*pi*rand()
        Θ  = EulerAngles(θx, θy, θz, rot_seq)

        # Get the error matrix related to the conversion from DCM => Euler
        # Angles => DCM.
        error1 = angle_to_rot(DCM, dcm_to_angle(angle_to_rot(Θ),rot_seq)) -
                 angle_to_rot(DCM, θx, θy, θz, rot_seq)
        error2 = angle_to_rot(dcm_to_angle(angle_to_rot(θx, θy, θz, rot_seq),rot_seq)) -
                 angle_to_rot(Θ)

        # If everything is fine, the norm of the matrix error should be small.
        @test norm(error1) < 1e-10
        @test norm(error2) < 1e-10
        @test error1 ≈ error2
    end

    # Check situations with singularities.
    Rx = create_rotation_matrix(π, :X)
    Ry = create_rotation_matrix(π, :Y)
    Rz = create_rotation_matrix(π, :Z)
    α  = -pi + 2*pi*rand()

    D  = create_rotation_matrix(α, :X)
    Θ₁ = dcm_to_angle(D, :XYX)
    Θ₂ = dcm_to_angle(D, :XZX)
    @test Θ₁.a1 ≈ α
    @test Θ₂.a1 ≈ α
    Θ₁ = dcm_to_angle(D*Ry, :XYX)
    Θ₂ = dcm_to_angle(D*Rz, :XZX)
    @test Θ₁.a1 ≈ -α
    @test Θ₁.a2 ≈ π
    @test Θ₂.a1 ≈ -α
    @test Θ₂.a2 ≈ π

    D  = create_rotation_matrix(α, :Y)
    Θ₁ = dcm_to_angle(D, :YXY)
    Θ₂ = dcm_to_angle(D, :YZY)
    @test Θ₁.a1 ≈ α
    @test Θ₂.a1 ≈ α
    Θ₁ = dcm_to_angle(D*Rx, :YXY)
    Θ₂ = dcm_to_angle(D*Rz, :YZY)
    @test Θ₁.a1 ≈ -α
    @test Θ₁.a2 ≈ π
    @test Θ₂.a1 ≈ -α
    @test Θ₂.a2 ≈ π

    D  = create_rotation_matrix(α, :Z)
    Θ₁ = dcm_to_angle(D, :ZXZ)
    Θ₂ = dcm_to_angle(D, :ZYZ)
    @test Θ₁.a1 ≈ α
    @test Θ₂.a1 ≈ α
    Θ₁ = dcm_to_angle(D*Rx, :ZXZ)
    Θ₂ = dcm_to_angle(D*Ry, :ZYZ)
    @test Θ₁.a1 ≈ -α
    @test Θ₁.a2 ≈ π
    @test Θ₂.a1 ≈ -α
    @test Θ₂.a2 ≈ π
end

for k = 1:samples
    # Sample three angles form a uniform distribution [-0.0001,0.0001].
    θx = -0.0001 + 0.0002*pi*rand()
    θy = -0.0001 + 0.0002*pi*rand()
    θz = -0.0001 + 0.0002*pi*rand()
    Θ  = EulerAngles(θx, θy, θz, :XYZ)

    # Get the error between the exact rotation and the small angle
    # approximation.
    error1 = angle_to_rot(Θ) - smallangle_to_rot(DCM, Θ.a1, Θ.a2, Θ.a3)
    error2 = angle_to_rot(θx, θy, θz, :XYZ) - smallangle_to_rot(Θ.a1, Θ.a2, Θ.a3)

    # If everything is fine, the norm of the matrix error should be small.
    @test norm(error1) < 1e-9
    @test norm(error2) < 1e-9
    @test error1 ≈ error2
end

# Test orthonormalization.
let
    θx = -0.01 + 0.02*pi*rand()
    θy = -0.01 + 0.02*pi*rand()
    θz = -0.01 + 0.02*pi*rand()

    D1 = smallangle_to_rot(θx, θy, θz)
    D2 = smallangle_to_rot(θx, θy, θz; normalize = false)

    @test norm(I - D1*D1') ≈    0 atol = 1e-15
    @test norm(I - D2*D2') > 1e-7
end

# Test exceptions.
@test_throws ArgumentError angle_to_dcm(0,0,0,:xyz)
@test_throws ArgumentError angle_to_dcm(0,0,0,:zyx)
@test_throws ArgumentError angle_to_dcm(0,0,0,:xyx)
@test_throws ArgumentError angle_to_dcm(0,0,0,:abc)
@test_throws ArgumentError angle_to_quat(0,0,0,:xyz)
@test_throws ArgumentError angle_to_quat(0,0,0,:zyx)
@test_throws ArgumentError angle_to_quat(0,0,0,:xyx)
@test_throws ArgumentError angle_to_quat(0,0,0,:abc)
