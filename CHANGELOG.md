ReferenceFrameRotations.jl Changelog
====================================

Version 3.5.0
-------------

- ![BREAKING][badge-breaking] The compact `show` of `CRP` and `MRP` now prints the sign of
  each component. Previously, it printed the absolute values, so two different rotations
  produced identical output.
- ![BREAKING][badge-breaking] `Quaternion(u::UniformScaling, q::Quaternion)` now uses `u.λ`
  as the real part, as documented, instead of always returning the identity quaternion.
- ![BREAKING][badge-breaking] Composing two `MRP`s that yield a 360° rotation now throws an
  `ArgumentError`, matching the `CRP` behavior, instead of silently returning `NaN`.
- ![Feature][badge-feature] Add `angleaxis_to_crp` and `angleaxis_to_mrp`, completing the
  conversion matrix.
- ![Feature][badge-feature] `compose_rotation` now supports heterogeneous tuples and vectors
  of rotations, which previously threw a `MethodError`. Such collections are folded with
  `∘`, so the output has the type of the last rotation.
- ![Feature][badge-feature] Add `hash` and `isequal` for `Quaternion`, `CRP`, and `MRP`, so
  that they behave correctly as `Set` elements and `Dict` keys.
- ![Bugfix][badge-bugfix] `dcm_to_angleaxis` returned a reflected axis for 180° rotations
  whose axis had a vanishing first component, and lost up to eight significant digits for
  angles near `π`. It is now computed through the quaternion representation, which is well
  conditioned everywhere.
- ![Bugfix][badge-bugfix] `quat_to_angleaxis` and `*(::EulerAngleAxis, ::EulerAngleAxis)`
  now recover the rotation angle with `atan` instead of `acos`, removing a relative error of
  up to `1e-2` for small angles and the hard truncation to zero below `~1e-7` rad.
- ![Bugfix][badge-bugfix] `q / λ` is now computed componentwise instead of as `q * (1 / λ)`,
  which rounded twice.
- ![Bugfix][badge-bugfix] `inv(::EulerAngleAxis)` now computes `2π` at the output precision,
  preserving `BigFloat` accuracy.
- ![Bugfix][badge-bugfix] `smallangle_to_dcm` now has a return type that does not depend on
  the runtime value of the `normalize` keyword.
- ![Bugfix][badge-bugfix] The one- and two-rotation forms of `angle_to_dcm` now accept
  `Irrational` angles, matching the three-rotation form.
- ![Bugfix][badge-bugfix] Quaternion constructors, products, kinematics, `ddcm`, and the
  Euler angle-axis conversions now respect the indexing conventions of the input vector,
  supporting offset arrays.
- ![Bugfix][badge-bugfix] `*(q, v)`, `*(v, q)`, and `v \ q` now validate that the vector has
  three components, and `v \ q` treats `v` as the vectorial part, as documented.
- ![Bugfix][badge-bugfix] The Zygote rule for the `DCM` constructor no longer errors when
  the output cotangent is a zero tangent.
- ![Enhancement][badge-enhancement] Add a precompilation workload, reducing the measured
  first-call latency of the common operations from about 1070 ms to about 10 ms.
- ![Enhancement][badge-enhancement] `rand(R, dims)` now returns a concrete-eltype array for
  the unparameterized rotation types instead of a boxed, abstract-eltype array.
- ![Enhancement][badge-enhancement] Hoist the repeated divisions in `crp_to_dcm`,
  `mrp_to_dcm`, and `dcm_to_quat`.
- ![Enhancement][badge-enhancement] Convert `EulerAngleAxis` to `CRP`/`MRP` through the
  quaternion instead of the DCM.
- ![Info][badge-info] The Zygote extension is no longer triggered by `ForwardDiff`, which it
  never used.
- ![Info][badge-info] Fix incorrect docstrings, rotted examples, wrong comments, and typos
  throughout the package, and convert the remaining `julia-repl` blocks to `jldoctest` so
  that CI verifies them.

Version 3.4.0
-------------

- ![Feature][badge-feature] Add allocation-free tuple and vector overloads to
  `compose_rotation` for long homogeneous rotation chains.
