using Documenter
using ReferenceFrameRotations

DocMeta.setdocmeta!(
    ReferenceFrameRotations,
    :DocTestSetup,
    :(using ReferenceFrameRotations);
    recursive=true
)

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
        "Classical Rodrigues Parameters" => "man/crp.md",
        "Direction Cosine Matrices" => "man/dcm.md",
        "Euler Angle and Axis" => "man/euler_angle_axis.md",
        "Euler Angles" => "man/euler_angles.md",
        "Modified Rodrigues Parameters" => "man/mrp.md",
        "Quaternions" => "man/quaternions.md",
        "Conversions" => "man/conversions.md",
        "Kinematics" => "man/kinematics.md",
        "Composing rotations" => "man/composing_rotations.md",
        "Inverting rotations" => "man/inv_rotations.md",
        "Random rotations" => "man/random.md",
        "Library" => "lib/library.md",
    ],
)

deploydocs(
    repo = "github.com/JuliaSpace/ReferenceFrameRotations.jl.git",
    target = "build",
)
