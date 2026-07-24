# Repository Guide

## Package Structure

- Treat this repository as a single Julia package. Requires Julia 1.10 or newer.
- Use `src/ReferenceFrameRotations.jl` as the package entrypoint.
- Preserve the include order: types; angle/angle-axis; composition/DCM/inversion/random; quaternion/CRP/MRP/shadow; deprecations; conversions.
- Add methods only after their dependencies and preserve the existing include order.
- Use `ext/ReferenceFrameRotationsZygoteExt.jl` only when both ForwardDiff and Zygote are present; that is when the extension activates.
- Add tests to files explicitly included from `test/runtests.jl`; adding a test file alone does not run it.
- Use the test extras and targets declared in `Project.toml`: Test, DifferentiationInterface, FiniteDiff, StableRNGs, and Zygote.

## Commands

- Instantiate with `julia --project=. -e 'using Pkg; Pkg.instantiate()'`.
- Run the full local CI-equivalent suite with `julia --project=. -e 'using Pkg; Pkg.test()'`.
- Allow generous time for first-run dependency installation and precompilation.
- Do not recommend the direct runtests command as a focused route because test extras may be unavailable outside the package test environment.
- Treat CI's Julia buildpkg-then-runtest flow as equivalent to local `Pkg.test()`.
- Build documentation with `julia --project=docs docs/make.jl`.
- Format with `julia -e 'using JuliaFormatter; format(".")'` after installing JuliaFormatter in the active tooling environment.
- Optionally verify formatting with `git diff --exit-code` after formatting.
- Account for CI coverage on Julia 1.10 and current stable Julia across supported Ubuntu, macOS, and Windows architectures, with a nightly equivalent.

## Code Style

- Treat `.JuliaFormatter.toml` as the source of truth; it configures JuliaFormatter BlueStyle.
- Preserve generic numeric types, static arrays, allocation expectations, optional differentiability, deprecation behavior, and Base and LinearAlgebra semantics.

## Behavioral Constraints

- Preserve the package's 3D rotation scope and use radians for angles.
- Keep quaternion components scalar-first as q0 q1 q2 q3.
- Preserve fixed-size static 3x3 DCMs.
- Preserve the default Euler axes Symbol `:ZYX` and the constraints on valid Euler axis sequences.
- Preserve composition ordering and frame conventions.
- Account for `shadow_rotation` when working with MRPs.

## Not Configured

- Do not look for or add a Makefile or `deps/build.jl`; neither exists or is configured.
- Do not expect a configured linter, precommit hook, or formatter CI.