- ![Enhancement][badge-enhancement] Reduce Euler-to-CRP/MRP and CRP/MRP conversion work and
  eliminate dynamic-vector allocation in angle-axis-to-quaternion conversion.
- ![Enhancement][badge-enhancement] Replace the full-Jacobian Zygote rule for DCM
  orthonormalization with an analytic, allocation-free static-vector pullback.
- ![Bugfix][badge-bugfix] Honor concrete scalar target types in the conversion API and
  preserve the documented first-operand type in mixed-representation composition.
- ![Bugfix][badge-bugfix] Stabilize DCM and quaternion angle conversions for integer,
  rational, floating-point, and `BigFloat` inputs.
- ![Bugfix][badge-bugfix] Canonicalize the quaternion scalar component to positive zero for
  exact half-turn DCMs.
- ![Bugfix][badge-bugfix] Validate that quaternion vector constructors receive exactly the
  required number of components.
- ![Bugfix][badge-bugfix] Define zero-MRP shadow conversion as a `DomainError` and eliminate
  its redundant square root for nonzero inputs.
- ![Bugfix][badge-bugfix] Scale CRP composition singularity checks according to scalar
  precision and product magnitude.
- ![Bugfix][badge-bugfix] Stabilize Euler angle-axis composition near identity rotations and
  across mixed scalar types.
- ![Bugfix][badge-bugfix] Preserve Zygote gradients through same- and cross-precision DCM
  conversions.
- ![Info][badge-info] Clarify inverse-rotation normalization requirements and rotation
  terminology throughout the documentation.
- ![Info][badge-info] Clarify that random Euler angles sample coordinates rather than
  rotations uniformly over SO(3).

Version 3.3.0
-------------

- ![Enhancement][badge-enhancement] Eliminate intermediate construction in DCM
  orthonormalization.
- ![Enhancement][badge-enhancement] Improve inference for fixed Euler-sequence
  conversions.
- ![Enhancement][badge-enhancement] Add benchmarks and allocation/inference performance
  contracts.
- ![Bugfix][badge-bugfix] Harden DCM-to-Euler conversion near singularities.
- ![Info][badge-info] Strengthen inverse-rotation property coverage.

Version 3.2.0
-------------

