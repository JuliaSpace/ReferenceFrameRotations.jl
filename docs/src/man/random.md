# Random rotations

```@meta
CurrentModule = ReferenceFrameRotations
```

```@setup random
using ReferenceFrameRotations
```

Sometimes it is necessary to generate random rotations. For example, if you are testing a
stochastic system numerically, you need to perform a Monte Carlo simulation sampling the
initial conditions. **ReferenceFrameRotations.jl** defines a `rand` function for all rotation
representations. For all representations except `EulerAngles`, it samples a random rotation
uniformly in SO(3). `rand(EulerAngles)` instead samples each angular coordinate uniformly in
`[0, 2π)` and selects an axis sequence uniformly; this coordinate-wise distribution is not
uniform over SO(3).

```@repl random
rand(Quaternion)

rand(DCM)

rand(EulerAngles)

rand(EulerAngleAxis)

rand(CRP)

rand(MRP)
```
