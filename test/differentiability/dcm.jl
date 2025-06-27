## Description #############################################################################
#
# Test Functions for DCM Zygote Extension.
#
############################################################################################

@testset "Test DCM Zygote Differentiation" begin
    data = [
         0.9071183,
        -0.38511035,
         0.1697833,
        -0.18077055,
         0.0077917147,
         0.98349446,
        -0.38007677,
        -0.9228377,
        -0.06254859
    ]

    f, ad = value_and_jacobian(DCM, AutoZygote(), data)

    expected_f = DCM(data)
    expected_jac = I(9)

    @test f == expected_f
    @test ad == expected_jac

    data_tuple = (data...,)

    ad_jac = reduce(hcat, Zygote.jacobian(DCM, data_tuple...))

    @test ad_jac == expected_jac

    f_fd, df_fd = value_and_jacobian((x) -> orthonormalize(DCM(x)), AutoFiniteDiff(), data)
    f_ad, df_ad = value_and_jacobian((x) -> orthonormalize(DCM(x)), AutoZygote(), data)

    @test f_ad == f_fd
    @test df_ad ≈ df_fd rtol = 1e-7
end
