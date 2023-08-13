using DiffusiveShockAccelerationModels
using Documenter

DocMeta.setdocmeta!(DiffusiveShockAccelerationModels, :DocTestSetup, :(using DiffusiveShockAccelerationModels); recursive=true)

makedocs(;
    modules=[DiffusiveShockAccelerationModels],
    authors="Ludwig Böss",
    repo="https://github.com/LudwigBoess/DiffusiveShockAccelerationModels.jl/blob/{commit}{path}#{line}",
    sitename="DiffusiveShockAccelerationModels.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://LudwigBoess.github.io/DiffusiveShockAccelerationModels.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/LudwigBoess/DiffusiveShockAccelerationModels.jl",
    devbranch="main",
)
