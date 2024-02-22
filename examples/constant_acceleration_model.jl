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

model = constant_acceleration_model_3d(0.01)
ℙx₀ = MvNormal(zeros(size(model, :state)), I)
num_samples = 10
num_timepoints = 100
x0s = rand(ℙx₀, num_samples)

# sample a single trajectory
underlying_state, obs = rand(model, rand(ℙx₀), num_timepoints)

# sample a batch of trajectories
xx, yy = rand(model, x0s, num_timepoints)

plot(plot(0:num_timepoints,
          yy[1, :];
          title="observation", ylabel="position",
          label=""),
     plot(0:num_timepoints,
          xx[1, :];
          title="position",
          label=""),
     plot(0:num_timepoints,
          xx[2, :];
          label="", title="velocity"),
     plot(0:num_timepoints,
          xx[3, :];
          label="", title="acceleration",
          xlabel="time");
     size=(1200, 700),
     layout=(4, 1))