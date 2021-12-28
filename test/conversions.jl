# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to conversion methods.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/conversions.jl
# =========================================

# Functions: Base.convert
# -------------------------

@testset "Conversion Methods" begin
    T = Float64

    for rot_seq in valid_rot_seqs
        # Sample Euler angles.
        ea = EulerAngles(_rand_ang(T), _rand_ang(T), _rand_ang(T), rot_seq)

        # Convert to DCM.
        D = convert(DCM, ea)
        @test D isa SArray
        @test eltype(D) === T
        @test size(D) == (3, 3)
    end
end
