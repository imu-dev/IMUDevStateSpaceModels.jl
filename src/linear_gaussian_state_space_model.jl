"""
    LinearGaussianStateSpaceModel([T::DataType]; F, Q, H, R)

State space model with linear dynamics, additive Gaussian noise and linear,
Gaussian observations. It is given by the following set of equations:

```math
\\begin{cases}
x_{t+1} &= F \\times x_t + w_t,\\qquad w_t \\sim N(0, Q)\\\\
y_t &= H \\times x_t + v_t,\\qquad  v_t \\sim N(0, R)
\\end{cases}
```

!!! tip
    You can use `LinGsnSSM` alias for `LinearGaussianStateSpaceModel`.
"""
@kwdef struct LinearGaussianStateSpaceModel{T} <: GaussianStateSpaceModel{T}
    """State evolution matrix"""
    F::Matrix{T}
    """Covariance of the state evolution noise"""
    Q::Matrix{T}
    """Observation matrix"""
    H::Matrix{T}
    """Covariance of the observation noise"""
    R::Matrix{T}
end

const LinGsnSSM = LinearGaussianStateSpaceModel

LinGsnSSM(T::DataType; F, Q, H, R) = LinGsnSSM(T.(F), T.(Q), T.(H), T.(R))

Base.size(m::LinGsnSSM, ::Val{:state}) = size(m.F, 1)
function Base.size(m::LinGsnSSM, ::Union{Val{:observation},Val{:obs}})
    return size(m.H, 1)
end

"""
    transition_matrix(m::LinGsnSSM)

Return state evolution matrix ``F`` of the [`LinearGaussianStateSpaceModel`](@ref)
`m`.
"""
transition_matrix(m::LinGsnSSM) = m.F
state_noise_cov(m::LinGsnSSM) = m.Q

"""
    observation_matrix(m::LinGsnSSM)

Return the observation matrix ``H`` of the [`LinearGaussianStateSpaceModel`](@ref)
`m`.
"""
observation_matrix(m::LinGsnSSM) = m.H
observation_noise_cov(m::LinGsnSSM) = m.R

state_transition(x, m::LinGsnSSM) = m.F * x
observation_emission(x, m::LinGsnSSM) = m.H * x

function Base.show(io::IO, ::MIME"text/plain", m::LinGsnSSM)
    title = "Linear Gaussian state space model"
    equation = md"""``x_{t+1} = F x_t + w_t,\quad w_t\sim N(0,Q),``\
    ``y_t = H x_t + v_t,\quad v_t\sim N(0,R),``\
    where ``x_t`` is the unobserved, underlying state and ``y_t`` are the observations."""
    p = Panel(RenderableText("$title"),
              RenderableText(equation))
    F = RenderableText("\n\n{bold red}F = {/bold red}") * matrix_panel(m.F)
    Q = RenderableText("\n\n{bold red}Q = {/bold red}") * matrix_panel(m.Q)
    H = RenderableText("\n\n{bold red}H = {/bold red}") * matrix_panel(m.H)
    R = RenderableText("\n\n{bold red}R = {/bold red}") * matrix_panel(m.R)

    ss_eqn = RenderableText(md"""(where ``x_{t+1} = ``  {bold italic red}F{/bold italic red} ``x_t + w_t,\quad w_t\sim N(0,``{bold italic red}Q{/bold italic red}``)``)""")
    obs_eqn = RenderableText(md"""(where ``y_t = ``  {bold italic red}H{/bold italic red} ``x_t + v_t,\quad v_t\sim N(0,``{bold italic red}R{/bold italic red}``)``)""")
    println(io, p)
    println(io, Panel("State space"; fit=true))
    println(io, RenderableText("State dimension: $(size(m, :state))"))
    println(io, F * Term.Spacer(3, 5) * Q)
    println(io, RenderableText(ss_eqn))
    println(io, Panel("Observation space"; fit=true))
    println(io, RenderableText("Observation dimension: $(size(m, :obs))"))
    println(io, H * Term.Spacer(3, 5) * R)
    println(io, RenderableText(obs_eqn))
    return nothing
end
