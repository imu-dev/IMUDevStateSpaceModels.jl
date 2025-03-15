using Documenter
using IMUDevStateSpaceModels

makedocs(; sitename="IMUDevStateSpaceModels",
         format=Documenter.HTML(),
         modules=[IMUDevStateSpaceModels],
         checkdocs=:exports,
         pages=["Home" => "index.md",
                "Manual" => ["Models" => joinpath("pages", "types.md"),
                             "Sampling" => joinpath("pages", "sampling.md"),
                             "Plotting" => joinpath("pages", "plotting.md")]])

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
deploydocs(; repo="github.com/imu-dev/IMUDevStateSpaceModels.jl.git")
# if get(ENV, "CI", "false") == "true"
#     deploydocs(; repo="github.com/imu-dev/IMUDevStateSpaceModels.jl.git")
# end
