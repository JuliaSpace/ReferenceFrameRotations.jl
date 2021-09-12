# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to conversion from direction cosine matrices to Euler angle
#   and axis.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/conversions/dcm_to_angleaxis.jl
# ===========================================

# Functions: dcm_to_angleaxis
# ---------------------------

@testset "DCM => Euler angle and axis (Float64)" begin
    T = Float64

    # Create a random DCM.
    D = angle_to_dcm(_rand_ang(T), :X) *
        angle_to_dcm(_rand_ang(T), :Y) *
        angle_to_dcm(_rand_ang(T), :Z)

    # Convert to Euler angle and axis.
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T

    # Check if the rotation expressed by D is consistent, which is performed in
    # two steps:
    #
    #   1. A vector aligned with `v` does not change.
    #   2. A vector perpendicular to `v` is rotated by `a`.

    v = av.v
    vr = D * v
    @test vr ≈ v
    @test eltype(v) === eltype(vr) === T

    # Auxiliary vector to obtain a vector perpendicular to `v`.
    aux = @SVector randn(3)
    aux = aux / norm(aux)

    vp = av.v × aux
    vp = vp / norm(vp)
    vpr = D * vp
    @test eltype(vp) === eltype(vpr) === T

    # Compute the angle between vp and vpr in [0, 2π].
    a = acos(vp ⋅ vpr)
    @test a ≈ av.a
end

@testset "DCM => Euler angle and axis (Float32)" begin
    T = Float32

    # Create a random DCM.
    D = angle_to_dcm(_rand_ang(T), :X) *
        angle_to_dcm(_rand_ang(T), :Y) *
        angle_to_dcm(_rand_ang(T), :Z)

    # Convert to Euler angle and axis.
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T

    # Check if the rotation expressed by D is consistent, which is performed in
    # two steps:
    #
    #   1. A vector aligned with `v` does not change.
    #   2. A vector perpendicular to `v` is rotated by `a`.

    v = av.v
    vr = D * v
    @test vr ≈ v
    @test eltype(v) === eltype(vr) === T

    # Auxiliary vector to obtain a vector perpendicular to `v`.
    aux = @SVector randn(T, 3)
    aux = aux / norm(aux)

    vp = av.v × aux
    vp = vp / norm(vp)
    vpr = D * vp
    @test eltype(vp) === eltype(vpr) === T

    # Compute the angle between vp and vpr in [0, 2π].
    a = acos(vp ⋅ vpr)
    @test a ≈ av.a
end

@testset "DCM => Euler angle and axis (Special cases)" begin
    # Float64
    # ==========================================================================

    T = Float64

    D = DCM(T(1) * I)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ 0
    @test av.v ≈ [0, 0, 0]

    D = angle_to_dcm(T(π), :X)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ π
    @test av.v ≈ [1, 0, 0]

    D = angle_to_dcm(T(π), :Y)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ π
    @test av.v ≈ [0, 1, 0]

    D = angle_to_dcm(T(π), :Z)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ π
    @test av.v ≈ [0, 0, 1]

    D = angle_to_dcm(T(2π / 3), :X)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ T(2π / 3)
    @test av.v ≈ [1, 0, 0]

    D = angle_to_dcm(T(-2π / 3), :X)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ T(2π / 3)
    @test av.v ≈ [-1, 0, 0]

    D = angle_to_dcm(T(2π / 3), :Y)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ T(2π / 3)
    @test av.v ≈ [0, 1, 0]

    D = angle_to_dcm(T(-2π / 3), :Y)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ T(2π / 3)
    @test av.v ≈ [0, -1, 0]

    D = angle_to_dcm(T(2π / 3), :Z)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ T(2π / 3)
    @test av.v ≈ [0, 0, 1]

    D = angle_to_dcm(T(-2π / 3), :Z)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ T(2π / 3)
    @test av.v ≈ [0, 0, -1]

    D = angle_to_dcm(T(-2π / 3), :Z) * angle_to_dcm(T(-π / 2), :Y)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ 2.4188584057763776
    @test av.v ≈ [0.6546536707079772, -0.37796447300922736, -0.6546536707079772]

    D = DCM(
        T(-1 / 3), T(-2 / 3), T(-1 / 3),
        T(-1 / 3), T(-1 / 3), T(+2 / 3),
        T(-2 / 3), T(+2 / 3), T(-1 / 3)
    )'
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ T(π)
    @test av.v ≈ [T(√3 / 3), T(-√3 / 3), T(-√3 / 3)]

    # Float32
    # ==========================================================================

    T = Float32

    D = DCM(T(1) * I)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ 0
    @test av.v ≈ [0, 0, 0]

    D = angle_to_dcm(T(π), :X)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ π
    @test av.v ≈ [1, 0, 0]

    D = angle_to_dcm(T(π), :Y)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ π
    @test av.v ≈ [0, 1, 0]

    D = angle_to_dcm(T(π), :Z)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ π
    @test av.v ≈ [0, 0, 1]

    D = angle_to_dcm(T(2π / 3), :X)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ T(2π / 3)
    @test av.v ≈ [1, 0, 0]

    D = angle_to_dcm(T(-2π / 3), :X)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ T(2π / 3)
    @test av.v ≈ [-1, 0, 0]

    D = angle_to_dcm(T(2π / 3), :Y)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ T(2π / 3)
    @test av.v ≈ [0, 1, 0]

    D = angle_to_dcm(T(-2π / 3), :Y)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ T(2π / 3)
    @test av.v ≈ [0, -1, 0]

    D = angle_to_dcm(T(2π / 3), :Z)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ T(2π / 3)
    @test av.v ≈ [0, 0, 1]

    D = angle_to_dcm(T(-2π / 3), :Z)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ T(2π / 3)
    @test av.v ≈ [0, 0, -1]

    D = angle_to_dcm(T(-2π / 3), :Z) * angle_to_dcm(T(-π / 2), :Y)
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ 2.4188584057763776
    @test av.v ≈ [0.6546536707079772, -0.37796447300922736, -0.6546536707079772]

    D = DCM(
        T(-1 / 3), T(-2 / 3), T(-1 / 3),
        T(-1 / 3), T(-1 / 3), T(+2 / 3),
        T(-2 / 3), T(+2 / 3), T(-1 / 3)
    )'
    av = dcm_to_angleaxis(D)
    @test eltype(av) === T
    @test av.a ≈ T(π)
    @test av.v ≈ [T(√3 / 3), T(-√3 / 3), T(-√3 / 3)]
end
