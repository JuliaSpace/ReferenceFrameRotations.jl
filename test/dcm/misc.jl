# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to DCM miscellaneous functions.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/dcm.jl
# ==================

# Functions: summary
# ------------------

@testset "DCM summary" begin
    io = IOBuffer()

    D = DCM(1.0I)
    summary(io, D)
    str = String(take!(io))
    @test str == "DCM{Float64}"

    D = DCM(1.0f0I)
    summary(io, D)
    str = String(take!(io))
    @test str == "DCM{Float32}"
end

# Functions: Tuple
# ----------------

@testset "StaticArrays.jl API" begin
    D = DCM(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0)
    @test Tuple(D) === (1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0)

    D = DCM(1.0f0, 2.0f0, 3.0f0, 4.0f0, 5.0f0, 6.0f0, 7.0f0, 8.0f0, 9.0f0)
    @test Tuple(D) === (1.0f0, 2.0f0, 3.0f0, 4.0f0, 5.0f0, 6.0f0, 7.0f0, 8.0f0, 9.0f0)
end
