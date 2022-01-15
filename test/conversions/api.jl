# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to the Julia API to convert between the representations.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/conversions/api.jl
# ==============================

# Conversion to DCM
# ------------------------------------------------------------------------------

@testset "Julia conversion API: To DCM" begin
    for T in (Float32, Float64)
        T = Float64

        # Euler angles
        # ======================================================================

        ea = rand(EulerAngles{T})
        D_exp = angle_to_dcm(ea)
        D_api = convert(DCM, ea)
        @test D_api === D_exp
        @test eltype(D_api) === T

        # Euler angle and axis
        # ======================================================================

        av = rand(EulerAngleAxis{T})
        D_exp = angleaxis_to_dcm(av)
        D_api = convert(DCM, av)
        @test D_api === D_exp
        @test eltype(D_api) === T

        # Quaternion
        # ======================================================================

        q = rand(Quaternion{T})
        D_exp = quat_to_dcm(q)
        D_api = convert(DCM, q)
        @test D_api === D_exp
        @test eltype(D_api) === T
    end
end

# Conversion to Euler angle and axis
# ------------------------------------------------------------------------------

@testset "Julia conversion API: To Euler angle and axis" begin
    for T in (Float32, Float64)
        # DCMs
        # ======================================================================

        dcm = rand(DCM{T})
        av_exp = dcm_to_angleaxis(dcm)
        av_api = convert(EulerAngleAxis, dcm)
        @test av_exp === av_api
        @test eltype(av_api) === T

        # Euler angles
        # ======================================================================

        ea = rand(EulerAngles{T})
        av_exp = angle_to_angleaxis(ea)
        av_api = convert(EulerAngleAxis, ea)
        @test av_exp === av_api
        @test eltype(av_api) === T

        # Quaternions
        # ======================================================================

        q = rand(Quaternion{T})
        av_exp = quat_to_angleaxis(q)
        av_api = convert(EulerAngleAxis, q)
        @test av_exp === av_api
        @test eltype(av_api) === T
    end
end

# Conversion to quaternion
# ------------------------------------------------------------------------------

@testset "Julia conversion API: To Quaternion" begin
    for T in (Float32, Float64)
        # Euler angles
        # ======================================================================

        ea = rand(EulerAngles{T})
        q_exp = angle_to_quat(ea)
        q_api = convert(Quaternion, ea)
        @test q_api === q_exp
        @test eltype(q_api) === T

        # Euler angle and axis
        # ======================================================================

        # Sample a random Euler angle and axis.
        av = rand(EulerAngleAxis{T})
        q_exp = angleaxis_to_quat(av)
        q_api = convert(Quaternion, av)
        @test q_api === q_exp
        @test eltype(q_api) === T

        # DCM
        # ======================================================================

        D = rand(DCM{T})
        q_exp = dcm_to_quat(D)
        q_api = convert(Quaternion, D)
        @test q_api === q_exp
        @test eltype(q_api) === T
    end
end
