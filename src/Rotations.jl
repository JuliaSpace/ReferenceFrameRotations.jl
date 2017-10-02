VERSION >= v"0.4.0-dev+6521" && __precompile__()

module Rotations

export EulerAngles, RotationSequenceError

import Base: sin, cos

include("types.jl")
include("exceptions.jl")

include("DCM.jl")
include("euler_angles.jl")

end # module
