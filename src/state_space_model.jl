"""
Parent type to all State Space Models. `T` is the eltype of state.

In this package we deal with models of the form:

```math
\\begin{cases}
x_{k+1} &= f(x_k) + ω_k,\\qquad ω_k \\sim Ω,\\\\
y_k &= g(x_k) + δ_k,\\qquad δ_k \\sim Δ,
\\end{cases}
```

where
- ``x_k`` is the state,
- ``y_k`` is the observation,
- ``f`` is the state transition function,
- ``g`` is the observation function,
- ``ω_k`` is the state noise,
- ``δ_k`` is the observation noise,
- ``Ω`` is the distribution of the state noise, and
- ``Δ`` is the distribution of the observation noise.

In particular, we **do not** deal with control inputs and we assume a linearly
additive noise model.

!!! warning
    We assume that the state is given by a vector (even a scalar-valued state is
    represented as a vector of length 1). The same applies to the observations.
    (At least for now... We might change this in the future, depending on the
    needs that will arise.)

"""
abstract type StateSpaceModel{T} end

"""
    Base.eltype(::StateSpaceModel{T})

eltype of the state.
"""
Base.eltype(::StateSpaceModel{T}) where {T} = T

"""
    state_transition(x, m::StateSpaceModel)

State transition function ``f`` of the [`StateSpaceModel`](@ref) `m`.

!!! default "Important"
    Any concrete implementation of the [`StateSpaceModel`](@ref) must override
    this function.
"""
state_transition(::Any, m::StateSpaceModel) = throw(NotImplExcpt(`state_transition`, m))

"""
    observation_emission(x, m::StateSpaceModel)

Observation function ``g`` of the [`StateSpaceModel`](@ref) `m`.

!!! default "Important"
    Any concrete implementation of the [`StateSpaceModel`](@ref) must override
    this function.
"""
function observation_emission(::Any, m::StateSpaceModel)
    throw(NotImplExcpt(`observation_emission`, m))
end

"""
    state_noise(m::StateSpaceModel)

State noise generator ``Ω`` of the [`StateSpaceModel`](@ref) `m`.

!!! default "Important"
    Any concrete implementation of the [`StateSpaceModel`](@ref) must override
    this function.
"""
state_noise(m::StateSpaceModel) = throw(NotImplExcpt(`state_noise`, m))

"""
    observation_noise(m::StateSpaceModel)

Observation noise generator ``Δ`` of the [`StateSpaceModel`](@ref) `m`.

!!! default "Important"
    Any concrete implementation of the [`StateSpaceModel`](@ref) must override
    this function.
"""
observation_noise(m::StateSpaceModel) = throw(NotImplExcpt(`observation_noise`, m))

"""
    Base.size(m::StateSpaceModel)

Return lengths of the state and observation vectors.
"""
Base.size(m::StateSpaceModel) = (state=size(m, :state), observation=size(m, :obs))

"""
    Base.size(m::StateSpaceModel, s::Union{Symbol,Val{:state},Val{:observation},Val{:obs})

Length of the state or observation vectors depending on the value of `s`:
- `s=:state` or `s=Val{:state}`: length of the state,
- `s=:observation` or `s=:obs` or `s=Val{:observation}` or `s=Val{:obs}`: length of the observation.

!!! default "Important"
    Any concrete implementation of the [`StateSpaceModel`](@ref) must override
    functions `Base.size(m::StateSpaceModel, ::Val{:state})` and
    `Base.size(m::StateSpaceModel, ::Union{Val{:observation},Val{:obs}})`.
"""
Base.size(m::StateSpaceModel, s::Symbol) = size(m, Val{s}())
function Base.size(m::StateSpaceModel, ::Val{:state})
    return _not_implemented_exception(`observation_emission`, m)
end
function Base.size(m::StateSpaceModel, ::Union{Val{:observation},Val{:obs}})
    return _not_implemented_exception(`observation_emission`, m)
end

# ---------------------------------------------------------------------------- #
#                                                                              #
#                       ------------------------------                         #
#                       RANDOM SAMPLING OF TRAJECORIES                         #
#                       ------------------------------                         #
#                                                                              #
# ---------------------------------------------------------------------------- #

"""
    state_step(rng::AbstractRNG, m::StateSpaceModel,
               x::Union{<:AbstractVector, <:AbstractMatrix};
               noise_gen=state_noise(m))

Perform a single (random) step:

```math
f(x_k) + ω_k,\\quad ω_k \\sim Ω
```

- for a single state ``xₖ :=`` `x` if `x` is a vector, or
- for a batch of states ``xₖ⁽ⁱ⁾ :=`` `x[:, i]` if `x` is a matrix.
"""
function state_step(rng::AbstractRNG, m::StateSpaceModel, x::AbstractVector;
                    noise_gen=state_noise(m))
    return state_transition(x, m) + rand(rng, noise_gen)
