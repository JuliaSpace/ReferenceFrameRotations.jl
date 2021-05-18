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

```julia-repl
julia> ea1 = EulerAngles(deg2rad(35), 0, 0, :XYZ)
EulerAngles{Float64}:
  R(X):   0.6109 rad (  35.0000 deg)
  R(Y):   0.0000 rad (   0.0000 deg)
  R(Z):   0.0000 rad (   0.0000 deg)

julia> ea2 = EulerAngles(0, 0, deg2rad(25), :ZYX)
EulerAngles{Float64}:
  R(Z):   0.0000 rad (   0.0000 deg)
  R(Y):   0.0000 rad (   0.0000 deg)
  R(X):   0.4363 rad (  25.0000 deg)

julia> ea2 * ea1
EulerAngles{Float64}:
  R(Z):   0.0000 rad (   0.0000 deg)
  R(Y):  -0.0000 rad (  -0.0000 deg)
  R(X):   1.0472 rad (  60.0000 deg)
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
    str     = @sprintf "%8.4f %8.4f %8.4f rad" Θ.a1 Θ.a2 Θ.a3
    rot_seq = String(Θ.rot_seq)

    print(io, "EulerAngles{$T}:")
    print(io,   " R($rot_seq): " * str)

    return nothing
end

function show(io::IO, mime::MIME"text/plain", Θ::EulerAngles{T}) where T
    # Check if the user wants colors.
    color = get(io, :color, false)

    d = (color) ? _d : ""
    g = (color) ? _g : ""
    y = (color) ? _y : ""
    u = (color) ? _u : ""

    str_θ₁  = @sprintf "%8.4f rad (%9.4f deg)" Θ.a1 rad2deg(Θ.a1)
    str_θ₂  = @sprintf "%8.4f rad (%9.4f deg)" Θ.a2 rad2deg(Θ.a2)
    str_θ₃  = @sprintf "%8.4f rad (%9.4f deg)" Θ.a3 rad2deg(Θ.a3)
    rot_seq = String(Θ.rot_seq)

    println(io, "EulerAngles{$T}:")
    println(io,   "$g  R($(rot_seq[1])): $d" * str_θ₁)
    println(io,   "$y  R($(rot_seq[2])): $d" * str_θ₂)
      print(io,   "$u  R($(rot_seq[3])): $d" * str_θ₃)

    return nothing
end
