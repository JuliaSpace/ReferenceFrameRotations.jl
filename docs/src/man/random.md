# Random rotations

```@meta
CurrentModule = ReferenceFrameRotations
```

```@setup random
using ReferenceFrameRotations
```

Sometimes it is necessary to generate random rotations. For example, if you are testing a
stochastic system numerically, you need to perform a Monte Carlo simulation sampling the
initial conditions. **ReferenceFrameRotations.jl** defines `rand` function for all rotation
representations, which samples a random rotation uniformly in SO(3).

```@repl random
rand(Quaternion)

rand(DCM)

rand(EulerAngles)

rand(EulerAngleAxis)

rand(CRP)

rand(MRP)
```
