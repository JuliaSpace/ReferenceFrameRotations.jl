## Desription ##############################################################################
#
# Tests related to the Julia API to convert between the representations.
#
############################################################################################

# == File: ./src/conversions/api.jl ========================================================

# -- Conversion to DCM ---------------------------------------------------------------------

@testset "Julia Conversion API: To DCM" begin
    for T in (Float32, Float64)
        # == Euler Angles ==================================================================

        ea = rand(EulerAngles{T})
        D_exp = angle_to_dcm(ea)
        D_api = convert(DCM, ea)
        @test D_api === D_exp
        @test eltype(D_api) === T

        # == Euler Angle and Axis ==========================================================

        av = rand(EulerAngleAxis{T})
        D_exp = angleaxis_to_dcm(av)
        D_api = convert(DCM, av)
        @test D_api === D_exp
        @test eltype(D_api) === T

        # == Quaternion ====================================================================

        q = rand(Quaternion{T})
        D_exp = quat_to_dcm(q)
        D_api = convert(DCM, q)
        @test D_api === D_exp
        @test eltype(D_api) === T

        # == Classical Rodrigues Parameters (CRP) ==========================================

        c = rand(CRP{T})
        D_exp = crp_to_dcm(c)
        D_api = convert(DCM, c)
        @test D_api === D_exp
        @test eltype(D_api) === T

        # == Modified Rodrigues Parameters (MRP) ===========================================

        m = rand(MRP{T})
        D_exp = mrp_to_dcm(m)
        D_api = convert(DCM, m)
        @test D_api === D_exp
        @test eltype(D_api) === T
    end
end

# -- Concrete conversion targets -----------------------------------------------------------

@testset "Julia conversion API: Concrete targets" begin
    representation_types = (DCM, EulerAngles, EulerAngleAxis, Quaternion, CRP, MRP)

    for source_T in (Float32, Float64)
        sources = (
            rand(DCM{source_T}),
            rand(EulerAngles{source_T}),
            rand(EulerAngleAxis{source_T}),
            rand(Quaternion{source_T}),
            rand(CRP{source_T}),
            rand(MRP{source_T}),
        )

        for source in sources, Representation in representation_types
            result = @inferred convert(Representation, source)
            @test eltype(result) === source_T
        end
    end

    for source_T in (Float32, Float64), target_T in (Float32, Float64)
        sources = (
            rand(DCM{source_T}),
            rand(EulerAngles{source_T}),
            rand(EulerAngleAxis{source_T}),
            rand(Quaternion{source_T}),
            rand(CRP{source_T}),
            rand(MRP{source_T}),
        )

        for source in sources, Representation in representation_types
            result = @inferred convert(Representation{target_T}, source)
            @test typeof(result) === Representation{target_T}
        end
    end

    ea = EulerAngles(1.0, 2.0, 3.0, :XZY)
    ea32 = @inferred convert(EulerAngles{Float32}, ea)
    @test ea32 === EulerAngles{Float32}(1, 2, 3, :XZY)
    @test ea32.rot_seq === :XZY
    @test convert(EulerAngles{Float32}, Quaternion(1.0, 0, 0, 0)).rot_seq === :ZYX

    integer_sources = (
        DCM{Int}(1, 0, 0, 0, 1, 0, 0, 0, 1),
        EulerAngles(0, 0, 0, :XYZ),
        EulerAngleAxis(0, [1, 0, 0]),
        Quaternion(1, 0, 0, 0),
        CRP(0, 0, 0),
        MRP(0, 0, 0),
    )
    for (Representation, source) in zip(representation_types, integer_sources)
        @test (@inferred convert(Representation{Int}, source)) === source
    end
    @test convert(DCM{Int}, Quaternion(1, 0, 0, 0)) === integer_sources[1]

    nonintegral = EulerAngles(0.2, 0.3, 0.4)
    for Representation in representation_types
        @test_throws InexactError convert(Representation{Int}, nonintegral)
    end

    m = MRP(0.1, -0.2, 0.3)
    c = CRP(0.1, -0.2, 0.3)
    @test convert(CRP, m) === mrp_to_crp(m)
    @test convert(MRP, c) === crp_to_mrp(c)
end

# -- Mixed-representation composition ------------------------------------------------------

@testset "Julia conversion API: Mixed composition result types" begin
    representations = (
        rand(DCM{Float32}),
        rand(EulerAngles{Float32}),
        rand(EulerAngleAxis{Float32}),
        rand(Quaternion{Float32}),
        rand(CRP{Float32}),
        rand(MRP{Float32}),
    )

    for outer in representations, inner in reverse(representations)
        result = @inferred outer ∘ inner
        @test typeof(result) === typeof(outer)
    end
end

# -- Conversion to Euler angle and axis ----------------------------------------------------

@testset "Julia conversion API: To Euler angle and axis" begin
    for T in (Float32, Float64)
        # == DCMs ==========================================================================

        dcm = rand(DCM{T})
        av_exp = dcm_to_angleaxis(dcm)
        av_api = convert(EulerAngleAxis, dcm)
        @test av_exp === av_api
        @test eltype(av_api) === T

        # == Euler Angles ==================================================================

        ea = rand(EulerAngles{T})
        av_exp = angle_to_angleaxis(ea)
        av_api = convert(EulerAngleAxis, ea)
        @test av_exp === av_api
        @test eltype(av_api) === T

        # == Quaternion ====================================================================

        q = rand(Quaternion{T})
        av_exp = quat_to_angleaxis(q)
        av_api = convert(EulerAngleAxis, q)
        @test av_exp === av_api
        @test eltype(av_api) === T

        # == Classical Rodrigues Parameters (CRP) ==========================================

        c = rand(CRP{T})
        av_exp = crp_to_angleaxis(c)
        av_api = convert(EulerAngleAxis, c)
        @test av_exp === av_api
        @test eltype(av_api) === T

        # == Modified Rodrigues Parameters (MRP) ===========================================

        m = rand(MRP{T})
        av_exp = mrp_to_angleaxis(m)
        av_api = convert(EulerAngleAxis, m)
        @test av_exp === av_api
        @test eltype(av_api) === T
    end
