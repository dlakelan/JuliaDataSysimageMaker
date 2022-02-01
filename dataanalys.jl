using StatsPlots, CSV, DataFrames, DataFramesMeta, SQLite, GLM, Optim, 
	Dates, StatsBase, StatsFuns, Distributions, Turing,
	MCMCChains, Zygote, Memoization, ReverseDiff, Revise
using Statistics

df = DataFrame(x=rand(100),y=rand(100),z=Date(2000,01,01) .+ Dates.Day.(rand(Int,100).% 100))

median(df.x)
mean(df.x)
summarystats(df.x)
describe(df.x)

CSV.write("testfile.csv",df)

df2 = CSV.File("testfile.csv")
df3 = CSV.read("testfile.csv",DataFrame)

p = @df df plot(:x,:y)
@df df plot!(:y,:x)
display(p)

p2 = @df df scatter(:z,:y)
@df df scatter!(:z,:x)
display(p2)

h1 = @df df histogram(:x)
@df df histogram!(:y)
display(h1)

d1 = @df df density(:x)
@df df density!(:y)
display(d1)

ols = lm(@formula(y~x),df)
display(ols)


@chain df begin
@subset :x .> .5
@subset :y .< .5
@orderby :x
@transform :p = 2 * :x
end




try
    Base.Filesystem.rm("foo.db")
catch e
end

db = SQLite.DB("foo.db")
SQLite.load!(df,db,"foo")
df3 = DBInterface.execute(db,"select * from foo where x > ?", (.25,)) |> DataFrame
df4 = DBInterface.execute(db,"select * from foo") |> DataFrame


@model function foo(data)
    n ~ Gamma(3,2)
    foo ~ arraydist([Gamma(3,2) for i in 1:length(data)])
    bar ~ MvNormal([0.0 for i in 1:length(data)],1.0)
    baz ~ Normal(3.0,2.0)
end

Turing.setadbackend(:reversediff)
Turing.setrdcache(true)
Turing.emptyrdcache()



ch = sample(foo(collect(1:100)),NUTS(1000,.8),2000)
summarize(ch)

#Turing.setadbackend(:zygote)
#ch = sample(foo(collect(1:100)),NUTS(1000,.8),2000)
#summary(ch)

sleep(1)


