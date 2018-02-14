source("VisualizeEMAGraph.R")
source("VisualizePRGraph.R")

VisualizeGraph <- function(g, gpr) {
  par(mfrow=c(1, 2))
  VisualizeEMAGraph(g, "EMA average")
  VisualizePRGraph(gpr, "PageRank")
}