module IMUDevStateSpaceModels

using Distributions
using DocStringExtensions
using Markdown
using Random
using RecipesBase
using Term
using Term.TermMarkdown

import Random: rand!

const Abstract3Tensor = AbstractArray{<:Any,3}

include("not_implemented_exception.jl")
include("utils.jl")
include("state_space_model.jl")
include("gaussian_state_space_model.jl")
include("linear_gaussian_state_space_model.jl")
include("plots.jl")

export StateSpaceModel, GaussianStateSpaceModel, LinearGaussianStateSpaceModel,
       LinGsnSSM

export state_transition, observation_emission, state_noise, observation_noise,
       state_noise_cov, observation_noise_cov, transition_matrix, observation_matrix

export trajectoryplot

end
