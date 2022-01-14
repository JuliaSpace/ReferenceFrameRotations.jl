Random rotations
================

Sometimes it is necessary to generate random rotations. For example, if you are
testing a stochastic system numerically, you need to perform a Monte Carlo
simulation sampling the initial conditions. **ReferenceFrameRotations.jl**
defines `rand` function for all rotation representations, which samples a random
rotation.

```julia
julia> rand(Quaternion)
Quaternion{Float64}:
  + 0.389067 - 0.492496⋅i + 0.575012⋅j - 0.52482⋅k

julia> rand(DCM)
DCM{Float64}:
 -0.36924    0.92289   -0.109254
  0.490733   0.09379   -0.866247
 -0.789204  -0.373468  -0.487524

julia> rand(EulerAngles)
EulerAngles{Float64}:
  R(Y) :  3.94821 rad  ( 226.216°)
  R(X) :  5.86521 rad  ( 336.052°)
  R(Y) :  1.81531 rad  ( 104.01°)

julia> rand(EulerAngleAxis)
EulerAngleAxis{Float64}:
  Euler angle : 2.59925 rad  (148.926°)
  Euler axis  : [0.412508, 0.478338, 0.775261]
```
