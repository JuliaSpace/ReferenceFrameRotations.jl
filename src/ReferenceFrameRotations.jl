module ReferenceFrameRotations

import Base: +, -, *, /, \, ≈, ==
import Base: conj, convert, copy, display, eltype, firstindex, getindex, imag
import Base: inv, iterate, lastindex, ndims, one, real, setindex!, show
import Base: zero, zeros
import Base: Broadcast.broadcastable
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

const _CONVERSIONS_DIR = joinpath(@__DIR__, "conversions")

include(joinpath(_CONVERSIONS_DIR, angle_to_angle.jl))
include(joinpath(_CONVERSIONS_DIR, angle_to_angleaxis.jl))
include(joinpath(_CONVERSIONS_DIR, angle_to_dcm.jl))
include(joinpath(_CONVERSIONS_DIR, angle_to_quat.jl))
include(joinpath(_CONVERSIONS_DIR, angle_to_rot.jl))
include(joinpath(_CONVERSIONS_DIR, angleaxis_to_angle.jl))
include(joinpath(_CONVERSIONS_DIR, angleaxis_to_dcm.jl))
include(joinpath(_CONVERSIONS_DIR, angleaxis_to_quat.jl))
include(joinpath(_CONVERSIONS_DIR, dcm_to_angle.jl))
include(joinpath(_CONVERSIONS_DIR, dcm_to_angleaxis.jl))
include(joinpath(_CONVERSIONS_DIR, dcm_to_quat.jl))
include(joinpath(_CONVERSIONS_DIR, quat_to_angle.jl))
include(joinpath(_CONVERSIONS_DIR, quat_to_angleaxis.jl))
include(joinpath(_CONVERSIONS_DIR, quat_to_dcm.jl))
include(joinpath(_CONVERSIONS_DIR, smallangle_to_dcm.jl))
include(joinpath(_CONVERSIONS_DIR, smallangle_to_quat.jl))
include(joinpath(_CONVERSIONS_DIR, smallangle_to_rot.jl))

end # module
