@testset "Performance contracts" begin
    for T in (Float32, Float64)
        dcm = angle_to_dcm(T(0.2), T(-0.3), T(0.4), :ZYX)
        perturbed = DCM(Tuple(dcm) .* (T(1) + T(0.001)))

        @test @inferred(orthonormalize(perturbed)) isa DCM{T}
        @test @inferred(dcm_to_angle(dcm, :ZYX)) isa EulerAngles{T}
        @test @inferred(dcm_to_quat(dcm)) isa Quaternion{T}
        @test @inferred(dcm_to_mrp(dcm)) isa MRP{T}
        @test @inferred(dcm_to_crp(dcm)) isa CRP{T}
        @test @inferred(convert(EulerAngles(:ZYX), dcm)) isa EulerAngles{T}

        rotations2 = (dcm, dcm)
        rotations8 = ntuple(_ -> dcm, 8)
        rotations32 = ntuple(_ -> dcm, 32)
        for rotations in (rotations2, rotations8, rotations32)
            @test @inferred(compose_rotation(rotations...)) isa DCM{T}
        end

        # Warm each call before measuring so compilation is not part of the contract.
        orthonormalize(perturbed)
        dcm_to_angle(dcm, :ZYX)
        dcm_to_quat(dcm)
        dcm_to_mrp(dcm)
        dcm_to_crp(dcm)
        convert(EulerAngles(:ZYX), dcm)
        for rotations in (rotations2, rotations8, rotations32)
            compose_rotation(rotations...)
        end

        @test @allocated(orthonormalize(perturbed)) == 0
        @test @allocated(dcm_to_angle(dcm, :ZYX)) == 0
        @test @allocated(dcm_to_quat(dcm)) == 0
        @test @allocated(dcm_to_mrp(dcm)) == 0
        @test @allocated(dcm_to_crp(dcm)) == 0
        @test @allocated(convert(EulerAngles(:ZYX), dcm)) == 0
    end
end
