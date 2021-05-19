# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the Euler angles.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

################################################################################
#                                  Operations
################################################################################

"""
    *(Θ₂::EulerAngles, Θ₁::EulerAngles)

Compute the composed rotation of `Θ₁ -> Θ₂`.

The rotation will be represented by Euler angles (see [`EulerAngles`](@ref))
with the same rotation sequence as `Θ₂`.

# Examples

```jldoctest
julia> ea1 = EulerAngles(deg2rad(35), 0, 0, :XYZ)
EulerAngles{Float64}:
  R(X) :  0.610865 rad  ( 35.0°)
  R(Y) :  0.0      rad  ( 0.0°)
  R(Z) :  0.0      rad  ( 0.0°)

julia> ea2 = EulerAngles(0, 0, deg2rad(25), :ZYX)
EulerAngles{Float64}:
  R(Z) :  0.0      rad  ( 0.0°)
  R(Y) :  0.0      rad  ( 0.0°)
  R(X) :  0.436332 rad  ( 25.0°)

julia> ea2 * ea1
EulerAngles{Float64}:
  R(Z) :  0.0    rad  ( 0.0°)
  R(Y) : -0.0    rad  (-0.0°)
  R(X) :  1.0472 rad  ( 60.0°)
```
"""
@inline function *(Θ₂::EulerAngles, Θ₁::EulerAngles)
    # Convert to quaternions, compute the composition, and convert back to Euler
    # angles.
    q₁ = angle_to_quat(Θ₁)
    q₂ = angle_to_quat(Θ₂)

    return quat_to_angle(q₁ * q₂, Θ₂.rot_seq)
end

"""
    inv(Θ::EulerAngles)

Return the Euler angles that represent the inverse rotation of `Θ`.

The rotation sequence of the result will be the inverse of the input. Hence, if
the input rotation sequence is, for example, `:XYZ`, then the result will be
represented using `:ZYX`.

# Examples

```julia-repl
julia> ea = EulerAngles(π / 3, π / 6,  2 / 3 * π, :ZYX)
EulerAngles{Float64}:
  R(Z) :  1.0472   rad  ( 60.0°)
  R(Y) :  0.523599 rad  ( 30.0°)
  R(X) :  2.0944   rad  ( 120.0°)

julia> inv(ea)
EulerAngles{Float64}:
  R(X) : -2.0944   rad  (-120.0°)
  R(Y) : -0.523599 rad  (-30.0°)
  R(Z) : -1.0472   rad  (-60.0°)
```
"""
function inv(Θ::EulerAngles)
    # Check what will be the inverse rotation.
    if Θ.rot_seq == :XYZ
        inv_rot_seq = :ZYX
    elseif Θ.rot_seq == :XZY
        inv_rot_seq = :YZX
    elseif Θ.rot_seq == :YXZ
        inv_rot_seq = :ZXY
    elseif Θ.rot_seq == :YZX
        inv_rot_seq = :XZY
    elseif Θ.rot_seq == :ZXY
        inv_rot_seq = :YXZ
    elseif Θ.rot_seq == :ZYX
        inv_rot_seq = :XYZ
    else
        inv_rot_seq = Θ.rot_seq
    end

    # Return the Euler angle that represented the inverse rotation.
    return EulerAngles(-Θ.a3, -Θ.a2, -Θ.a1, inv_rot_seq)
end

################################################################################
#                                      IO
################################################################################

function show(io::IO, Θ::EulerAngles{T}) where T
    # Get if `io` request a compact printing, defaulting to true.
    compact_printing = get(io, :compact, true)

    # Convert the values using `print` and compact printing.
    θ₁_str = sprint(print, Θ.a1; context = :compact => compact_printing)
    θ₂_str = sprint(print, Θ.a2; context = :compact => compact_printing)
    θ₃_str = sprint(print, Θ.a3; context = :compact => compact_printing)
    rot_seq = String(Θ.rot_seq)

    print(io, "EulerAngles{$T}:")
    print(io, " R($rot_seq)  " * θ₁_str * "  " * θ₂_str * "  " * θ₃_str * " rad")

    return nothing
end

function show(io::IO, mime::MIME"text/plain", Θ::EulerAngles{T}) where T
    # Check if the user wants colors.
    color = get(io, :color, false)::Bool

    # Check if the user wants compact printing, defaulting to `true`.
    compact_printing = get(io, :compact, true)::Bool

    # Assemble the context.
    context = IOContext(io, :color => color, :compact => compact_printing)

    d = color ? string(_d) : ""
    g = color ? string(_g) : ""
    y = color ? string(_y) : ""
    u = color ? string(_u) : ""

    # Convert the values using `print` and compact printing.
    θ₁_alg = !signbit(Θ.a1) ? " " : ""
    θ₁_str = θ₁_alg * sprint(print, Θ.a1; context = context)
    lθ₁ = length(θ₁_str)

    θ₂_alg = !signbit(Θ.a2) ? " " : ""
    θ₂_str = θ₂_alg * sprint(print, Θ.a2; context = context)
    lθ₂ = length(θ₂_str)

    θ₃_alg = !signbit(Θ.a3) ? " " : ""
    θ₃_str = θ₃_alg * sprint(print, Θ.a3; context = context)
    lθ₃ = length(θ₃_str)

    alignment_pad = max(lθ₁, lθ₂, lθ₃)

    θ₁_str *= " "^(alignment_pad - lθ₁) * " rad  (" *
        θ₁_alg * sprint(print, rad2deg(Θ.a1); context = context) * "°)"

    θ₂_str *= " "^(alignment_pad - lθ₂) * " rad  (" *
        θ₂_alg * sprint(print, rad2deg(Θ.a2); context = context) * "°)"

    θ₃_str *= " "^(alignment_pad - lθ₃) * " rad  (" *
        θ₃_alg * sprint(print, rad2deg(Θ.a3); context = context) * "°)"

    rot_seq = String(Θ.rot_seq)

    println(io, "EulerAngles{$T}:")
    println(io, "$g  R($(rot_seq[1])) : $d" * θ₁_str)
    println(io, "$y  R($(rot_seq[2])) : $d" * θ₂_str)
    print(io,   "$u  R($(rot_seq[3])) : $d" * θ₃_str)

    return nothing
end
