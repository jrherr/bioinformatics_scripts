# R code for checkerboard score, see more in Barberán et al 2012 The ISME Journal

library(vegan)

library(bipartite)

#where species is you species by sites matrix

null.model <- oecosimu(species, bipartite::C.score, "swap", burnin=100, thin=10, statistic="evals", nsimul=10000)

print(null.model)