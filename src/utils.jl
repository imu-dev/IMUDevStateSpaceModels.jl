"""
    matrix_panel(mtx::AbstractMatrix; kwargs...)

Show a matrix content as a 2D table visualization.
"""
function matrix_panel(mtx::AbstractMatrix; kwargs...)
    return Panel(Term.Repr.matrix2content(mtx);
                 fit=true,
                 title="Matrix", title_justify=:left,
                 width=min(Term.Repr.console_width() - 10, Term.Repr.default_width()) - 20,
                 justify=:center,
                 style=TERM_THEME[].repr_panel,
                 title_style=TERM_THEME[].repr_name,
                 padding=(1, 1, 1, 1),
                 subtitle="{$(TERM_THEME[].text_accent)}$(size(mtx, 1)) × $(size(mtx, 2)){/$(TERM_THEME[].text_accent)}{default} {/default}",
                 subtitle_justify=:right,
                 kwargs...,)
end
