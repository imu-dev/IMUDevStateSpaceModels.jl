# Plotting

To plot sampled trajectories use:

```@docs
trajectoryplot
```

!!! warning
    Even though sampling can be done in batches, it is only possible to plot individual trajectories. You can however add trajectories to the existing plot with `trajectoryplot!`: trajectory of each state dimension will be added to its corresponding subplot.

## Example
Consider the example defined in the [Sampling](@ref) section. We can sample trajectories and plot them

```@setup plotting_example
using Distributions
using IMUDevStateSpaceModels
using LinearAlgebra

function constant_acceleration_model_2d(δt)
    F = [1.0 δt;
         0.0 1.0]
    Q = [(δt^3)/3 (δt^2)/2;
         (δt^2)/2 δt]

    H = [1.0 0.0;]
    R = [1.0;;]
    return LinGsnSSM(Float32; F, Q, H, R)
end

m = constant_acceleration_model_2d(0.01)
ℙx₀ = MvNormal(zeros(size(m, :state)), I)
num_timepoints = 100

# sample a single trajectory
xx_single, yy_single = rand(m, rand(ℙx₀), num_timepoints)

# sample a batch of trajectories
num_samples = 10
x0s = rand(ℙx₀, num_samples)
xx_batch, yy_batch = rand(m, x0s, num_timepoints)
```


```@example plotting_example
using Plots

# plot a single trajectory
trajectoryplot(xx_single;
               label=["acceleration" "velocity"],
               layout=(1, 2),
               size=(800, 300))
savefig("plotting_1.png"); nothing # hide
```

![](plotting_1.png)

We can also add error bands and another trajectory.

```@example plotting_example
# define some covariance matrices
# (they don't have any meaning in this context,
# just for demonstration purposes)
ΣΣ = Array{Float64}(undef, size(m, :state), size(m, :state), num_timepoints + 1)
for i in 0:num_timepoints
    ΣΣ[:, :, i + 1] = (1 + 0.1 * i) * diagm([1.0, 1.0])
end
ΣΣ
```

```@example plotting_example
# plot a single trajectory with uncertainty
p = trajectoryplot(0.01 .* (0:num_timepoints),
                   xx_single,
                   ΣΣ;
                   label=["acceleration" "velocity"],
                   layout=(1, 2),
                   size=(800, 300))
savefig("plotting_2.png"); nothing # hide
```

![](plotting_2.png)


```@example plotting_example
# add another trajectory to the existing plot
trajectoryplot!(p,
                0.01 .* (0:num_timepoints),
                xx_batch[:, 1, :];
                label=["acceleration 2" "velocity 2"])
savefig("plotting_3.png"); nothing # hide
```

![](plotting_3.png)