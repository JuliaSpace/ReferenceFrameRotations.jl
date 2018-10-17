################################################################################
#                      TEST: Kinematics using Quaternion
################################################################################

for i = 1:samples
    # Create a random quaternion.
    qba0 = Quaternion(randn(), randn(), randn(), randn())
    qba0 = qba0/norm(qba0)

    # Create a random velocity vector.
    wba_a = randn(3)

    # Propagate the initial DCM using the sampled velocity vector.
    Δ   = 0.0001
    qba = copy(qba0)
    for k = 1:1000
        dqba = dquat(qba,vect(qba\wba_a*qba))

        qba  = qba + dqba*Δ
    end

    # In the end, the vector aligned with w must not change.
    v1 = vect(qba0\wba_a*qba0)
    v2 = vect( qba\wba_a*qba)

    @test norm(v2-v1) < 1e-10
end
