module IMUDevStateSpaceModels

using Distributions
using Markdown
using Random
using Term
using Term.TermMarkdown

const Abstract3Tensor = AbstractArray{<:Any,3}

include("utils.jl")
include("not_implemented_exception.jl")
include("state_space_model.jl")
include("gaussian_state_space_model.jl")
include("linear_gaussian_state_space_model.jl")

export StateSpaceModel, GaussianStateSpaceModel, LinearGaussianStateSpaceModel,
       LinGsnSSM

export state_transition, observation_emission, state_noise, observation_noise,
       state_noise_cov, observation_noise_cov, transition_matrix, observation_matrix

end
