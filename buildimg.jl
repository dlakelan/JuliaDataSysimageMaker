using Pkg
Pkg.activate(".")
Pkg.instantiate()
using PackageCompiler
using Pkg

Pkg.add(["StatsPlots","CSV","DataFrames","DataFramesMeta","SQLite","GLM","Optim","Distributions","Turing","MCMCChains","Zygote","ReverseDiff","Memoization","Revise","StatsBase","StatsFuns"])

create_sysimage([:StatsPlots,:CSV,:DataFrames,:DataFramesMeta,:SQLite,:GLM,:Optim,:Distributions,:Turing,:MCMCChains,:Zygote,:ReverseDiff,:Memoization,:Revise],sysimage_path="/var/local/dlakelan/julia/sys_dataanalys.so",precompile_execution_file="dataanalys.jl")

