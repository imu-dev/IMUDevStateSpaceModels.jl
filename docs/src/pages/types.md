# State Space Models

## Interface

All State Space Models defined in this package must adhere to the interface defined by the `StateSpaceModel` below.

```@docs
StateSpaceModel
```

The Julia type used for representation of the state and observation spaces should be known at compile time:

```@docs
Base.eltype(::StateSpaceModel)
```

!!! note
    Note however, that this does not necessarily prevent auto-promotion of variables. For instance, if [`state_transition`](@ref) below was called on a `StateSpaceModel` with `Float32` eltype and a [DualNumber](https://github.com/JuliaDiff/DualNumbers.jl) `Dual{Float32}`, we would still expect each dimension of the state to be auto-promoted to `Dual{Float32}`.

### Functions that must be implemented

Each concrete implementation of [`StateSpaceModel`](@ref) must implement the following functions defining its dynamics:

```@docs
state_transition
observation_emission
state_noise(m::StateSpaceModel)
observation_noise(m::StateSpaceModel)
```

As well as functions defining the size of its state space and observation space.

```@docs
Base.size(m::StateSpaceModel)
Base.size(m::StateSpaceModel, s::Symbol)
```

### Functions that will work out of the box

Based on these 6 definitions (4 dynamics definitions and 2 size definitions) the following evolution function will work out of the box:

```@docs
IMUDevStateSpaceModels.step
```

Under the hood it will call these two functions:

```@docs
IMUDevStateSpaceModels.state_step
IMUDevStateSpaceModels.obs_step
```

## Gaussian State Space Models

Abstract type that defines the type of state and observation noise to be Gaussian. Any child struct will inherit the definitions of ``Ω:=N(0,Q)`` and ``Δ:=N(0,R)``.

```@docs
GaussianStateSpaceModel
```

```@docs
state_noise(m::GaussianStateSpaceModel)
observation_noise(m::GaussianStateSpaceModel)
```

Any concrete implementation must define the following two functions:

```@docs
state_noise_cov
observation_noise_cov
```

!!! note
    Additionally, functions [`state_transition`](@ref), [`observation_emission`](@ref), and two versions of [`Base.size`](@ref) must be implemented to satisfy the requirements of the [`StateSpaceModel`](@ref) interface.



## Linear Gaussian State Space Model

`LinearGaussianStateSpaceModel` is a concrete implementation of the `GaussianStateSpaceModel` (thus in particular, also of `StateSpaceModel`'s).

```@docs
LinearGaussianStateSpaceModel
```

The following additional functions are defined for [`LinearGaussianStateSpaceModel`](@ref):

```@docs
transition_matrix
observation_matrix
```

## Example of a Non-linear Non-Gaussian State Space Model

More general models must be implemented by the user by adhering to the [`StateSpaceModel`](@ref) interface. Below is an example of a 1-dimensional state evolving as a double-well potential with Cauchy noise and non-linear observation model perturbed by Poisson noise:
```julia
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
```

!!! tip
    Notice that despite the model being 1-dimensional we don't treat it as a scalar-valued process, but instead, as a 1-element vector-valued process. In particular, we use the [Distributions.jl](https://github.com/JuliaStats/Distributions.jl/tree/master) `Product` to compose Univariate distributions into a Multivariate one.

Once defined, we can define a model and, for instance, sample and plot trajectories (see [Sampling](@ref) and [Plotting](@ref) sections for more details):
```julia
using Plots

model = MySSM(0.01, 1.0, 0.0, 0.001, 1)

x₀ = [1.0]
num_timepoints = 100
xx, yy = rand(model, x₀, num_timepoints)

plot(trajectoryplot(0:num_timepoints, yy; seriestype=:scatter, label="", title="Observations"),
     trajectoryplot(0:num_timepoints, xx; seriestype=:scatter, label="", title="Underlying state"))
```