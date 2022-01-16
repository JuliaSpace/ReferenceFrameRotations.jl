# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to the API function to invert rotations.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/inv_rotations.jl
# ============================

# Functions: inv_rotation
# -----------------------

@testset "Invert rotations" begin
    for T in (Float32, Float64)
        # DCM
        # ======================================================================

        # Create a random DCM.
        D = rand(DCM{T})

        Di = inv_rotation(D)
        @test eltype(Di) === T

        Die = inv(D)
        @test Di ≈ Die

        # Quaternion
        # ======================================================================

        # Create a random quaternion.
        q = rand(Quaternion{T})

        qi = inv_rotation(q)
        @test eltype(qi) === T

        qie = inv(q)
        @test qi ≈ qie

        # Euler angle and axis
        # ======================================================================

        # Create a random Euler angle and axis.
        av = rand(EulerAngleAxis{T})

        avi = inv_rotation(av)
        @test eltype(avi) === T

        avie = inv(av)
        @test avi ≈ avie

        # Euler angles
        # ======================================================================

        # Create random Euler angles.
        ea = rand(EulerAngles{T})

        eai = inv_rotation(ea)
        @test eltype(eai) === T

        eaie = inv(ea)
        @test eai ≈ eaie
    end
end