end
function state_step(rng::AbstractRNG, m::StateSpaceModel, x::AbstractMatrix;
                    noise_gen=state_noise(m))
    return state_transition(x, m) + rand(rng, noise_gen, size(x, 2))
end

"""
    obs_step(rng::AbstractRNG, m::StateSpaceModel,
             x::Union{<:AbstractVector, <:AbstractMatrix};
             noise_gen=observation_noise(m))

Perform a single (random) observation step:
```math
g(x_k) + δ_k,\\quad δ_k \\sim Δ
```

- for a single state ``xₖ :=`` `x` if `x` is a vector, or
- for a batch of states ``xₖ⁽ⁱ⁾ :=`` `x[:, i]` if `x` is a matrix.
"""
function obs_step(rng::AbstractRNG, m::StateSpaceModel, x::AbstractVector;
                  noise_gen=observation_noise(m))
    return observation_emission(x, m) + rand(rng, noise_gen)
end
function obs_step(rng::AbstractRNG, m::StateSpaceModel, x::AbstractMatrix;
                  noise_gen=observation_noise(m))
    return observation_emission(x, m) + rand(rng, noise_gen, size(x, 2))
end

"""
    step(rng::AbstractRNG, m::StateSpaceModel,
         x::Union{<:AbstractVector,<:AbstractMatrix};
         state_noise_gen=state_noise(m), obs_noise_gen=observation_noise(m))

Perform a single (random) step:

```math
\\begin{cases}
x° &= f(x_k) + ω_k,\\qquad ω_k \\sim Ω,\\\\
y° &= g(x°) + δ_k,\\qquad δ_k \\sim Δ,
\\end{cases}
```

- for a single state ``xₖ := `` `x` if `x` is a vector, or
- for a batch of states ``xₖ⁽ⁱ⁾ := `` `x[:, i]` if `x` is a matrix.
"""
function step(rng::AbstractRNG, m::StateSpaceModel,
              x::Union{<:AbstractVector,<:AbstractMatrix};
              state_noise_gen=state_noise(m), obs_noise_gen=observation_noise(m))
    x = state_step(rng, m, x; noise_gen=state_noise_gen)
    y = obs_step(rng, m, x; noise_gen=obs_noise_gen)
    return x, y
end

function _state_size_assertion(x0, m::StateSpaceModel; container_name="state container")
    error_msg = "Dimension of the $container_name does not match model's state dimension."
    @assert size(x0, 1) == size(m, :state) error_msg
end

function _obs_size_assertion(y, m::StateSpaceModel)
    error_msg = "Dimension of the observation container does not match model's observation dimension."
    @assert size(y, 1) == size(m, :obs) error_msg
end

function _equal_dim_assertion(x, y; dim, dim_label, x_name, y_name)
    error_msg = "$dim_label mismatch between containers $x_name and $y_name."
    @assert size(x, dim) == size(y, dim) error_msg
end

"""
    Random.rand!([rng::AbstractRNG], out::AbstractMatrix, m::StateSpaceModel,
                 x0::AbstractVector)
                
    Random.rand!([rng::AbstractRNG], out_x::AbstractMatrix, out_y::AbstractMatrix,
                 m::StateSpaceModel, x0::AbstractVector)

Sample a trajectory of the state space model `m` starting from `x0`, store the
state trajectory in `out_x` (if `out_x` provided) and store the observations in
`out` or `out_y`.

    Random.rand!([rng::AbstractRNG], out::Abstract3Tensor, m::StateSpaceModel,
                 x0::AbstractMatrix)

    Random.rand!(rng::AbstractRNG, out_x::Abstract3Tensor, out_y::Abstract3Tensor,
                 m::StateSpaceModel, x0::AbstractMatrix)

Sample a batch of trajectories of the state space model `m`, each starting from
a separate `x0[:, i]`, store the state trajectory in `out_x` (if `out_x`
provided) and store the observations in `out` or `out_y`.

!!! note
    `x0` will be stored in `out_x` (if provided) as the first state and `y0`
    (sampled from `x0`) will be stored in `out_y` (or `out`) as the first
    observation.
"""
function Random.rand!(rng::AbstractRNG, out::AbstractMatrix, m::StateSpaceModel,
                      x0::AbstractVector)
    _state_size_assertion(x0, m; container_name="initial state")
    _obs_size_assertion(out, m)
    w = state_noise(m)
    v = observation_noise(m)

    x = x0
    out[:, 1] .= obs_step(rng, m, x; noise_gen=v)
    for t in 1:(size(out, 2) - 1)
        x, y = step(rng, m, x; state_noise_gen=w, obs_noise_gen=v)
        out[:, t + 1] .= y
    end
    return nothing
end

