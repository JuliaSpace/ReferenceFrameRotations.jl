ReferenceFrameRotations.jl Changelog
====================================

Version 0.2.0
-------------

- Performance improvements:
    * The Direction Cosine Matrices were converted from `Matrix` to
      `SMatrix{3,3}`. This provided a huge performance boost, but now the DCM
      is immutable.
    * The Quaternions, Euler Angles, and Euler Angle and Axis representations
      were also converted to immutable types.

- New:
    * It is now possible to create Direction Cosine Matrices and Quaternions
      that represent small rotations using the functions `smallangle2dcm` and
      `smallangle2quat`.
    * The function `angle2quat` can now be called using `EulerAngles` as
      argument.
    * A set of rotations described by Direction Cosine Matrices or Quaternions
      can now be composed using the function `compose_rotation`. The input is
      the rotations in the desired order (from the first to the last).
    * `angle2rot` and `smallangle2rot` are two functions that can be used to
      create rotations descriptions from Euler angles based on the type of the
      arguments.

- Changes:
    * The rotations sequences are now described by symbols instead of strings.
      Hence, `"ZYX"` was replaced by `:ZYX`, `"XYZ"` by `:XYZ`, `'x'` or `'X'`
      by `:X` and so on.
    * Due to the new type of DCMs, they now must be initialized using the type
      `DCM`. Hence, `dcm = [1 0 0; 0 -1 0; 0 0 -1]` must be replaced by
      `dcm = DCM([1 0 0; 0 -1 0; 0 0 -1])`.
    * The `RotationSequenceError` exception were removed and replaced by
      `ArgumentError` with a useful error message.

- Dropped functions:
    * `<Function>!`: All functions that modifies a parameter (the ones that end
      with `!`) were dropped because now all the types are immutables.

Version 0.1.0
-------------

- Initial version.
    * This version was based on the old package **Rotations.jl v0.4.0** that
      was renamed to **ReferenceFrameRotations** to be submitted to julia
      METADATA repo.
