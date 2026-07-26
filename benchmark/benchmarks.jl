using BenchmarkTools
using ReferenceFrameRotations

function _compose_varargs(rotations)
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

    dcms = [angle_to_dcm(T(0.0007 * i), T(-0.0009 * i), T(0.0005 * i), :ZYX) for i in 1:128]
    collection_rotations = (
        DCM = dcms,
        EulerAngleAxis = [convert(EulerAngleAxis, D) for D in dcms],
        EulerAngles = [convert(EulerAngles(:ZYX), D) for D in dcms],
        Quaternion = [convert(Quaternion, D) for D in dcms],
        CRP = [convert(CRP, D) for D in dcms],
        MRP = [convert(MRP, D) for D in dcms],
    )

    for (representation, rotations) in pairs(collection_rotations)
        for n in (2, 8, 32, 33, 64, 128)
            vector = rotations[1:n]
            tuple = Tuple(vector)
            prefix = ("compose", representation, T, n)
            SUITE[prefix..., "varargs"] = @benchmarkable _compose_varargs($tuple)
            SUITE[prefix..., "tuple"] = @benchmarkable compose_rotation($tuple)
            SUITE[prefix..., "vector"] = @benchmarkable compose_rotation($vector)
        end
    end
end

SUITE
