# Sampling

It is possible to sample trajectories of any fully defined `StateSpaceModel`. This can be done either in-place, or out-of-place:

```@docs
IMUDevStateSpaceModels.Random.rand!
IMUDevStateSpaceModels.Random.rand
```

The trajectories can be sampled either individually or in batches—the appropriate mode will be inferred from the dimension of the state space array `x0`. For in-place computations the number of timepoints (`num_obs`) will be inferred from the size of the output containers.

Out-of-place sampling will always return the sampled underlying state `xx` together with the observations `yy`.

For in-place sampling the underlying state can be discarded by passing only a container intended to store the observations `yy`.

## Example

In the following example we first show how to sample a single trajectory and then a batch of trajectories.

```@example sampling_example
using Distributions
using IMUDevStateSpaceModels
using LinearAlgebra

function constant_acceleration_model_2d(δt)
    # time-evolution of acceleration & velocity
    F = [1.0 δt;
         0.0 1.0]
    Q = [(δt^3)/3 (δt^2)/2;
         (δt^2)/2 δt]

    H = [1.0 0.0;]
    R = [1.0;;]
    return LinGsnSSM(Float32; F, Q, H, R)
end

m = constant_acceleration_model_2d(0.01)
```

```@example sampling_example
ℙx₀ = MvNormal(zeros(size(m, :state)), I)
num_timepoints = 100

# sample a single trajectory
xx_single, yy_single = rand(m, rand(ℙx₀), num_timepoints)
```


```@example sampling_example
# sample a batch of trajectories
num_samples = 10
x0s = rand(ℙx₀, num_samples)
xx_batch, yy_batch = rand(m, x0s, num_timepoints)
```
