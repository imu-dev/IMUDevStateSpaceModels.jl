using Revise
using Pkg
Pkg.activate(joinpath(homedir(), ".julia", "dev", "IMUDevStateSpaceModels", "examples"))

using Distributions
using IMUDevStateSpaceModels
using LinearAlgebra
using Plots

function constant_acceleration_model(δt)
    F = [1.0 δt 0.5δt^2;
         0.0 1.0 δt;
         0.0 0.0 1.0]
    Q = [(δt^5)/20 (δt^4)/8 (δt^3)/6;
         (δt^4)/8 (δt^3)/3 (δt^2)/2;
         (δt^3)/6 (δt^2)/2 δt]

    H = [1.0 0.0 0.0;]
    R = [1.0;;]

    return LinGsnSSM(; F, Q, H, R)
end

model = constant_acceleration_model(0.01)
ℙx₀ = MvNormal(zeros(size(model, :state)), I)
num_samples = 10
num_timepoints = 100
x0s = rand(ℙx₀, num_samples)

# sample a single trajectory
underlying_state, obs = rand(model, rand(ℙx₀), num_timepoints)

# sample a batch of trajectories
xx, yy = rand(model, x0s, num_timepoints)

plot(trajectoryplot(0:num_timepoints, obs;
                    label="observations", seriestype=:scatter),
     trajectoryplot(0:num_timepoints, underlying_state;
                    label=["position" "velocity" "acceleration"]);
     size=(1200, 700),
     layout=grid(2, 1; heights=[0.25, 0.75]))
