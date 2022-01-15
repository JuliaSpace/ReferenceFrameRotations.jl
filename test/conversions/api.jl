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

        # Quaternion
        # ======================================================================

        q = rand(Quaternion{T})
        av_exp = quat_to_angleaxis(q)
        av_api = convert(EulerAngleAxis, q)
        @test av_exp === av_api
        @test eltype(av_api) === T
    end
end

# Conversion to Euler angles
# ------------------------------------------------------------------------------

@testset "Julia conversion API: To Euler angles" begin
    for rot_seq in valid_rot_seqs
        for T in (Float32, Float64)
            # DCM
            # ==================================================================

            dcm = rand(DCM{T})
            ea_exp = dcm_to_angle(dcm, rot_seq)
            ea_api = convert(EulerAngles(rot_seq), dcm)
            @test ea_exp === ea_api
            @test eltype(ea_api) === T

            # Euler angle
            # ==================================================================

            ea = rand(EulerAngles{T})
            ea_exp = angle_to_angle(ea, rot_seq)
            ea_api = convert(EulerAngles(rot_seq), ea)
            @test ea_api === ea_exp
            @test eltype(ea_api) === T

            # Euler angle and axis
            # ==================================================================

            av = rand(EulerAngleAxis{T})
            ea_exp = angleaxis_to_angle(av, rot_seq)
            ea_api = convert(EulerAngles(rot_seq), av)
            @test ea_api === ea_exp
            @test eltype(ea_api) === T

            # Quaternion
            # ==================================================================

            q = rand(Quaternion{T})
            ea_exp = quat_to_angle(q, rot_seq)
            ea_api = convert(EulerAngles(rot_seq), q)
            @test ea_exp === ea_api
            @test eltype(ea_api) === T
        end
    end

    # Conversion without specifying the rotation sequence.
    for T in (Float32, Float64)
        # DCM
        # ======================================================================

        dcm = rand(DCM{T})
        ea_exp = dcm_to_angle(dcm, :ZYX)
        ea_api = convert(EulerAngles, dcm)
        @test ea_exp === ea_api
        @test eltype(ea_api) === T

        # Euler angle
        # ======================================================================

        ea = rand(EulerAngles{T})
        ea_api = convert(EulerAngles, ea)
        @test ea_api === ea
        @test eltype(ea_api) === T

        # In a previous version, there was a bug in which this code was changing
        # the rotation sequence to `:ZYX`.
        vea = EulerAngles[ea]
        @test vea[1] === ea

        # Euler angle and axis
        # ======================================================================

        # Sample a random Euler angle and axis.
        av = rand(EulerAngleAxis{T})
        ea_exp = angleaxis_to_angle(av, :ZYX)
        ea_api = convert(EulerAngles, av)
        @test ea_api === ea_exp
        @test eltype(ea_api) === T

        # Quaternion
        # ======================================================================

        q = rand(Quaternion{T})
        ea_exp = quat_to_angle(q)
        ea_api = convert(EulerAngles, q)
        @test ea_exp === ea_api
        @test eltype(ea_api) === T
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
