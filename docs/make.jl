using Documenter
using ReferenceFrameRotations

makedocs(
    format = :html,
    modules = [ReferenceFrameRotations],
    sitename = "Reference Frame Rotations",
    authors = "Ronan Arraes Jardim Chagas",
    pages = [
        "Home" => "index.md",
        "Euler Angle and Axis" => "man/euler_angle_axis.md",
        "Euler Angles" => "man/euler_angles.md",
        "Quaternions" => "man/quaternions.md",
        "Conversions" => "man/conversions.md",
        "Kinematics" => "man/kinematics.md",
        "Composing rotations" => "man/composing_rotations.md",
        "Inverting rotations" => "man/inv_rotations.md",
        "Library" => "lib/library.md",
    ],
    html_prettyurls = !("local" in ARGS),
)

deploydocs(
    repo = "github.com/JuliaSpace/ReferenceFrameRotations.jl.git",
    julia = "0.7",
    target = "build",
    deps = nothing,
    make = nothing,
)
