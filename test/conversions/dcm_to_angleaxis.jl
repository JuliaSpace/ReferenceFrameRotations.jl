# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to conversion from direction cosine matrices to Euler angle
#   and axis.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/dcm.jl
# ==================

# Functions: dcm_to_angleaxis
# ---------------------------

@testset "DCM => Euler angle and axis (Float64)" begin
    # Create a random DCM.
    D = create_rotation_matrix(_rand_ang(), :X) *
        create_rotation_matrix(_rand_ang(), :Y) *
        create_rotation_matrix(_rand_ang(), :Z)

    # Convert to Euler angle and axis.
    av = dcm_to_angleaxis(D)

    # Check if the rotation expressed by D is consistent, which is performed in
    # two steps:
    #
    #   1. A vector aligned with `v` does not change.
    #   2. A vector perpendicular to `v` is rotated by `a`.

    v = av.v
    vr = D * v
    @test vr ≈ v

    # Auxiliary vector to obtain a vector perpendicular to `v`.
    aux = @SVector randn(3)
    aux = aux / norm(aux)

    vp = av.v × aux
    vp = vp / norm(vp)
    vpr = D * vp

    # Compute the angle between vp and vpr in [0, 2π].
    a = acos(vp ⋅ vpr)
    @test a ≈ av.a
end

@testset "DCM => Euler angle and axis (Float32)" begin
    # Create a random DCM.
    D = create_rotation_matrix(_rand_ang(), :X) *
        create_rotation_matrix(_rand_ang(), :Y) *
        create_rotation_matrix(_rand_ang(), :Z)

    # Convert to Euler angle and axis.
    av = dcm_to_angleaxis(D)

    # Check if the rotation expressed by D is consistent, which is performed in
    # two steps:
    #
    #   1. A vector aligned with `v` does not change.
    #   2. A vector perpendicular to `v` is rotated by `a`.

    v = av.v
    vr = D * v
    @test vr ≈ v

    # Auxiliary vector to obtain a vector perpendicular to `v`.
    aux = @SVector randn(3)
    aux = aux / norm(aux)

    vp = av.v × aux
    vp = vp / norm(vp)
    vpr = D * vp

    # Compute the angle between vp and vpr in [0, 2π].
    a = acos(vp ⋅ vpr)
    @test a ≈ av.a
end

@testset "DCM => Euler angle and axis (Special cases)" begin
    # Test special cases
    # ==========================================================================

    D = DCM(I)
    av = dcm_to_angleaxis(D)
    @test av.a ≈ 0
    @test av.v ≈ [0, 0, 0]

    D = create_rotation_matrix(π, :X)
    av = dcm_to_angleaxis(D)
    @test av.a ≈ π
    @test av.v ≈ [1, 0, 0]

    D = create_rotation_matrix(π, :Y)
    av = dcm_to_angleaxis(D)
    @test av.a ≈ π
    @test av.v ≈ [0, 1, 0]

    D = create_rotation_matrix(π, :Z)
    av = dcm_to_angleaxis(D)
    @test av.a ≈ π
    @test av.v ≈ [0, 0, 1]
end
