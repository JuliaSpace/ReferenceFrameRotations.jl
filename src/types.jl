# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                    Types
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Definitions for the module Rotations.jl.
# 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Euler angles.
type EulerAngles
    a1::Real
    a2::Real
    a3::Real
    rot_seq::String
end
