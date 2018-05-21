using Documenter
using ReferenceFrameRotations

makedocs(
    format = :html,
    modules = [ReferenceFrameRotations],
    sitename = "Reference Frame Rotations",
    authors = "Ronan Arraes Jardim Chagas",
    pages = [
        "Home" => "index.md",
        "Euler Angle and Axis" => "euler_angle_axis.md",
        "Euler Angles" => "euler_angles.md",
        "Quaternions" => "quaternions.md",
        "Conversions" => "conversions.md",
        "Kinematics" => "kinematics.md",
        "Composing rotations" => "composing_rotations.md",
        "Library" => "lib.md",
    ],
)

deploydocs(
    repo = "github.com/SatelliteToolbox/ReferenceFrameRotations.jl.git",
    julia = "0.6",
    target = "build",
    deps = nothing,
    make = nothing,
)
