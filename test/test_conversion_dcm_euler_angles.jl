################################################################################
#                          TEST: DCM <=> Euler Angles
################################################################################

for k = 1:samples
    # Nominal cases
    # --------------------------------------------------------------------------
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

    # Gimbal-lock and special cases
    # --------------------------------------------------------------------------

    # Rotation about the three axes
    # -----------------------------
    for rot_seq in [:ZYX, :ZXY, :YZX, :YXZ, :XZY, :XYZ]
        # A 90 deg rotation about the second axis yields a gimbal-lock.
        θ₁  = -π + 2π*rand()
        θ₃  = -π + 2π*rand()

        Dr1 = angle_to_dcm(θ₁, +π/2, θ₃, rot_seq)
        Dr2 = angle_to_dcm(θ₁, -π/2, θ₃, rot_seq)

        Θr1 = dcm_to_angle(Dr1, rot_seq)
        Θr2 = dcm_to_angle(Dr2, rot_seq)

        θs1, θs2 = (rot_seq in [:ZYX, :YXZ, :XZY]) ? (θ₁ - θ₃, θ₁ + θ₃) :
                                                     (θ₁ + θ₃, θ₁ - θ₃)

        # The angles must be between [-π,+π].
        θs1 = mod(θs1, 2π)
        θs2 = mod(θs2, 2π)

        (θs1 > π) && (θs1 -= 2π)
        (θs2 > π) && (θs2 -= 2π)

        @test Θr1.a1 ≈ θs1   atol = 1e-14
        @test Θr1.a2 ≈ +π/2  atol = 1e-14
        @test Θr1.a3 ≈ 0     atol = 1e-14

        @test Θr2.a1 ≈ θs2   atol = 1e-14
        @test Θr2.a2 ≈ -π/2  atol = 1e-14
        @test Θr2.a3 ≈ 0     atol = 1e-14
    end
    break

    # Rotation about two axes
    # -----------------------
    Rx = create_rotation_matrix(π, :X)
    Ry = create_rotation_matrix(π, :Y)
    Rz = create_rotation_matrix(π, :Z)
    α  = -pi + 2*pi*rand()

    # Two rotations about X
    D  = create_rotation_matrix(α, :X)
    Θ₁ = dcm_to_angle(D, :XYX)
    Θ₂ = dcm_to_angle(D, :XZX)
    @test Θ₁.a1 ≈ α
    @test Θ₁.a2 ≈ 0
    @test Θ₁.a3 ≈ 0
    @test Θ₂.a1 ≈ α
    @test Θ₂.a2 ≈ 0
    @test Θ₂.a3 ≈ 0

    Θ₁ = dcm_to_angle(D*Ry, :XYX)
    Θ₂ = dcm_to_angle(D*Rz, :XZX)
    @test Θ₁.a1 ≈ -α
    @test Θ₁.a2 ≈ π
    @test Θ₁.a3 ≈ 0
    @test Θ₂.a1 ≈ -α
    @test Θ₂.a2 ≈ π
    @test Θ₂.a3 ≈ 0

    # Two rotations about Y
    D  = create_rotation_matrix(α, :Y)
    Θ₁ = dcm_to_angle(D, :YXY)
    Θ₂ = dcm_to_angle(D, :YZY)
    @test Θ₁.a1 ≈ α
    @test Θ₁.a2 ≈ 0
    @test Θ₁.a3 ≈ 0
    @test Θ₂.a1 ≈ α
    @test Θ₂.a2 ≈ 0
    @test Θ₂.a3 ≈ 0

    Θ₁ = dcm_to_angle(D*Rx, :YXY)
    Θ₂ = dcm_to_angle(D*Rz, :YZY)
    @test Θ₁.a1 ≈ -α
    @test Θ₁.a2 ≈ π
    @test Θ₁.a3 ≈ 0
    @test Θ₂.a1 ≈ -α
    @test Θ₂.a2 ≈ π
    @test Θ₂.a3 ≈ 0

    # Two rotations about Z
    D  = create_rotation_matrix(α, :Z)
    Θ₁ = dcm_to_angle(D, :ZXZ)
    Θ₂ = dcm_to_angle(D, :ZYZ)
    @test Θ₁.a1 ≈ α
    @test Θ₁.a2 ≈ 0
    @test Θ₁.a3 ≈ 0
    @test Θ₂.a1 ≈ α
    @test Θ₂.a2 ≈ 0
    @test Θ₂.a3 ≈ 0

    Θ₁ = dcm_to_angle(D*Rx, :ZXZ)
    Θ₂ = dcm_to_angle(D*Ry, :ZYZ)
    @test Θ₁.a1 ≈ -α
    @test Θ₁.a2 ≈ π
    @test Θ₁.a3 ≈ 0
    @test Θ₂.a1 ≈ -α
    @test Θ₂.a2 ≈ π
    @test Θ₂.a3 ≈ 0
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
