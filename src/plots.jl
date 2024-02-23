@userplot TrajectoryPlot

@recipe function f(h::TrajectoryPlot)
    tt, xx, ΣΣ = parse_args(h)
    n = size(xx, 1)
    layout := (n, 1)
    for i in 1:n
        if !isnothing(ΣΣ)
            for ribbon_width in 1:2
                @series begin
                    subplot := i
                    seriestype := :path
                    # # ignore series in legend and color cycling
                    primary := false
                    linecolor := nothing
                    fillcolor --> 1
                    fillalpha := 0.25
                    fillrange := xx[i, :] .- ribbon_width .* sqrt.(ΣΣ[i, i, :])
                    # ensure no markers are shown for the error band
                    markershape := :none
                    # return series data
                    tt, xx[i, :] .+ ribbon_width .* sqrt.(ΣΣ[i, i, :])
                end
            end
        end
        @series begin
            subplot := i
            seriestype := get(plotattributes, :seriestype, :path)
            linewidth := 2
            tt, xx[i, :]
        end
    end
end

function parse_args(h::TrajectoryPlot)
    if arg_len < 1
        return error("Trajectory Plots expects at least one argument")
    elseif arg_len == 1
        xx = h.args[1]
        if !(xx isa AbstractMatrix)
            return error("1-parameter Trajectory Plot expects a matrix of " *
                         "states. It should be a matrix of size (n, t) where " *
                         "n is the number of states and t is the number of " *
                         "timepoints.")
        end
        tt = 1:size(xx, 2)
        ΣΣ = nothing
        return tt, xx, ΣΣ
    elseif arg_len == 2
        a, b = h.args
        tt, xx, ΣΣ = if a isa AbstractMatrix && b isa Abstract3Tensor
            1:size(a, 2), a, b
        elseif a isa AbstractVector && b isa AbstractMatrix
            a, b, nothing
        else
            return error("2-parameter Trajectory Plot expects either a " *
                         "vector of timepoints and a matrix of states or a " *
                         "matrix of states and a 3-tensor of state " *
                         "covariances.")
        end
        return tt, xx, ΣΣ
    elseif arg_len == 3
        tt, xx, ΣΣ = h.args
        if !(tt isa AbstractVector && xx isa AbstractMatrix && σσ isa Abstract3Tensor)
            return error("3-parameter Trajectory Plot expects a vector of " *
                         "timepoints, a matrix of states, and a 3-tensor of " *
                         "state covariances.")
        end
        return tt, xx, ΣΣ
    else
        return error("Trajectory Plots expects at most three arguments")
    end
end