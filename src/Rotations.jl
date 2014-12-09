module Rotations

export EulerAngles, RotationSequenceError
export create_rotation_matrix, angle2dcm, dcm2angle

import Base: sin, cos

include("types.jl")
include("exceptions.jl")

include("DCM.jl")
include("euler_angles.jl")

end # module