end

# -- Conversion to Euler Angles ------------------------------------------------------------

@testset "Julia Conversion API: To Euler Angles" begin
    for rot_seq in valid_rot_seqs
        for T in (Float32, Float64)
            # == DCM =======================================================================

            dcm = rand(DCM{T})
            ea_exp = dcm_to_angle(dcm, rot_seq)
            ea_api = @inferred convert(EulerAngles(rot_seq), dcm)
            @test ea_exp === ea_api
            @test eltype(ea_api) === T

            # == Euler Angle ===============================================================

            ea = rand(EulerAngles{T})
            ea_exp = angle_to_angle(ea, rot_seq)
            ea_api = @inferred convert(EulerAngles(rot_seq), ea)
            @test ea_api === ea_exp
            @test eltype(ea_api) === T

            # == Euler Angle and Axis ======================================================

            av = rand(EulerAngleAxis{T})
            ea_exp = angleaxis_to_angle(av, rot_seq)
            ea_api = @inferred convert(EulerAngles(rot_seq), av)
            @test ea_api === ea_exp
            @test eltype(ea_api) === T

            # == Quaternion ================================================================

            q = rand(Quaternion{T})
            ea_exp = quat_to_angle(q, rot_seq)
            ea_api = @inferred convert(EulerAngles(rot_seq), q)
            @test ea_exp === ea_api
            @test eltype(ea_api) === T

            # == Classical Rodrigues Parameters (CRP) ======================================

            c = rand(CRP{T})
            ea_exp = crp_to_angle(c, rot_seq)
            ea_api = @inferred convert(EulerAngles(rot_seq), c)
            @test ea_exp === ea_api
            @test eltype(ea_api) === T

            # == Modified Rodrigues Parameters (MRP) =======================================

            m = rand(MRP{T})
            ea_exp = mrp_to_angle(m, rot_seq)
            ea_api = @inferred convert(EulerAngles(rot_seq), m)
            @test ea_exp === ea_api
            @test eltype(ea_api) === T
        end
    end

    # Conversion without specifying the rotation sequence.
    for T in (Float32, Float64)
        # == DCM ===========================================================================

        dcm = rand(DCM{T})
        ea_exp = dcm_to_angle(dcm, :ZYX)
        ea_api = convert(EulerAngles, dcm)
        @test ea_exp === ea_api
        @test eltype(ea_api) === T

        # == Euler Angle ===================================================================

        ea = rand(EulerAngles{T})
        ea_api = convert(EulerAngles, ea)
        @test ea_api === ea
        @test eltype(ea_api) === T

        # In a previous version, there was a bug in which this code was changing the
        # rotation sequence to `:ZYX`.
        vea = EulerAngles[ea]
        @test vea[1] === ea

        # == Euler Angle and Axis ==========================================================

        # Sample a random Euler angle and axis.
        av = rand(EulerAngleAxis{T})
        ea_exp = angleaxis_to_angle(av, :ZYX)
        ea_api = convert(EulerAngles, av)
        @test ea_api === ea_exp
        @test eltype(ea_api) === T

        # == Quaternion ====================================================================

        q = rand(Quaternion{T})
        ea_exp = quat_to_angle(q)
        ea_api = convert(EulerAngles, q)
        @test ea_exp === ea_api
        @test eltype(ea_api) === T

        # == Classical Rodrigues Parameters (CRP) ==========================================

        c = rand(CRP{T})
        ea_exp = crp_to_angle(c)
        ea_api = convert(EulerAngles, c)
        @test ea_exp === ea_api
        @test eltype(ea_api) === T

        # == Modified Rodrigues Parameters (MRP) ===========================================

        m = rand(MRP{T})
        ea_exp = mrp_to_angle(m)
        ea_api = convert(EulerAngles, m)
        @test ea_exp === ea_api
        @test eltype(ea_api) === T
    end

    @test_throws ArgumentError convert(EulerAngles(:invalid), rand(DCM))
end

# -- Conversion to Quaternion --------------------------------------------------------------

@testset "Julia conversion API: To Quaternion" begin
    for T in (Float32, Float64)
        # == Euler Angles ==================================================================

        ea = rand(EulerAngles{T})
        q_exp = angle_to_quat(ea)
        q_api = convert(Quaternion, ea)
        @test q_api === q_exp
        @test eltype(q_api) === T

        # == Euler Angle and Axis ==========================================================

        # Sample a random Euler angle and axis.
        av = rand(EulerAngleAxis{T})
        q_exp = angleaxis_to_quat(av)
        q_api = convert(Quaternion, av)
        @test q_api === q_exp
        @test eltype(q_api) === T

        # == DCM ===========================================================================

        D = rand(DCM{T})
        q_exp = dcm_to_quat(D)
        q_api = convert(Quaternion, D)
        @test q_api === q_exp
        @test eltype(q_api) === T

        # == Classical Rodrigues Parameters (CRP) ==========================================

        c = rand(CRP{T})
        q_exp = crp_to_quat(c)
        q_api = convert(Quaternion, c)
        @test q_api === q_exp
        @test eltype(q_api) === T

        # == Modified Rodrigues Parameters (MRP) ===========================================

        m = rand(MRP{T})
        q_exp = mrp_to_quat(m)
        q_api = convert(Quaternion, m)
        @test q_api === q_exp
        @test eltype(q_api) === T
    end
end
