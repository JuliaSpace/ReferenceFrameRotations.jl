# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the Direction Cosine Matrix (DCM).
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export create_rotation_matrix
export ddcm, orthonormalize

"""
    create_rotation_matrix(angle::Number, axis::Symbol = :X)

Compute a rotation matrix that rotates a coordinate frame about the `axis` by
the `angle`.

The `axis` must be one of the following symbols: `:X`, `:Y`, or `:Z`.

# Example

```jldocstest
julia> create_rotation_matrix(pi/2, :X)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
 1.0   0.0          0.0
 0.0   6.12323e-17  1.0
 0.0  -1.0          6.12323e-17
```
"""
function create_rotation_matrix(angle::Number, axis::Symbol = :X)
    sa, ca = sincos(angle)

    if axis == :X
        return DCM(
            1,   0,   0,
            0, +ca, +sa,
            0, -sa, +ca
        )'
    elseif axis == :Y
        return DCM(
            +ca, 0, -sa,
              0, 1,   0,
            +sa, 0, +ca
        )'
    elseif axis == :Z
        return DCM(
            +ca, +sa, 0,
            -sa, +ca, 0,
              0,   0, 1
        )'
    else
        throw(ArgumentError("Axis must be :X, :Y, or :Z"))
    end
end

"""
    orthonormalize(dcm::DCM)

Perform the Gram-Schmidt orthonormalization process in the `dcm` and return the
new matrix.

!!! warning
    This function does not check if the columns of the input matrix span a
    three-dimensional space. If not, then the returned matrix should have `NaN`.
    Notice, however, that such input matrix is not a valid direction cosine
    matrix.

# Example

```julia-repl
julia> D = DCM(3I)

julia> orthonormalize(D)
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0
```
"""
function orthonormalize(dcm::DCM)
    e₁ = dcm[:, 1]
    e₂ = dcm[:, 2]
    e₃ = dcm[:, 3]

    en₁  = e₁ / norm(e₁)
    enj₂ = e₂ - (en₁ ⋅ e₂) * en₁
    en₂  = enj₂ / norm(enj₂)
    enj₃ = e₃ - (en₁ ⋅ e₃) * en₁
    enj₃ = enj₃ - (en₂ ⋅ enj₃) * en₂
    en₃  = enj₃ / norm(enj₃)

    return hcat(en₁, en₂, en₃)
end

################################################################################
#                                  Kinematics
################################################################################

"""
    ddcm(Dba::DCM, wba_b::AbstractArray)

Compute the time-derivative of the `dcm` that rotates a reference frame `a` into
alignment with the reference frame `b` in which the angular velocity of `b` with
respect to `a`, and represented in `b`, is `wba_b`.

# Example

```julia-repl
julia> D = DCM(1.0I);

julia> ddcm(D, [1, 0, 0])
3×3 StaticArrays.SArray{Tuple{3,3},Float64,2,9}:
 0.0   0.0  0.0
 0.0   0.0  1.0
 0.0  -1.0  0.0
```
"""
function ddcm(Dba::DCM, wba_b::AbstractArray)
    # Auxiliary variable.
    w = wba_b

    # Check the dimensions.
    if length(wba_b) != 3
        throw(ArgumentError("The angular velocity vector must have three components."))
    end

    wx = SMatrix{3,3}(
          0  , -w[3], +w[2],
        +w[3],   0  , -w[1],
        -w[2], +w[1],   0,
    )'

    # Return the time-derivative.
    return -wx * Dba
end
