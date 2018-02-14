source("VisualizeEMAGraph.R")
source("VisualizePRGraph.R")

VisualizeFourGraphs <- function(unity, linear, sqrt, pr) {
  par(mfrow=c(2, 2))
  VisualizeEMAGraph(unity, "EMA (unity)")
  VisualizeEMAGraph(linear, "EMA (linear)")
  VisualizeEMAGraph(sqrt, "EMA (sqrt)")
  VisualizePRGraph(pr, "PageRank")
}