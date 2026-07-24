using BenchmarkTools
using ReferenceFrameRotations

function _compose(rotations)
    return compose_rotation(rotations...)
end

const SUITE = BenchmarkGroup()

for T in (Float32, Float64)
    dcm = angle_to_dcm(T(0.2), T(-0.3), T(0.4), :ZYX)
    dcm_perturbed = DCM(Tuple(dcm) .* (T(1) + T(0.001)))

    SUITE["orthonormalize", T] = @benchmarkable orthonormalize($dcm_perturbed)
    SUITE["DCM to Euler", T] = @benchmarkable dcm_to_angle($dcm, :ZYX)
    SUITE["DCM to quaternion", T] = @benchmarkable dcm_to_quat($dcm)
    SUITE["DCM to MRP", T] = @benchmarkable dcm_to_mrp($dcm)
    SUITE["DCM to CRP", T] = @benchmarkable dcm_to_crp($dcm)
    SUITE["fixed-sequence convert", T] = @benchmarkable convert(EulerAngles(:ZYX), $dcm)

    for n in (2, 8, 32)
        rotations = ntuple(_ -> dcm, n)
        SUITE["compose", T, n] = @benchmarkable _compose($rotations)
    end
end

SUITE
