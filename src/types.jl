# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                    Types
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Definitions for the module Rotations.jl.
# 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Euler angles.
type EulerAngles{T}
    a1::T
    a2::T
    a3::T
    rot_seq::String
end
