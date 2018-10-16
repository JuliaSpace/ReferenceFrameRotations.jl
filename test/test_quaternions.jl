################################################################################
#                              TEST: Quaternions
################################################################################

for i = 1:samples
    # Rotations
    # =========

    # X Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a quaternion that rotates about X axis.
    q = angle2quat(ang, 0.0, 0.0, :XYZ)

    # Create a vector that does not have X component.
    v = [0;randn();randn()]

    # Rotate the reference using the quaternion.
    v_r = vect(inv_rotation(q)*v*q)

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[1]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Test the same algorithm using different functions.
    v_r = imag((1/q)*(v*q))

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[1]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Y Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a quaternion that rotates about Y axis.
    q = angle2quat(ang, 0.0, 0.0, :YXZ)

    # Create a vector that does not have Y component.
    v = [randn();0;randn()]

    # Rotate the reference using the quaternion.
    v_r = vect(inv_rotation(q)*v*q)

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[2]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Test the same algorithm using different functions.
    v_r = imag((1/q)*(v*q))

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[2]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10


    # Z Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a quaternion that rotates about Z axis.
    q = angle2quat(ang, 0.0, 0.0, :ZXY)

    # Create a vector that does not have Z component.
    v = [randn();randn();0]

    # Rotate the reference using the quaternion.
    v_r = vect(inv_rotation(q)*v*q)

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[3]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Test the same algorithm using different functions.
    v_r = imag((1/q)*(v*q))

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[3]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10


    # Other functions
    # ===============

    # eye
    # ---

    # Create a random quaternion with Float32 type.
    q = Quaternion{Float32}(randn(), randn(), randn(), randn())
    q = q/norm(q)

    # Creata an identity quaternion using many methods.
    q_eye_1 = Quaternion{Float64}(I)
    q_eye_2 = Quaternion(1.f0I)
    q_eye_3 = Quaternion(I,q)

    # Check if the types are correct.
    @test eltype(q_eye_1.q0) != eltype(q.q0)
    @test eltype(q_eye_2.q0) == eltype(q.q0)
    @test eltype(q_eye_3.q0) == eltype(q.q0)

    # Check if the value of the quaternion is correct.
    @test norm(vect(q_eye_3)) == 0.0
    @test real(q_eye_3) == 1.0

    # zeros
    # -----

    # Create a random quaternion with Float32 type.
    q = Quaternion{Float32}(randn(), randn(), randn(), randn())
    q = q/norm(q)

    # Creata a zero quaternion using many methods.
    q_zeros_1 = zeros(Quaternion)
    q_zeros_2 = zeros(Quaternion{Float32})
    q_zeros_3 = zeros(q)

    # Check if the types are correct.
    @test eltype(q_zeros_1.q0) != eltype(q.q0)
    @test eltype(q_zeros_2.q0) == eltype(q.q0)
    @test eltype(q_zeros_3.q0) == eltype(q.q0)

    # Check if the value of the quaternion is correct.
    @test norm(q_zeros_3) == 0.0

end

# Operations that were not tested yet.
# ====================================

let
    q = Quaternion(1.,0,0.f0,0)
    @test typeof(q) == Quaternion{Float64}

    q = Quaternion(SVector{3}(1.,2.,3.))
    @test q.q0 == 0
    @test q.q1 == 1
    @test q.q2 == 2
    @test q.q3 == 3

    q = Quaternion(SVector{4}(1.,2.,3.,4.))
    @test q.q0 == 1
    @test q.q1 == 2
    @test q.q2 == 3
    @test q.q3 == 4

    q = 3*q
    @test q.q0 == 3
    @test q.q1 == 6
    @test q.q2 == 9
    @test q.q3 == 12

    qc = conj(q)
    @test qc.q0 == +3
    @test qc.q1 == -6
    @test qc.q2 == -9
    @test qc.q3 == -12

    q = Quaternion(1.0,1.0,1.0,1.0)
    @test inv_rotation(q) != inv(q)
    @test (q*inv(q))[:] ≈ [1;0;0;0]
end

# Test exceptions
# ===============

@test_throws ArgumentError Quaternion([1])
@test_throws ArgumentError Quaternion([1;2])
@test_throws ArgumentError Quaternion([1;2;3;4;5])
@test_throws ArgumentError Quaternion([1;2;3;4;5;6])
@test_throws ArgumentError dquat(Quaternion(I), [1])
@test_throws ArgumentError dquat(Quaternion(I), [1;2])
@test_throws ArgumentError dquat(Quaternion(I), [1;2;3;4])
@test_throws ArgumentError dquat(Quaternion(I), [1;2;3;4;5])
