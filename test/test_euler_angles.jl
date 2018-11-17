################################################################################
#                              TEST: Euler Angles
################################################################################

for k = 1:samples
    for rot_seq in rot_seq_array
        # Sample three angles form a uniform distribution [-pi,pi].
        θx = -pi + 2*pi*rand()
        θy = -pi + 2*pi*rand()
        θz = -pi + 2*pi*rand()
        Θ  = EulerAngles(θx, θy, θz, rot_seq)

        δΘ₁ = Θ*inv_rotation(Θ)
        δΘ₂ = inv_rotation(Θ)*Θ

        # Check if the rotation is identity.
        q₁ = angle_to_quat(δΘ₁)
        q₂ = angle_to_quat(δΘ₂)

        @test q₁.q0 ≈ 1 atol=1e-7
        @test q₁.q1 ≈ 0 atol=1e-7
        @test q₁.q2 ≈ 0 atol=1e-7
        @test q₁.q3 ≈ 0 atol=1e-7

        @test q₂.q0 ≈ 1 atol=1e-7
        @test q₂.q1 ≈ 0 atol=1e-7
        @test q₂.q2 ≈ 0 atol=1e-7
        @test q₂.q3 ≈ 0 atol=1e-7

        @test δΘ₁.rot_seq == rot_seq
        @test δΘ₂.rot_seq == Symbol(reverse(String(rot_seq)))
    end
end
