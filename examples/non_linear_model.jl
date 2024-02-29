# An example of a StateSpaceModel with a non-linear state transition function,
# a non-linear observation function and non-Gaussian noise.
using Pkg
Pkg.activate(joinpath(homedir(), ".julia", "dev", "IMUDevStateSpaceModels", "examples"))

using Distributions
using IMUDevStateSpaceModels
using Plots

const SSMs = IMUDevStateSpaceModels

"""
    MyNonLinearStateSpaceModel()

State space model with double-well type transition function, non-linear
observation operator and non-Gaussian noise, given by:

    x_{k+1} = x_k - θ(x_k)^2((x_k)^2 - μ) + σ_k,    σ_k ∼ Cauchy(x₀, γ),
    y_k     = ceil(x_k)              + ν_k,    ν_k ∼ Poisson(λ)
"""
struct MyNonLinearStateSpaceModel <: StateSpaceModel{Float64}
    θ::Float64
    μ::Float64
    x₀::Float64
    γ::Float64
    λ::Int64
end

const MySSM = MyNonLinearStateSpaceModel

Base.size(::MySSM, ::Union{Val{:state}}) = 1
Base.size(::MySSM, ::Union{Val{:observation},Val{:obs}}) = 1
SSMs.state_noise(m::MySSM) = Product([Cauchy(m.x₀, m.γ)])
SSMs.observation_noise(m::MySSM) = Product([Poisson(m.λ)])

SSMs.state_transition(x, m::MySSM) = x - m.θ .* x .* (x .^ 2 .- m.μ)
SSMs.observation_emission(x, ::MySSM) = ceil.(x)

model = MySSM(0.01, 1.0, 0.0, 0.001, 1)

x₀ = [1.0]
num_timepoints = 100
xx, yy = rand(model, x₀, num_timepoints)

plot(trajectoryplot(0:num_timepoints, yy; seriestype=:scatter, label="",
                    title="Observations"),
     trajectoryplot(0:num_timepoints, xx; seriestype=:scatter, label="",
                    title="Underlying state"))
