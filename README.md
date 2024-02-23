# IMUDevStateSpaceModels

[![Build Status](https://github.com/imu-dev/IMUDevStateSpaceModels.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/imu-dev/IMUDevStateSpaceModels.jl/actions/workflows/CI.yml?query=branch%3Amain)

Minimalist implementation of some State Space Models that is geared towards working with Neural Networks.

> [!TIP]
> Julia has already a host of excellent packages implementing State Space Models, as well as those that perform all sorts of inference, forecasting or simulation on them; see for instance [StateSpaceModels](https://github.com/LAMPSPUC/StateSpaceModels.jl), [DynamicalSystems](https://github.com/JuliaDynamics/DynamicalSystems.jl), [LowLevelParticleFilters](https://github.com/baggepinnen/LowLevelParticleFilters.jl), [Kalman](https://github.com/mschauer/Kalman.jl) or [DifferentialEquations](https://docs.sciml.ai/DiffEqDocs/stable/) for some examples that you should consider first, before trying to use this package.

The primary aim of this package is to provide a relatively light module that facilitates:

- defining a State Space Model
- defining transition functions that work for **batches** (so as to facilitate a seamless integration with Neural Nets-not included in this package)
- generate sample trajectories (also in batches)

## How to use

The package introduces `LinearGaussianStateSpaceModel` (alias `LinGsnSSM`) to define a model. Individual and batched trajectories can be sampled with `rand` and `rand!`. Individual trajectories can be visualized with `trajectoryplot`.
