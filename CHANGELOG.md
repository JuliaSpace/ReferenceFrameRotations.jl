ReferenceFrameRotations.jl Changelog
====================================

Version 0.4.1
-------------

- ![Enhancement][badge-enhancement] The operation `\` between Quaternions and
  Vector now supports every `AbstractVector`.
- ![Enhancement][badge-enhancement] The `EulerAngleAxis` now stores the vector
  `v` using `SVector` instead of `Vector`. Notice that the constructors were
  adapted to accept all `AbstractVector`. Hence, it is not expected any
  breakage in old code.
- ![Bugfix][badge-bugfix] The conversion between `Quaternion` and
  `EulerAngleAxis` now checks if the Euler angle is 0. In this case, the Euler
  vector `[1;0;0]` is used. Previously, a vector with `NaN` was returned.

Version 0.4.0
-------------

- ![BREAKING][badge-breaking] The function `dcm2quat` forced the returned
  Quaternion to be of the same type of DCM. However, since some floating-point
  operations are required to convert between these two rotation representation,
  then it could lead to `InexactError` exception. Old code that depends on the
  quaternion type returned from `dcm2quat` may break.
- ![BREAKING][badge-breaking] `DCM{T}` was defined as `SMatrix{3,3,T}`. However,
  this can lead to type-unstable functions in some cases. Hence, the definition
  was changed to `SMatrix{3,3,T,9}`. Code using `DCM{T}` will continue to work
  without problems.
- ![Deprecation][badge-deprecation] The function `eye` has been marked as
  deprecated in favor of the initialization using the `UniformScalling` (`I`)
  object.
- ![Bugfix][badge-bugfix] The `norm` function was not being exported.
- ![Feature][badge-feature] The left and right division operations between two
  quaternions was defined. Hence, the operation `inv(q)*v*q` can be now written
  in the more compact form `q\v*q`.
- ![Enhancement][badge-enhancement] DCMs and Quaternions now fully support the
  `UniformScalling` object for initialization and operations. Hence, an identity
  DCM can be created using `DCM(I)` and an identity quaternion can be created
  using `Quaternion(I)`.
- ![Enhancement][badge-enhancement] The structures and operations no longer
  restrict the type of the rotation representation to be real numbers. Hence, it
  is now possible to perform, for example, the multiplication between two
  integer quaternions.  The type of the result will be automatically inferred.
- ![Info][badge-info] The package is not tested against Julia 0.7 anymore.
  Although it is still supposed to work with Julia 0.7, it is **highly**
  advisable to use Julia 1.0 or higher.
- ![Info][badge-info] The documentation of the functions was modified to be less
  verbose.

Version 0.3.0
-------------

- Full support for `Julia 0.7` and `Julia 1.0`.
    * The support for `Julia <= 0.6` is dropped in this version. Hence,
      ReferenceFrameRotations.jl **will not** work with those versions anymore.
      If it is necessary to use `Julia <= 0.6`, then you should need to stick
      with `ReferenceFrameRotations.jl <= 0.2.1`.

Version 0.2.1
-------------

- Performance improvements:
    * `eye` and `zeros` functions are `@inline` now.

- Tests:
    * Add new tests to increase coverage.

- Documentation:
    * Initial version of the package documentation.

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
    * `inv_rotation` is a new function that can be used to compute inverse
      rotations. It can receive as input a Direction Cosine Matrix or a
      Quaternion.

- Changes:
    * The rotations sequences are now described by symbols instead of strings.
      Hence, `"ZYX"` was replaced by `:ZYX`, `"XYZ"` by `:XYZ`, `'x'` or `'X'`
      by `:X`, and so on.
    * Due to the new type of DCMs, they now must be initialized using the type
      `DCM`. Hence, `dcm = [1 0 0; 0 -1 0; 0 0 -1]` must be replaced by
      `dcm = DCM([1 0 0; 0 -1 0; 0 0 -1])`.
    * The `RotationSequenceError` exception were removed and replaced by
      `ArgumentError` with a useful error message.
    * The function `angle2quat` was modified so that the real part of the
      quaternion is always positive.

- Dropped functions:
    * `<Function>!`: All functions that modify a parameter (the ones that end
      with `!`) were dropped because now all the types are immutables.

Version 0.1.0
-------------

- Initial version.
    * This version was based on the old package **Rotations.jl v0.4.0** that
      was renamed to **ReferenceFrameRotations** to be submitted to julia
      METADATA repo.

[badge-breaking]: https://img.shields.io/badge/BREAKING-red.svg
[badge-deprecation]: https://img.shields.io/badge/Deprecation-orange.svg
[badge-feature]: https://img.shields.io/badge/Feature-green.svg
[badge-enhancement]: https://img.shields.io/badge/Enhancement-blue.svg
[badge-bugfix]: https://img.shields.io/badge/Bugfix-purple.svg
[badge-info]: https://img.shields.io/badge/Info-gray.svg
