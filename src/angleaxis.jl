## Description #############################################################################
#
# Functions related to the Euler angle and axis.
#
############################################################################################

############################################################################################
#                                        Operations                                        #
############################################################################################

"""
    *(av₂::EulerAngleAxis, av₁::EulerAngleAxis) -> EulerAngleAxis

Compose `av₁` followed by `av₂`.

Represent the result as an Euler angle and axis (see
[`EulerAngleAxis`](@ref)). By convention, the output angle will always be in the
range `[0, π]` [rad].

Require the vectors representing the axes in `av₁` and `av₂` to have unit length; this
function neither verifies nor normalizes them.

!!! note

    The output type `T3` is obtained by promoting `T1` and `T2` to a float.

# Examples

```jldoctest
julia> av1 = EulerAngleAxis(deg2rad(45), [sqrt(2)/2, sqrt(2)/2, 0])
EulerAngleAxis{Float64}:
  Euler angle : 0.785398 rad  (45.0°)
  Euler axis  : [0.707107, 0.707107, 0.0]

julia> av2 = EulerAngleAxis(deg2rad(22.5), [sqrt(2)/2, sqrt(2)/2, 0])
EulerAngleAxis{Float64}:
  Euler angle : 0.392699 rad  (22.5°)
  Euler axis  : [0.707107, 0.707107, 0.0]

julia> av1 * av2
EulerAngleAxis{Float64}:
  Euler angle : 1.1781 rad  (67.5°)
  Euler axis  : [0.707107, 0.707107, 0.0]
```
"""
function *(av₂::EulerAngleAxis{T1}, av₁::EulerAngleAxis{T2}) where {T1, T2}
    # Obtain the type of the operation result.
    Tf = float(promote_type(T1, T2))
    z = zero(Tf)
    o = one(Tf)
    two = Tf(2)

    # Auxiliary variables.
    sθ₁o2, cθ₁o2 = sincos(Tf(av₁.a) / two)
    sθ₂o2, cθ₂o2 = sincos(Tf(av₂.a) / two)

    v₁ = Tf.(av₁.v)
    v₂ = Tf.(av₂.v)

    # Compute `cos(θ/2)` in which `θ` is the new Euler angle.
    cθo2 = cθ₁o2 * cθ₂o2 - sθ₁o2 * sθ₂o2 * dot(v₁, v₂)

    # Unnormalized vectorial part of the composed quaternion. Its norm is `sin(θ/2)`.
    w = sθ₁o2 * cθ₂o2 * v₁ + cθ₁o2 * sθ₂o2 * v₂ + sθ₁o2 * sθ₂o2 * (v₁ × v₂)
    sθo2 = norm(w)

    if iszero(sθo2)
        # In this case, the rotation is the identity.
        return EulerAngleAxis(z, SVector{3, Tf}(z, z, z))
    else
        # Compute the θ angle between [0, 2π]. `atan` is well conditioned everywhere, unlike
        # `acos(cos(θ/2))`, which loses precision for θ near 0.
        θ = two * atan(sθo2, cθo2)

        # Keep the angle between [0, π].
        s = o
        πT = Tf(π)
        if θ > πT
            θ = two * πT - θ
            s = -o
        end

        return EulerAngleAxis(θ, s * w / sθo2)
    end
end

"""
    inv(av::EulerAngleAxis) -> EulerAngleAxis

Return the inverse rotation of the Euler angle and axis `av`.

Return an Euler angle in the interval `[0, π]` [rad].

# Examples

```jldoctest
julia> av = EulerAngleAxis(deg2rad(20), [sqrt(2) / 2, 0, sqrt(2) / 2])
EulerAngleAxis{Float64}:
  Euler angle : 0.349066 rad  (20.0°)
  Euler axis  : [0.707107, 0.0, 0.707107]

julia> inv(av)
EulerAngleAxis{Float64}:
  Euler angle : 0.349066 rad  (20.0°)
  Euler axis  : [-0.707107, -0.0, -0.707107]

julia> av = EulerAngleAxis(deg2rad(-20), [sqrt(2) / 2, 0, sqrt(2) / 2])
EulerAngleAxis{Float64}:
  Euler angle : -0.349066 rad  (-20.0°)
  Euler axis  : [0.707107, 0.0, 0.707107]

julia> inv(av)
EulerAngleAxis{Float64}:
  Euler angle : 0.349066 rad  (20.0°)
  Euler axis  : [0.707107, 0.0, 0.707107]
```
"""
@inline function inv(av::EulerAngleAxis{T}) where {T <: Number}
    Tout = float(T)

    # Make sure that the Euler angle is always in the interval [0, π].
    s = -1
    θ = mod(Tout(av.a), Tout(2π))

    if θ > π
        s = 1
        θ = Tout(2π) - θ
    end

    return EulerAngleAxis(θ, s * av.v)
end

############################################################################################
#                                            IO                                            #
############################################################################################

function show(io::IO, av::EulerAngleAxis{T}) where {T}
    # Get if `io` request a compact printing, defaulting to true.
    compact_printing = get(io, :compact, true)

    # Convert the values using `print` and compact printing.
    θ_str  = sprint(print, av.a; context = :compact => compact_printing)
    v₁_str = sprint(print, av.v[1]; context = :compact => compact_printing)
    v₂_str = sprint(print, av.v[2]; context = :compact => compact_printing)
    v₃_str = sprint(print, av.v[3]; context = :compact => compact_printing)

    print(
        io,
        "EulerAngleAxis{$T}: θ = " *
        θ_str *
        " rad, v = [" *
        v₁_str *
        ", " *
        v₂_str *
        ", " *
        v₃_str *
        "]",
    )

    return nothing
end

function show(io::IO, mime::MIME"text/plain", av::EulerAngleAxis{T}) where {T}
    # Check if the user wants colors.
    color = get(io, :color, false)::Bool

    # Check if the user wants compact printing, defaulting to `true`.
    compact_printing = get(io, :compact, true)::Bool

    # Assemble the context.
    context = IOContext(io, :color => color, :compact => compact_printing)

    g = color ? string(_g) : ""
    y = color ? string(_y) : ""
    d = color ? string(_d) : ""

    θ_str  = sprint(print, av.a; context = context)
    θd_str = sprint(print, rad2deg(av.a); context = context)
    v₁_str = sprint(print, av.v[1]; context = context)
    v₂_str = sprint(print, av.v[2]; context = context)
    v₃_str = sprint(print, av.v[3]; context = context)

    println(io, "EulerAngleAxis{$T}:")
    print(io, g)
    print(io, "  Euler angle : ")
    print(io, d)
    print(io, θ_str * " rad  ")
    println(io, "(" * θd_str * "°)")
    print(io, y)
    print(io, "  Euler axis  : ")
    print(io, d)
    print(io, "[" * v₁_str * ", " * v₂_str * ", " * v₃_str * "]")

    return nothing
end

############################################################################################
#                                        Julia API                                         #
############################################################################################

Base.eltype(::Type{EulerAngleAxis{T}}) where {T} = T
