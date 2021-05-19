# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the conversion from small Euler angles to DCM.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export smallangle_to_dcm

"""
    smallangle_to_dcm(θx::Number, θy::Number, θz::Number; normalize = true)

Create a direction cosine matrix from three small rotations of angles `θx`,
`θy`, and `θz` [rad] about the axes X, Y, and Z, respectively.

If the keyword `normalize` is `true`, then the matrix will be normalized using
the function `orthonormalize`.

# Example

```jldoctest
julia> smallangle_to_dcm(+0.01, -0.01, +0.01)
3×3 StaticArrays.SMatrix{3, 3, Float64, 9} with indices SOneTo(3)×SOneTo(3):
  0.9999     0.00989903  0.010098
 -0.009999   0.999901    0.00989802
 -0.009999  -0.009998    0.9999

julia> smallangle_to_dcm(+0.01, -0.01, +0.01; normalize = false)
3×3 StaticArrays.SMatrix{3, 3, Float64, 9} with indices SOneTo(3)×SOneTo(3):
  1.0    0.01  0.01
 -0.01   1.0   0.01
 -0.01  -0.01  1.0
```
"""
@inline function smallangle_to_dcm(
    θx::Number,
    θy::Number,
    θz::Number;
    normalize = true
)
    D = DCM(
          1, +θz, -θy,
        -θz,   1, +θx,
        +θy, -θx,   1
    )'

    if normalize
        return orthonormalize(D)
    else
        return D
    end
end
