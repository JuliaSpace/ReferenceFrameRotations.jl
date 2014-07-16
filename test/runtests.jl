using Rotations
using Base.Test

# Available rotations.
rot_seq_array = ["XYX",
                 "XYZ",
                 "XZX",
                 "XZY",
                 "YXY",
                 "YXZ",
                 "YZX",
                 "YZY",
                 "ZXY",
                 "ZXZ",
                 "ZYX",
                 "ZYZ"]

for rot_seq in rot_seq_array
    # Sample three angles form a uniform distribution [-pi,pi].
    eulerang = EulerAngles(-pi + 2*pi*rand(),
                           -pi + 2*pi*rand(),
                           -pi + 2*pi*rand(),
                           rot_seq)

    # Get the error matrix related to the conversion from DCM => Euler Angles =>
    # DCM.
    error = angle2dcm(dcm2angle(angle2dcm(eulerang),rot_seq)) -
            angle2dcm(eulerang)

    # If everything is fine, the norm of the matrix error should be small.
    @test norm(error) < 10*eps()
end
