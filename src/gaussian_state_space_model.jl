"""
Parent type to Gaussian State Space Models of the form:

    x_{k+1} = f(x_k) + ω_k, ω_k ~ N(0, Q),
    y_k = g(x_k) + δ_k, δ_k ~ N(0, R),

where Q and R are the state and observation noise covariance matrices, and the
remaining parameters are as in the description of the [`StateSpaceModel`](@ref)
type.
"""
abstract type GaussianStateSpaceModel{T} <: StateSpaceModel{T} end

"""
    state_noise_cov(m::GaussianStateSpaceModel)

Return the state noise covariance matrix of the state space model `m`.
"""
function state_noise_cov(m::GaussianStateSpaceModel)
    throw(NotImplExcpt("state_noise_cov", m))
end

"""
    observation_noise_cov(m::GaussianStateSpaceModel)

Return the observation noise covariance matrix of the state space model `m`.
"""
function observation_noise_cov(m::GaussianStateSpaceModel)
    throw(NotImplExcpt("observation_noise_cov", m))
end

"""
    state_noise(m::GaussianStateSpaceModel)

Return a (Gaussian) distribution of the state noise of the state space model `m`.
"""
function state_noise(m::GaussianStateSpaceModel)
    return MvNormal(zeros(size(m, :state)), state_noise_cov(m))
end

"""
    observation_noise(m::GaussianStateSpaceModel)

Return a (Gaussian) distribution of the observation noise of the state space
model `m`.
"""
function observation_noise(m::GaussianStateSpaceModel)
    return MvNormal(zeros(size(m, :obs)), observation_noise_cov(m))
end