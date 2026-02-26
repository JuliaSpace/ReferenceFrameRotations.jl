module ReferenceFrameRotations

import Base: +, -, *, /, \, ≈, ==, ∘
import Base: conj, convert, copy, display, eltype, firstindex, getindex, imag
import Base: inv, iterate, lastindex, ndims, one, rand, real, setindex!, show
import Base: summary, zero, zeros
import Base: Broadcast.broadcastable, Tuple
import LinearAlgebra: norm
import StaticArrays: similar_type

using Crayons
using LinearAlgebra
using Printf
using Random
using StaticArrays

# Re-export `I` from LinearAlgebra.
export I

############################################################################################
#                                  Types and Conversions                                   #
############################################################################################

include("types.jl")

############################################################################################
#                                        Constants                                         #
############################################################################################

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

############################################################################################
#                                         Includes                                         #
############################################################################################

include("angle.jl")
include("angleaxis.jl")
include("compose_rotations.jl")
include("dcm.jl")
include("inv_rotations.jl")
include("random.jl")
include("quaternion.jl")
include("crp.jl")
include("mrp.jl")
include("shadow_rotation.jl")

include("deprecations.jl")

include("./conversions/angle_to_angle.jl")
include("./conversions/angle_to_angleaxis.jl")
include("./conversions/angle_to_crp.jl")
include("./conversions/angle_to_dcm.jl")
include("./conversions/angle_to_mrp.jl")
include("./conversions/angle_to_quat.jl")
include("./conversions/angle_to_rot.jl")
include("./conversions/angleaxis_to_angle.jl")
include("./conversions/angleaxis_to_dcm.jl")
include("./conversions/angleaxis_to_quat.jl")
include("./conversions/crp_to_angle.jl")
include("./conversions/crp_to_angleaxis.jl")
include("./conversions/crp_to_dcm.jl")
include("./conversions/crp_to_mrp.jl")
include("./conversions/crp_to_quat.jl")
include("./conversions/api.jl")
include("./conversions/dcm_to_angle.jl")
include("./conversions/dcm_to_angleaxis.jl")
include("./conversions/dcm_to_crp.jl")
include("./conversions/dcm_to_mrp.jl")
include("./conversions/dcm_to_quat.jl")
include("./conversions/mrp_to_angle.jl")
include("./conversions/mrp_to_angleaxis.jl")
include("./conversions/mrp_to_crp.jl")
include("./conversions/mrp_to_dcm.jl")
include("./conversions/mrp_to_quat.jl")
include("./conversions/quat_to_angle.jl")
include("./conversions/quat_to_angleaxis.jl")
include("./conversions/quat_to_crp.jl")
include("./conversions/quat_to_dcm.jl")
include("./conversions/quat_to_mrp.jl")
include("./conversions/smallangle_to_dcm.jl")
include("./conversions/smallangle_to_quat.jl")
include("./conversions/smallangle_to_rot.jl")

end # module
