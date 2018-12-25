using Documenter
using ReferenceFrameRotations

makedocs(
    modules = [ReferenceFrameRotations],
    format = Documenter.HTML(
        prettyurls = !("local" in ARGS),
        canonical = "https://juliaspace.github.io/ReferenceFrameRotations.jl/stable/",
    ),
    sitename = "Reference Frame Rotations",
    authors = "Ronan Arraes Jardim Chagas",
    pages = [
        "Home" => "index.md",
        "Direction Cosine Matrices" => "man/dcm.md",
        "Euler Angle and Axis" => "man/euler_angle_axis.md",
        "Euler Angles" => "man/euler_angles.md",
        "Quaternions" => "man/quaternions.md",
        "Conversions" => "man/conversions.md",
        "Kinematics" => "man/kinematics.md",
        "Composing rotations" => "man/composing_rotations.md",
        "Inverting rotations" => "man/inv_rotations.md",
        "Library" => "lib/library.md",
    ],
)

deploydocs(
    repo = "github.com/JuliaSpace/ReferenceFrameRotations.jl.git",
    target = "build",
)
