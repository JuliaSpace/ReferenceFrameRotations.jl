# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Deprecated functions.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

################################################################################
#                              Introduced in v1.0
################################################################################

@deprecate create_rotation_matrix angle_to_dcm

@deprecate zeros(T::Type{Quaternion{P}}) where P zero(T)
@deprecate zeros(T::Type{Quaternion}) zero(T)
@deprecate zeros(q::Quaternion{T}) where T zero(q)

