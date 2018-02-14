BuildPageRankGraph <- function(confList, filename = "../../results/WeightedPageRank/weighted_pagerank.csv") {
  data <- read.csv(filename, stringsAsFactors = FALSE)
  data <- data[data$Conference %in% confList, ]
  gpr <- graph.ring(n=nrow(data))
  V(gpr)$name <- data$Conference
  V(gpr)$pagerank <- data$PageRank
  gpr
}