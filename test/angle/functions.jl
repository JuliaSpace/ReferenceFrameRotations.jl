## Desription ##############################################################################
#
# Tests related to the general functions using Euler angles.
#
############################################################################################

# == File: ./src/angle.jl ==================================================================

# -- Functions: inv ------------------------------------------------------------------------

@testset "General Functions of Euler Angles: inv" begin
    for T in (Float32, Float64)
        for rot_seq in valid_rot_seqs
            ea = rand(EulerAngles{T})
            iea = inv(ea)
            @test eltype(iea) === T

            if ea.rot_seq == :XYZ
                inv_rot_seq = :ZYX
            elseif ea.rot_seq == :XZY
                inv_rot_seq = :YZX
            elseif ea.rot_seq == :YXZ
                inv_rot_seq = :ZXY
            elseif ea.rot_seq == :YZX
                inv_rot_seq = :XZY
            elseif ea.rot_seq == :ZXY
                inv_rot_seq = :YXZ
            elseif ea.rot_seq == :ZYX
                inv_rot_seq = :XYZ
            else
                inv_rot_seq = ea.rot_seq
            end

            @test iea.a1 ≈ -ea.a3
            @test iea.a2 ≈ -ea.a2
            @test iea.a3 ≈ -ea.a1
            @test iea.rot_seq == inv_rot_seq
        end
    end
end

# -- Functions: show -----------------------------------------------------------------------

@testset "General Functions of Euler Angles: show" begin
    buf = IOBuffer()
    io = IOContext(buf)
    ea = EulerAngles(π / 3, π / 6,  2 / 3 * π, :ZYX)

    # Extended printing.
    show(io, MIME"text/plain"(), ea)
    expected = """
        EulerAngles{Float64}:
          R(Z) :  1.0472   rad  ( 60.0°)
          R(Y) :  0.523599 rad  ( 30.0°)
          R(X) :  2.0944   rad  ( 120.0°)"""
    @test String(take!(io.io)) == expected

    # Comapct printing.
    show(io, ea)
    expected = """
        EulerAngles{Float64}: R(ZYX)  1.0472  0.523599  2.0944 rad"""
    @test String(take!(io.io)) == expected

    # Colors.
    io = IOContext(buf, :color => true)
    show(io, MIME"text/plain"(), ea)
    expected = """
        EulerAngles{Float64}:
        \e[32;1m  R(Z) : \e[0m 1.0472   rad  ( 60.0°)
        \e[33;1m  R(Y) : \e[0m 0.523599 rad  ( 30.0°)
        \e[34;1m  R(X) : \e[0m 2.0944   rad  ( 120.0°)"""
    @test String(take!(io.io)) == expected
end
