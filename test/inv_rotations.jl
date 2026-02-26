## Desription ##############################################################################
#
# Tests related to the API function to invert rotations.
#
############################################################################################

# == File: ./src/inv_rotations.jl ==========================================================

# -- Functions: inv_rotation ---------------------------------------------------------------

@testset "Invert rotations" begin
    for T in (Float32, Float64)
        # == DCM ===========================================================================

        # Create a random DCM.
        D = rand(DCM{T})

        Di = inv_rotation(D)
        @test eltype(Di) === T

        Die = inv(D)
        @test Di ≈ Die

        # == Quaternion ====================================================================

        # Create a random quaternion.
        q = rand(Quaternion{T})

        qi = inv_rotation(q)
        @test eltype(qi) === T

        qie = inv(q)
        @test qi ≈ qie

        # == Euler Angle and Axis ==========================================================

        # Create a random Euler angle and axis.
        av = rand(EulerAngleAxis{T})

        avi = inv_rotation(av)
        @test eltype(avi) === T

        avie = inv(av)
        @test avi ≈ avie

        # == Euler Angles ==================================================================

        # Create random Euler angles.
        ea = rand(EulerAngles{T})

        eai = inv_rotation(ea)
        @test eltype(eai) === T

        eaie = inv(ea)
        @test eai ≈ eaie

        # == Classical Rodrigues Parameters (CRP) ==========================================

        # Create random CRP.
        c = rand(CRP{T})

        ci = inv_rotation(c)
        @test eltype(ci) === T

        cie = inv(c)
        @test ci ≈ cie

        # == Modified Rodrigues Parameters (MRP) ===========================================

        # Create random MRP.
        m = rand(MRP{T})

        mi = inv_rotation(m)
        @test eltype(mi) === T

        mie = inv(m)
        @test mi ≈ mie
    end
end
