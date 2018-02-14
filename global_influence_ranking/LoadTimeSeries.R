# Load files from other experiment
setwd("../global_influence/")
source("CitationRatios.R")
source("ExtractConfStartYear.R")
source("hcp/Unity.R")
setwd("../global_influence_ranking/")

LoadTimeSeries <- function(from, to, dir) {
  cat(sprintf("from-to: %s - %s\n", from, to))
  # Find appropriate file
  filename <- list.files(dir, pattern = paste("^", to, "-", from, "_", sep=""))
  cat(sprintf("Opening file: %s\n", filename))
  # Open file
  data <- read.csv(paste(dir, filename, sep="/"))
  cr <- CitationRatios(Unity, ExtractConfStartYear(filename), data)
  cr
}