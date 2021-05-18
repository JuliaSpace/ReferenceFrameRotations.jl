module ReferenceFrameRotations

import Base: +, -, *, /, \, conj, copy, display, getindex, inv, imag, real, show
import Base: zeros, eltype
import LinearAlgebra: norm

using Crayons
using LinearAlgebra
using Printf
using StaticArrays

# Re-export `I` from LinearAlgebra.
export I

################################################################################
#                                    Types
################################################################################

include("types.jl")

################################################################################
#                                 Deprecations
################################################################################

@deprecate eye(::Type{Quaternion{T}}) where T Quaternion{T}(I)
@deprecate eye(::Type{Quaternion}) where T Quaternion{Float64}(I)
@deprecate eye(q::Quaternion{T}) where T Quaternion(I,q)

################################################################################
#                                  Constants
################################################################################

# Pre-defined crayons.
const _reset_crayon = Crayon(reset = true)
const _crayon_bold  = crayon"bold"
const _crayon_g     = crayon"bold green"
const _crayon_u     = crayon"bold blue"
const _crayon_y     = crayon"bold yellow"

# Escape sequences related to the crayons.
const _b = _crayon_bold
const _d = _reset_crayon
const _g = _crayon_g
const _y = _crayon_y
const _u = _crayon_u

################################################################################
#                                   Includes
################################################################################

include("angle.jl")
include("angleaxis.jl")
include("compose_rotations.jl")
include("dcm.jl")
include("inv_rotations.jl")
include("quaternion.jl")

include("deprecations.jl")

include("./conversions/angle_to_angle.jl")
include("./conversions/angle_to_angleaxis.jl")
include("./conversions/angle_to_dcm.jl")
include("./conversions/angle_to_quat.jl")
include("./conversions/angle_to_rot.jl")
include("./conversions/angleaxis_to_angle.jl")
include("./conversions/angleaxis_to_dcm.jl")
include("./conversions/angleaxis_to_quat.jl")
include("./conversions/dcm_to_angle.jl")
include("./conversions/dcm_to_angleaxis.jl")
include("./conversions/dcm_to_quat.jl")
include("./conversions/quat_to_angle.jl")
include("./conversions/quat_to_angleaxis.jl")
include("./conversions/quat_to_dcm.jl")
include("./conversions/smallangle_to_dcm.jl")
include("./conversions/smallangle_to_quat.jl")
include("./conversions/smallangle_to_rot.jl")

end # module
