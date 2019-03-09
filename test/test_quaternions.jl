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
    q = angle_to_quat(ang, 0.0, 0.0, :XYZ)

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
    q = angle_to_quat(ang, 0.0, 0.0, :YXZ)

    # Create a vector that does not have Y component.
    v = [randn();0;randn()]

    # Rotate the reference using the quaternion.
    v_r = vect(inv_rotation(q)*v*q)

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[2]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Test the same algorithm using different functions.
    v_r = imag(q\v*q)

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[2]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10


    # Z Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a quaternion that rotates about Z axis.
    q = angle_to_quat(ang, 0.0, 0.0, :ZXY)

    # Create a vector that does not have Z component.
    v = [randn();randn();0]

    # Rotate the reference using the quaternion.
    v_r = vect(inv_rotation(q)*v*q)

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[3]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Test the same algorithm using different functions.
    v_r = imag(I/q*v*q)

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
    @test eltype(q_eye_1.q0) != eltype(real(q))
    @test eltype(q_eye_2.q0) == eltype(real(q))
    @test eltype(q_eye_3.q0) == eltype(real(q))

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
    @test eltype(q_zeros_1.q0) != eltype(real(q))
    @test eltype(q_zeros_2.q0) == eltype(real(q))
    @test eltype(q_zeros_3.q0) == eltype(real(q))

    # Check if the value of the quaternion is correct.
    @test norm(q_zeros_3) == 0.0

    # Create quaternion from vectors
    # ------------------------------

    # Vector
    let
        v = rand(3)
        q = Quaternion(v)

        @test q.q0 == 0
        @test q.q1 == v[1]
        @test q.q2 == v[2]
        @test q.q3 == v[3]

        v = rand(4)
        q = Quaternion(v)

        @test q.q0 == v[1]
        @test q.q1 == v[2]
        @test q.q2 == v[3]
        @test q.q3 == v[4]
    end

    # SVector
    let
        v = @SVector rand(3)
        q = Quaternion(v)

        @test q.q0 == 0
        @test q.q1 == v[1]
        @test q.q2 == v[2]
        @test q.q3 == v[3]

        v = @SVector rand(4)
        q = Quaternion(v)

        @test q.q0 == v[1]
        @test q.q1 == v[2]
        @test q.q2 == v[3]
        @test q.q3 == v[4]
    end

    # MVector
    let
        v = @MVector rand(3)
        q = Quaternion(v)

        @test q.q0 == 0
        @test q.q1 == v[1]
        @test q.q2 == v[2]
        @test q.q3 == v[3]

        v = @MVector rand(4)
        q = Quaternion(v)

        @test q.q0 == v[1]
        @test q.q1 == v[2]
        @test q.q2 == v[3]
        @test q.q3 == v[4]
    end
end

# Operations that were not tested yet.
# ====================================

let
    q = Quaternion(1,1,1,1)
    @test typeof(q) == Quaternion{Int}

    q = Quaternion(1,1,1,1.f0)
    @test typeof(q) == Quaternion{Float32}

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
    @test (q/q)[:] ≈ [1;0;0;0]
    @test (q\q)[:] ≈ [1;0;0;0]

    # Uniform scaling.
    @test Quaternion(1,1,1,1) +    I === Quaternion{Int}(2,1,1,1)
    @test Quaternion(1,1,1,1) + 1.0I === Quaternion{Float64}(2,1,1,1)

    @test Quaternion(1,1,1,1) -    I === Quaternion{Int}(0,1,1,1)
    @test Quaternion(1,1,1,1) - 1.0I === Quaternion{Float64}(0,1,1,1)

    @test Quaternion(1,1,1,1)*I      === Quaternion{Int}(1,1,1,1)
    @test Quaternion(1,1,1,1)*1.0I   === Quaternion{Float64}(1,1,1,1)
    @test I*Quaternion(1,1,1,1)      === Quaternion{Int}(1,1,1,1)
    @test 1.0I*Quaternion(1,1,1,1)   === Quaternion{Float64}(1,1,1,1)

    @test Quaternion(1,1,1,1)/I      === Quaternion{Float64}(1,1,1,1)
    @test Quaternion(1,1,1,1)/1.0I   === Quaternion{Float64}(1,1,1,1)
    @test I/Quaternion(1,1,1,1)      === inv(Quaternion(1,1,1,1))
    @test 1.0I/Quaternion(1,1,1,1)   === inv(Quaternion(1,1,1,1))

    @test Quaternion(1,1,1,1)\I      === inv(Quaternion(1,1,1,1))
    @test Quaternion(1,1,1,1)\1.0I   === inv(Quaternion(1,1,1,1))
    @test I\Quaternion(1,1,1,1)      === Quaternion{Float64}(1,1,1,1)
    @test 1.0I\Quaternion(1,1,1,1)   === Quaternion{Float64}(1,1,1,1)

end

# Test printing
# =============

# Color test is not working on AppVeyor. Hence, if the OS is windows, then we
# just skip.
if !Sys.iswindows()
    # With colors.
    expected = """
Quaternion{Float64}:
  + 0.11111111 + 0.22222222.\e[1mi\e[0m + 0.33333333.\e[1mj\e[0m + 0.44444444.\e[1mk\e[0m"""

    result = sprint((io,quat)->show(io, MIME"text/plain"(), quat),
                    Quaternion(0.11111111,0.22222222,0.33333333,0.44444444);
                    context = :color => true)
    @test result == expected
end

# Without colors.
expected = """
Quaternion{Float64}:
  + 0.11111111 + 0.22222222.i + 0.33333333.j + 0.44444444.k"""

result = sprint((io,quat)->show(io, MIME"text/plain"(), quat),
                Quaternion(0.11111111,0.22222222,0.33333333,0.44444444);
                context = :color => false)
@test result == expected

# Inline.
expected = """
Quaternion{Float64}: + 0.11111111 + 0.22222222.i + 0.33333333.j + 0.44444444.k"""

result = sprint(print, Quaternion(0.11111111,0.22222222,0.33333333,0.44444444))
@test result == expected

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
