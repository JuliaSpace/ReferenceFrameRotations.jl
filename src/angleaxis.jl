# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the Euler angle and axis.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

################################################################################
#                                  Operations
################################################################################

"""
    *(av₂::EulerAngleAxis{T1}, av₁::EulerAngleAxis{T2}) where {T1,T2}

Compute the composed rotation of `av₁ -> av₂`.

The rotation will be represented by a Euler angle and axis (see
[`EulerAngleAxis`](@ref)). By convention, the output angle will always be in the
range `[0, π] rad`.

Notice that the vector representing the axis in `av₁` and `av₂` must be unitary.
This function neither verifies this nor normalizes the vector.

# Examples

```julia-repl
julia> av1 = EulerAngleAxis(deg2rad(45), [sqrt(2)/2, sqrt(2)/2, 0])
EulerAngleAxis{Float64}:
  Euler angle:   0.7854 rad ( 45.0000 deg)
   Euler axis: [  0.7071,   0.7071,   0.0000]

julia> av2 = EulerAngleAxis(deg2rad(22.5), [sqrt(2)/2, sqrt(2)/2, 0])
EulerAngleAxis{Float64}:
  Euler angle:   0.3927 rad ( 22.5000 deg)
   Euler axis: [  0.7071,   0.7071,   0.0000]

julia> av1 * av2
EulerAngleAxis{Float64}:
  Euler angle:   1.1781 rad ( 67.5000 deg)
   Euler axis: [  0.7071,   0.7071,   0.0000]
```
"""
function *(av₂::EulerAngleAxis{T1}, av₁::EulerAngleAxis{T2}) where {T1, T2}
    # Auxiliary variables.
    sθ₁o2, cθ₁o2 = sincos(av₁.a / 2)
    sθ₂o2, cθ₂o2 = sincos(av₂.a / 2)

    v₁ = av₁.v
    v₂ = av₂.v

    # Compute `cos(θ/2)` in which `θ` is the new Euler angle.
    cθo2 = cθ₁o2 * cθ₂o2 - sθ₁o2 * sθ₂o2 * dot(v₁, v₂)

    T = promote_type(T1, T2, typeof(sθ₁o2), typeof(sθ₂o2), typeof(cθo2))

    if abs(cθo2) >= 1 - eps()
        # In this case, the rotation is the identity.
        return EulerAngleAxis(T(0), SVector{3,T}(0, 0, 0))
    else
        # Compute `sin(θ/2)` in which `θ` is the new Euler angle.
        sθo2 = √(1 - cθo2 * cθo2)

        # Compute the θ angle between [0, 2π].
        θ = 2acos(cθo2)

        # Keep the angle between [0, π].
        s = +1
        if θ > π
            θ = T(2π) - θ
            s = -1
        end

        v = s * (sθ₁o2 * cθ₂o2 * v₁ + cθ₁o2 * sθ₂o2 * v₂ + sθ₁o2 * sθ₂o2 * (v₁ × v₂)) / sθo2

        return EulerAngleAxis(θ, v)
    end
end

"""
    inv(av::EulerAngleAxis)

Compute the inverse rotation of the Euler angle and axis `av`.

The Euler angle returned by this function will always be in the interval `[0, π]
rad`.

# Examples

```julia-repl
julia> av = EulerAngleAxis(deg2rad(20), [sqrt(2)/2, 0, sqrt(2)/2])
EulerAngleAxis{Float64}:
  Euler angle:   0.3491 rad ( 20.0000 deg)
   Euler axis: [  0.7071,   0.0000,   0.7071]

julia> inv(av)
EulerAngleAxis{Float64}:
  Euler angle:   0.3491 rad ( 20.0000 deg)
   Euler axis: [ -0.7071,  -0.0000,  -0.7071]

julia> av = EulerAngleAxis(deg2rad(-20), [sqrt(2)/2, 0, sqrt(2)/2])
EulerAngleAxis{Float64}:
  Euler angle:  -0.3491 rad (-20.0000 deg)
   Euler axis: [  0.7071,   0.0000,   0.7071]

julia> inv(av)
EulerAngleAxis{Float64}:
  Euler angle:   0.3491 rad ( 20.0000 deg)
   Euler axis: [  0.7071,   0.0000,   0.7071]
```
"""
@inline function inv(av::EulerAngleAxis{T}) where T<:Number
    # Make sure that the Euler angle is always in the inverval [0,π]
    s = -1
    θ = mod(av.a, T(2π))

    if θ > π
        s = 1
        θ = T(2π) - θ
    end

    return EulerAngleAxis(θ, s*av.v)
end

################################################################################
#                                      IO
################################################################################

function show(io::IO, av::EulerAngleAxis{T}) where T
    θ   = av.a
    v   = av.v
    str = @sprintf "%8.4f rad, [%8.4f, %8.4f, %8.4f]" av.a v[1] v[2] v[3]

    print(io, "EulerAngleAxis{$T}: $str")

    return nothing
end

function show(io::IO, mime::MIME"text/plain", av::EulerAngleAxis{T}) where T
    # Check if the user wants colors.
    color = get(io, :color, false)

    y = (color) ? _y : ""
    d = (color) ? _d : ""

    str_a = @sprintf "%8.4f rad (%8.4f deg)" av.a rad2deg(av.a)
    str_v = @sprintf "[%8.4f, %8.4f, %8.4f]" av.v[1] av.v[2] av.v[3]

    println(io, "EulerAngleAxis{$T}:")
    println(io, "$y  Euler angle: $d" * str_a)
      print(io, "$y   Euler axis: $d" * str_v)

    return nothing
end
