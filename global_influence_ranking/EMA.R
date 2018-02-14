source("EMAWeights.R")

EMA <- function(ts)
{
  n <- length(ts)
  weights <- EMAWeights(n)
  sum(ts * weights)
}