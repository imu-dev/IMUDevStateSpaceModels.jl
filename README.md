# IMUDevStateSpaceModels

[![][docs-dev-img]][docs-dev-url]
[![Build Status](https://github.com/imu-dev/IMUDevStateSpaceModels.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/imu-dev/IMUDevStateSpaceModels.jl/actions/workflows/CI.yml?query=branch%3Amain)

A minimalist implementation of some State Space Models that is geared towards working with Neural Networks.

> [!TIP]
> Julia has already a host of excellent packages implementing State Space Models, as well as those that perform all sorts of inference, forecasting or simulation on them; see for instance [StateSpaceModels](https://github.com/LAMPSPUC/StateSpaceModels.jl), [DynamicalSystems](https://github.com/JuliaDynamics/DynamicalSystems.jl), [LowLevelParticleFilters](https://github.com/baggepinnen/LowLevelParticleFilters.jl), [Kalman](https://github.com/mschauer/Kalman.jl) or [DifferentialEquations](https://docs.sciml.ai/DiffEqDocs/stable/) for some examples that you should consider first, before trying to use this package.

The primary aim of this package is to provide a relatively light module that facilitates:

- defining a State Space Model
- defining transition functions that work for **batches** (so as to facilitate a seamless integration with Neural Nets-not included in this package)
- generate sample trajectories (single or in batches)
- plot the trajectories

> [!IMPORTANT]
> This package **<u>is not</u>** registered with Julia's [General Registry](https://github.com/JuliaRegistries/General), but instead, with `imu.dev`'s local [IMUDevRegistry](https://github.com/imu-dev/IMUDevRegistry). In order to use this package you will need to add [IMUDevRegistry](https://github.com/imu-dev/IMUDevRegistry) to the list of your registries.

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://imu-dev.github.io/IMUDevStateSpaceModels.jl/dev