function Random.rand!(rng::AbstractRNG, out::Abstract3Tensor, m::StateSpaceModel,
                      x0::AbstractMatrix)
    _state_size_assertion(x0, m; container_name="initial state")
    _obs_size_assertion(out, m)
    _equal_dim_assertion(out_x, x0; dim=2, dim_label="Batch size",
                         x_name="out_x", y_name="x0")
    w = state_noise(m)
    v = observation_noise(m)

    x = x0
    out[:, :, 1] .= obs_step(rng, m, x; noise_gen=v)
    for t in 1:(size(out, 3) - 1)
        x, y = step(rng, m, x; state_noise_gen=w, obs_noise_gen=v)
        out[:, :, t + 1] .= y
    end
    return nothing
end

function Random.rand!(out, m::StateSpaceModel, x0::AbstractArray)
    return Random.rand!(Random.default_rng(), out, m, x0)
end

function Random.rand!(rng::AbstractRNG, out_x::AbstractMatrix, out_y::AbstractMatrix,
                      m::StateSpaceModel, x0::AbstractVector)
    _state_size_assertion(x0, m; container_name="initial state")
    _state_size_assertion(out_x, m)
    _obs_size_assertion(out_y, m)
    _equal_dim_assertion(out_x, out_y; dim=2, dim_label="Number of time steps",
                         x_name="out_x", y_name="out_y")
    w = state_noise(m)
    v = observation_noise(m)

    x = x0
    out_x[:, 1] .= x
    out_y[:, 1] .= obs_step(rng, m, x; noise_gen=v)
    for t in 1:(size(out_x, 2) - 1)
        x, y = step(rng, m, x; state_noise_gen=w, obs_noise_gen=v)
        out_x[:, t + 1] .= x
        out_y[:, t + 1] .= y
    end
    return nothing
end

function Random.rand!(rng::AbstractRNG, out_x::Abstract3Tensor, out_y::Abstract3Tensor,
                      m::StateSpaceModel, x0::AbstractMatrix)
    _state_size_assertion(x0, m; container_name="initial state")
    _state_size_assertion(out_x, m)
    _obs_size_assertion(out_y, m)
    _equal_dim_assertion(out_x, out_y; dim=3, dim_label="Number of time steps",
                         x_name="out_x", y_name="out_y")
    _equal_dim_assertion(out_x, out_y; dim=2, dim_label="Batch size",
                         x_name="out_x", y_name="out_y")
    _equal_dim_assertion(out_x, x0; dim=2, dim_label="Batch size",
                         x_name="out_x", y_name="x0")
    w = state_noise(m)
    v = observation_noise(m)

    x = x0
    out_x[:, :, 1] .= x
    out_y[:, :, 1] .= obs_step(rng, m, x; noise_gen=v)
    for t in 1:(size(out_x, 3) - 1)
        x, y = step(rng, m, x; state_noise_gen=w, obs_noise_gen=v)
        out_x[:, :, t + 1] .= x
        out_y[:, :, t + 1] .= y
    end
    return nothing
end

function Random.rand!(out_x, out_y, m::StateSpaceModel, x0::AbstractVector)
    return Random.rand!(Random.default_rng(), out_x, out_y, m, x0)
end

"""
    Random.rand([rng::AbstractRNG], m::StateSpaceModel, x0::AbstractVector,
                num_obs::Int)

Sample a trajectory of the state space model `m` starting from `x0` and return
the state trajectory and the observations.

    Random.rand([rng::AbstractRNG], m::StateSpaceModel, x0::AbstractMatrix,
                num_obs::Int)

Sample a batch of trajectories of the state space model `m`, each starting from
a separate `x0[:, i]` and return the state trajectories and the observations.

!!! note
    `num_obs` is the number of observations to be sampled, excluding the
    initial state. However, the initial state (as well as the "zeroth"
    observation) will be prepended to the output arrays.
"""
function Random.rand(rng::AbstractRNG, m::StateSpaceModel, x0::AbstractVector,
                     num_obs::Int)
    out_x = Matrix{eltype(x0)}(undef, size(m, :state), num_obs + 1)
    out_y = Matrix{eltype(x0)}(undef, size(m, :obs), num_obs + 1)
    Random.rand!(rng, out_x, out_y, m, x0)
    return out_x, out_y
end

function Random.rand(rng::AbstractRNG, m::StateSpaceModel, x0::AbstractMatrix,
                     num_obs::Int)
    num_batches = size(x0, 2)
    out_x = Array{eltype(x0),3}(undef, size(m, :state), num_batches, num_obs + 1)
    out_y = Array{eltype(x0),3}(undef, size(m, :obs), num_batches, num_obs + 1)
    Random.rand!(rng, out_x, out_y, m, x0)
    return out_x, out_y
end

function Random.rand(m::StateSpaceModel, x0::AbstractArray, num_obs::Int)
    return Random.rand(Random.default_rng(), m, x0, num_obs)
end