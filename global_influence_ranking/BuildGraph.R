library(igraph)

BuildGraph <- function(filename = "../results/TimeSeriesExperiments/results_2018-02-14_20-39-42.csv") {
  globalInfluence <- read.csv(filename)
  g <- graph(directed = TRUE, edges = as.vector(t(globalInfluence[,1:2])))
  g
}
