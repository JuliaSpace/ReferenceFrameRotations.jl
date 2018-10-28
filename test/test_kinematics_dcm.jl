################################################################################
#                          TEST: Kinematics using DCM
################################################################################

for i = 1:samples
    # Create a random DCM.
    q      = Quaternion(randn(), randn(), randn(), randn())
    q      = q/norm(q)
    Dba0   = quat_to_dcm(q)

    # Create a random velocity vector.
    wba_a = randn(3)

    # Propagate the initial DCM using the sampled velocity vector.
    Δ   = 0.0001
    Dba = copy(Dba0)
    for k = 1:1000
        dDba = ddcm(Dba,Dba0*wba_a)

        Dba  = Dba + dDba*Δ
    end

    # In the end, the vector aligned with w must not change.
    v1 = Dba0*wba_a
    v2 = Dba*wba_a

    @test norm(v2-v1) < 1e-10
end
