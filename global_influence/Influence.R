source("FindMaxLag.R")
source("GrangerTest.R")

Influence <- function(d1, d2, epsilon=1e-2) {
  # Find maximal lag
  maxLag <- FindMaxLag(d1, d2)
  # Current pvalue is maximal
  pvalue <- 1
  # Recalculate Grander Casuality for all valid lags
  for (lag in seq(maxLag, 1, -1)) {
    result <- GrangerTest(d1, d2, lag)
    # Is result a lower pvalue?
    if (!is.null(result) && result < pvalue) {
      pvalue <- result
    }
  }
  hasInfluence <- FALSE
  # Check if there is an influence
  if (pvalue < epsilon) {
    hasInfluence <- TRUE
  }
  return(data.frame(hasInfluence=hasInfluence, pvalue=pvalue))
}
