# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the API to convert from small Euler angles to rotation
#   representations.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export smallangle_to_rot

"""
    smallangle_to_rot([T,] θx::Number, θy::Number, θz::Number[; normalize = true])

Create a rotation description of type `T` from three small rotations of angles
`θx`, `θy`, and `θz` [rad] about the axes X, Y, and Z, respectively.

The type `T` of the rotation description can be `DCM` or `Quaternion`. If the
type `T` is not specified, then if defaults to `DCM`.

If `T` is `DCM`, then the resulting matrix will be orthonormalized using the
`orthonormalize` function if the keyword `normalize` is `true`.

# Example

```jldoctest
julia> dcm = smallangle_to_rot(+0.01, -0.01, +0.01)
3×3 StaticArrays.SMatrix{3, 3, Float64, 9} with indices SOneTo(3)×SOneTo(3):
  0.9999     0.00989903  0.010098
 -0.009999   0.999901    0.00989802
 -0.009999  -0.009998    0.9999

julia> dcm = smallangle_to_rot(+0.01, -0.01, +0.01; normalize = false)
3×3 StaticArrays.SMatrix{3, 3, Float64, 9} with indices SOneTo(3)×SOneTo(3):
  1.0    0.01  0.01
 -0.01   1.0   0.01
 -0.01  -0.01  1.0

julia> q = smallangle_to_rot(Quaternion, +0.01, -0.01, +0.01)
Quaternion{Float64}:
  + 0.999963 + 0.00499981⋅i - 0.00499981⋅j - 0.00499981⋅k
```
"""
@inline function smallangle_to_rot(
    θx::Number,
    θy::Number,
    θz::Number;
    normalize = true
)
    return smallangle_to_dcm(θx, θy, θz; normalize = normalize)
end

@inline function smallangle_to_rot(
    ::Type{DCM},
    θx::Number,
    θy::Number,
    θz::Number;
    normalize = true
)
    return smallangle_to_dcm(θx, θy, θz; normalize = normalize)
end

@inline function smallangle_to_rot(
    ::Type{Quaternion},
    θx::Number,
    θy::Number,
    θz::Number
)
    return smallangle_to_quat(θx, θy, θz)
end
