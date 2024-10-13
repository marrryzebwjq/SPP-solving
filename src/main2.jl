# =========================================================================== #
# Compliant julia 1.x

# Using the following packages
using JuMP, GLPK
using LinearAlgebra

include("parserRail.jl")
include("setSPP.jl")
include("getfname.jl")
include("livrableEI1.jl")

# =========================================================================== #

# Loading a SPP instance
println("\nLoading...")
fname = "Data/rail582.dat"
nbvar, nbctr, A, C = loadInstanceRAIL(fname)
#Exercices
construct(C,A)
# Solving a SPP instance with GLPK
println("\nSolving...")
solverSelected = GLPK.Optimizer
spp = setSPP(C, A)

set_optimizer(spp, solverSelected)
#optimize!(spp)

# Displaying the results
#println("z = ", objective_value(spp))
#print("x = "); println(value.(spp[:x]))

# =========================================================================== #

# Collecting the names of instances to solve
#println("\nCollecting...")
#target = "Data"
#fnames = getfname(target)

#println("\nThat's all folks !")
