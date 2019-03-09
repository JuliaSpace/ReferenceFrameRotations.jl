################################################################################
#                      TEST: DCM <=> Euler Angle and Axis
################################################################################

for k = 1:samples

    # Euler angle and axis => DCM
    # ==========================================================================

    # The test will use the conversion from DCM to Quaternions as the
    # ground-truth value, since it was extensively tested.
    v  = randn(3)
    v /= norm(v)
    θ  = -π + 2π*rand()

    ea = EulerAngleAxis(θ,v)
    q  = Quaternion( cos(θ/2), sin(θ/2)*v )
    D1 = quat_to_dcm(q)
    D2 = angleaxis_to_dcm(ea)

    @test norm(D1-D2) ≈ 0 atol = 1e-13

    # Test rotations along the Euler axis.
    r     = v*randn()
    r_rot = D2*r

    @test norm(r-r_rot) ≈ 0 atol = 1e-10

    # DCM => Euler angle and axis
    # ==========================================================================

    eac1 = dcm_to_angleaxis(D1)
    eac2 = dcm_to_angleaxis(D2)

    # Get the angle in the interval [0,π] with the corresponding vector.
    θ = mod(θ,2π)

    s = 1
    if θ > π
        s = -1
        θ = 2π - θ
    end

    @test    eac1.a ≈ θ      atol = 5e-7
    @test eac1.v[1] ≈ s*v[1] atol = 5e-7
    @test eac1.v[2] ≈ s*v[2] atol = 5e-7
    @test eac1.v[3] ≈ s*v[3] atol = 5e-7

    @test    eac2.a ≈ θ      atol = 5e-7
    @test eac2.v[1] ≈ s*v[1] atol = 5e-7
    @test eac2.v[2] ≈ s*v[2] atol = 5e-7
    @test eac2.v[3] ≈ s*v[3] atol = 5e-7
end

# Test special cases
# ==================

dcm_z = angle_to_dcm(π, 0, 0, :ZYX)
dcm_y = angle_to_dcm(0, π, 0, :ZYX)
dcm_x = angle_to_dcm(0, 0, π, :ZYX)

@test EulerAngleAxis(π, [0, 0, 1]) ≈ dcm_to_angleaxis(dcm_z)  atol = 1e-14
@test EulerAngleAxis(π, [0, 1, 0]) ≈ dcm_to_angleaxis(dcm_y)  atol = 1e-14
@test EulerAngleAxis(π, [1, 0, 0]) ≈ dcm_to_angleaxis(dcm_x)  atol = 1e-14
@test EulerAngleAxis(0, [0, 0, 0]) ≈ dcm_to_angleaxis(DCM(I)) atol = 1e-14
