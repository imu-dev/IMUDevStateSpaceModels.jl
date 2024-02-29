# Plotting

To plot sampled trajectories use:

```@docs
trajectoryplot
```

!!! warning
    Even though sampling can be done in batches, it is only possible to plot individual trajectories. You can however add trajectories to the existing plot with `trajectoryplot!`: trajectory of each state dimension will be added to its corresponding subplot.

## Example
Consider the example defined in the [Sampling](@ref) section. We can sample trajectories and plot them

```julia
using Plots

# plot a single trajectory
trajectoryplot(xx_single;
               label=["acceleration" "velocity"],
               layout=(1, 2),
               size=(800, 300))
```

We can also add error bands and another trajectory.

```julia
using Plots

# define some covariance matrices
# (they don't have any meaning in this context,
# just for demonstration purposes)
ΣΣ = Array{Float64}(undef, size(m, :state), size(m, :state), num_timepoints + 1)
for i in 0:num_timepoints
    ΣΣ[:, :, i + 1] = (1 + 0.1 * i) * diagm([1.0, 1.0])
end

# plot a single trajectory with uncertainty
p = trajectoryplot(0.01 .* (0:num_timepoints),
                   xx_single,
                   ΣΣ;
                   label=["acceleration" "velocity"],
                   layout=(1, 2),
                   size=(800, 300))

# add another trajectory to the existing plot
trajectoryplot!(p,
                0.01 .* (0:num_timepoints),
                xx_batch[:, 1, :];
                label=["acceleration 2" "velocity 2"])
```