"""
    $(TYPEDEF)

Parent type to Gaussian State Space Models of the form:

```math
\\begin{cases}
x_{k+1} &= f(x_k) + ω_k,\\qquad ω_k \\sim N(0, Q),\\\\
y_k &= g(x_k) + δ_k,\\qquad δ_k \\sim N(0, R),
\\end{cases}
```

where ``Q`` and ``R`` are the state and observation noise covariance matrices,
and the remaining parameters are as in the description of the
[`StateSpaceModel`](@ref) type.
"""
abstract type GaussianStateSpaceModel{T} <: StateSpaceModel{T} end

"""
    state_noise_cov(m::GaussianStateSpaceModel)

Return the state noise covariance matrix ``Q`` of the
[`GaussianStateSpaceModel`](@ref) `m`.

!!! default "Important"
    Any concrete implementation of the [`GaussianStateSpaceModel`](@ref) must
    override this function.
"""
function state_noise_cov(m::GaussianStateSpaceModel)
    throw(NotImplExcpt("state_noise_cov", m))
end

"""
    observation_noise_cov(m::GaussianStateSpaceModel)

Return the observation noise covariance matrix ``R`` of the
[`GaussianStateSpaceModel`](@ref) `m`.

!!! default "Important"
    Any concrete implementation of the [`GaussianStateSpaceModel`](@ref) must
    override this function.
"""
function observation_noise_cov(m::GaussianStateSpaceModel)
    throw(NotImplExcpt("observation_noise_cov", m))
end

"""
    state_noise(m::GaussianStateSpaceModel)

Return ``N(0, Q)``: a (Gaussian) distribution of the state noise of the
[`GaussianStateSpaceModel`](@ref) `m`.
"""
function state_noise(m::GaussianStateSpaceModel)
    return MvNormal(zeros(size(m, :state)), state_noise_cov(m))
end

"""
    observation_noise(m::GaussianStateSpaceModel)

Return ``N(0, R)``: a (Gaussian) distribution of the observation noise of the
[`GaussianStateSpaceModel`](@ref) `m`.
"""
function observation_noise(m::GaussianStateSpaceModel)
    return MvNormal(zeros(size(m, :obs)), observation_noise_cov(m))
end