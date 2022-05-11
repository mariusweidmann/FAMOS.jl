using FAMOS
using Documenter

DocMeta.setdocmeta!(FAMOS, :DocTestSetup, :(using FAMOS); recursive=true)

makedocs(;
    modules=[FAMOS],
    authors="Qiwen Huang, Marius Weidmann",
    repo="https://github.com/mariusweidmann/FAMOS.jl/blob/{commit}{path}#{line}",
    sitename="FAMOS.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://mariusweidmann.github.io/FAMOS.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/mariusweidmann/FAMOS.jl",
    devbranch="main",
)
