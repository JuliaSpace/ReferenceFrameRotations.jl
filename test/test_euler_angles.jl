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

# Test promotion
# ==============

@test EulerAngles(1,1,1.0,  :XYZ) === EulerAngles(1.0,1.0,1.0,:XYZ)
@test EulerAngles(1,1,1.0f0,:XYZ) === EulerAngles{Float32}(1,1,1,:XYZ)

# Test printing
# =============

# Color test is not working on AppVeyor. Hence, if the OS is windows, then we
# just skip.
if !Sys.iswindows()
    # With colors.
    expected = """
EulerAngles{Float64}:
\e[32;1m  R(X): \e[0m  1.5708 rad (  90.0000 deg)
\e[33;1m  R(Y): \e[0m  1.0472 rad (  60.0000 deg)
\e[34;1m  R(Z): \e[0m  0.7854 rad (  45.0000 deg)"""

    result = sprint((io,angles)->show(io, MIME"text/plain"(), angles),
                    EulerAngles(π/2, π/3, π/4, :XYZ),
                    context = :color => true)
    @test result == expected
end

# Without colors.
expected = """
EulerAngles{Float64}:
  R(X):   1.5708 rad (  90.0000 deg)
  R(Y):   1.0472 rad (  60.0000 deg)
  R(Z):   0.7854 rad (  45.0000 deg)"""

result = sprint((io,angles)->show(io, MIME"text/plain"(), angles),
                EulerAngles(π/2, π/3, π/4, :XYZ),
                context = :color => false)
@test result == expected

expected = """
EulerAngles{Float64}: R(XYZ):   1.5708   1.0472   0.7854 rad"""

result = sprint(print, EulerAngles(π/2, π/3, π/4, :XYZ))
@test result == expected