- ![Feature][badge-feature] The package now supports the Classical Rodrigues Parameter (CRP)
  and the Modified Rodrigues Parameter (MRP). (PR [#36][gh-pr-36])

Version 3.1.2
-------------

- ![Bugfix][badge-bugfix] Fix CI in nightly. (PR [#34][gh-pr-34])
- ![Enhancement][badge-enhancement] The Zygote extension was modified to handle thunks. (PR
  [#35][gh-pr-35])

Version 3.1.1
-------------

- ![Bugfix][badge-bugfix] Some compat bounds were not correctly set. (Issue
  [#32][gh-issue-32])

Version 3.1.0
-------------

- ![Feature][badge-feature] The package now has a Zygote extension allowing for
  differentiation of DCMs. (PR [#28][gh-pr-28])
- ![Deprecation][badge-deprecation] We dropped support for Julia 1.6.

Version 3.0.2
-------------

- ![Enhancement][badge-enhancement] Improve some docstrings.

Version 3.0.1
-------------

- ![Enhancement][badge-enhancement] Documentation update.

Version 3.0.0
-------------

- ![BREAKING][badge-breaking] Julia 1.0 is not supported anymore.
- ![BREAKING][badge-breaking] `DCM` is now a custom type derived from
  `StaticMatrix`. Since it was previously a `SMatrix{3, 3, T, 9}`, then this
  modification must be considered breaking. However, all the API was implemented
  so that everything is supposed to continue working besides some initialization
  functions. (Issue [#21][gh-issue-21]).
- ![Bugfix][badge-bugfix] The function `eltype` was not returning the correct
  value for `EulerAngles` and `EulerAngleAxis`.
- ![Feature][badge-feature] The Julia conversion API `convert` is now supported
  to convert between any of the supported representations. (Issue
  [#18][gh-issue-18]) (PR [#19][gh-pr-19])
- ![Feature][badge-feature] A random rotation can now be sampled using `rand`.
  This feature is supported for all representations.
- ![Feature][badge-feature] The operator `∘` can now be used to compose
  rotations. In this case, if two different representations are used, the one in
  the right is converted to the same type to the one in the left.
- ![Feature][badge-feature] A new constant called `ReferenceFrameRotation` is
  now exported as a union of all the supported rotations.
  ![Enhancement][badge-enhancement] The test coverage was improved, reaching
  almost 100% of coverage.

Version 2.0.0
-------------

- ![BREAKING][badge-breaking] Previously, `Quaternion` was `<:AbstractVector`.
  However, this choice was leading to many problems when interfacing with other
  packages. For example, it was very difficult to make it works together with
  Zygote.jl because of the multiplication. In the previous version, `Quaternion`
  was an array in which the multiplication `q1 * q2` (both 4x1 arrays) leads to
  another 4x1 arrays, breaking a lot of assumptions about arrays. Many functions
  were defined to reduce the number of breakage. Quaternion supports iterations
  and broadcast. Hence, I do not expect many problems.
- ![Deprecation][badge-deprecation] The function `zeros` for `Quaternion` is now
  deprecated. Use `zero` instead.
- ![Deprecation][badge-deprecation] The function `create_rotation_matrix` is now
  deprecated. Use `angle_to_dcm` instead.
- ![Feature][badge-feature] The function `angle_to_dcm` can now create a DCM
  from a single rotation.
- ![Feature][badge-feature] The function `angle_to_quat` can now create a
  quaternion from a single rotation.
- ![Feature][badge-feature] The function `angle_to_rot` can now create a
  rotation from a single rotation.
- ![Feature][badge-feature] The functions `zero` and `one` are now defined for
  `Quaternion`.
- ![Enhancement][badge-enhancement] Many improvements related to the type
  promotion in the functions.

Version 1.0.1
-------------

- ![Bugfix][badge-bugfix] The display function of quaternions was showing `q2`
  instead of `q3`.

Version 1.0.0
-------------

The following rotation representations and the conversion between them are now
considered stable:

* Direction cosine matrix (DCM);
* Euler angle and axis;
* Euler angles; and
* Quaternion.

- ![Enhancement][badge-enhancement] The printing of Euler angle and axis, Euler
  angles, and quaternion were improved. Everything is now printed with context
  `:compact => true`, and can be changed using `IOContext`.
- ![Enhancement][badge-enhancement] The tests were entirely redesigned, leading
  to 100% of coverage.
- ![Enhancement][badge-enhancement] The code now follows the
  [BlueStyle](https://github.com/invenia/BlueStyle).
- ![Deprecation][badge-deprecation] All deprecated functions in v0.4 were
  removed.

Version 0.5.7
-------------

- ![Enhancement][badge-enhancement] The compat bounds were updated.

Version 0.5.6
-------------

- ![Bugfix][badge-bugfix] The operation `-(::Quaternion)` is now defined.
- ![Info][badge-info] The package is now tested only against Julia 1.0 and 1.5.

Version 0.5.5
-------------

- ![Enhancement][badge-enhancement] Quaternion now supports scalar indexing.
  This forced `Quaternion` to be a subtype of `AbstractVector`. Thus, it can now
  be broadcasted to a vector without any allocations.
- ![Info][badge-info] The package is now tested only against Julia 1.0 and 1.4.

Version 0.5.4
-------------

- ![Enhancement][badge-enhancement] Improvements in the documentation of
  functions and macros.
- ![Info][badge-info] The package is now tested only against Julia 1.0 and 1.3.

Version 0.5.3
-------------

- ![Enhancement][badge-enhancement] It is not necessary to use `sprint` to
  create the color sequences when using
  [Crayons.jl](https://github.com/KristofferC/Crayons.jl).

Version 0.5.2
-------------

- Dummy release to add `Project.toml` and switch to
  [Registrator.jl](https://github.com/JuliaComputing/Registrator.jl).

Version 0.5.1
-------------

- ![Bugfix][badge-bugfix] The conversion from DCM to Euler Angle and Axis had a
  bug when an identity DCM was being used. In this case, the returned axis was
  `[NaN, NaN, NaN]`, when the correct is `[0, 0, 0]`.
- ![Enhancement][badge-enhancement] The test coverage was highly improve,
  reaching more than 97% of the code.
- ![Enhancement][badge-enhancement] All the colors in printing functions are now
  handled by the package
  [Crayons.jl](https://github.com/KristofferC/Crayons.jl).

Version 0.5.0
-------------

- ![BREAKING][badge-breaking] The function `smallangle_to_dcm` now returns a
  orthornormalized DCM by default. This behavior can be modified by the keyword
  `normalize`.
- ![Deprecation][badge-deprecation] The nomenclature of all conversion functions
  was changed from `<representation 1>2<representation 2>` to
  `<representation 1>_to_<representation 2>`. Hence, for example, `angle2dcm` is
  now called `angle_to_dcm`. All the older names are now deprecated.
- ![Bugfix][badge-bugfix] Many bugs were fixed in the conversion from DCM to
  Euler angles related to singularities, gimbal-locks, multiple representations,
  and signed zeros.
- ![Bugfix][badge-bugfix] When converting from Euler angle and axis to
  quaternion, the real part will always be positive now.
- ![Feature][badge-feature] The operations `*` and `inv` with `EulerAngles` are
  now defined.
- ![Feature][badge-feature] The operations `*` and `inv` with `EulerAngleAxis`
  are now defined.
- ![Feature][badge-feature] The conversion functions between DCM and Euler angle
  and axis were added (`angleaxis_to_dcm` and `dcm_to_angleaxis`).
- ![Feature][badge-feature] `EulerAngles` and `EulerAngleAxis` structures now
  have a dedicated printing function.
- ![Feature][badge-feature] The conversion functions between Euler angle and
  axis and Euler angles were added (`angleaxis_to_angle` and
  `angle_to_angleaxis`).
- ![Feature][badge-feature] The function `orthonormalize`, which orthonormalizes
  DCMs using the Gram-Schmidt algorithm, was added.
- ![Feature][badge-feature] The function `angle_to_angle` was added to modify
  the rotation sequence of Euler angles.
- ![Enhancement][badge-enhancement] Many performance improvements.
- ![Enhancement][badge-enhancement] Improvements in the printing function of
  quaternions.
- ![Enhancement][badge-enhancement] The API functions `inv_rotation` and
  `compose_rotation` now support all the representations (DCM, Euler angle and
  axis, Euler angles, and quaternions).
- ![Enhancement][badge-enhancement] A new, more general constructor for
  `EulerAngles` was added.

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

[badge-breaking]: https://img.shields.io/badge/Breaking-DC2626?style=flat-square
[badge-deprecation]: https://img.shields.io/badge/Deprecation-D97706?style=flat-square
[badge-feature]: https://img.shields.io/badge/Feature-16A34A?style=flat-square
[badge-enhancement]: https://img.shields.io/badge/Enhancement-0284C7?style=flat-square
[badge-bugfix]: https://img.shields.io/badge/Bugfix-DB2777?style=flat-square
[badge-info]: https://img.shields.io/badge/Info-475569?style=flat-square

[gh-issue-18]: https://github.com/JuliaSpace/ReferenceFrameRotations.jl/issues/18
[gh-issue-21]: https://github.com/JuliaSpace/ReferenceFrameRotations.jl/issues/21
[gh-issue-32]: https://github.com/JuliaSpace/ReferenceFrameRotations.jl/issues/32

[gh-pr-19]: https://github.com/JuliaSpace/ReferenceFrameRotations.jl/pull/19
[gh-pr-28]: https://github.com/JuliaSpace/ReferenceFrameRotations.jl/pull/28
[gh-pr-34]: https://github.com/JuliaSpace/ReferenceFrameRotations.jl/pull/34
[gh-pr-35]: https://github.com/JuliaSpace/ReferenceFrameRotations.jl/pull/35
[gh-pr-36]: https://github.com/JuliaSpace/ReferenceFrameRotations.jl/pull/36
