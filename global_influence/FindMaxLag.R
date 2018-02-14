library(lmtest)
library(testit)

##
# Find maximal available Granger Test lag for two time-series 
#
# Input:
#   d1 - first time-series
#   d2 - second time-series
#
# Output:
#   Maximal lag
##
FindMaxLag <- function(d1, d2) {
  assert("Time-series need to be equal in length", length(d1) == length(d2))
  # Make signal stationary
  sd1<-diff(d1)
  sd2<-diff(d2)
  # Maximal lag is no more than time-series size
  currentLag <- length(d1)
  while (currentLag > 1) {
    # Test if current lag value is any good
    returnLag <- tryCatch({
      grangertest(sd1 ~ sd2, order = currentLag)
      grangertest(sd2 ~ sd1, order = currentLag)
      currentLag
    }, error = function(e) {
      -1
    })
    # Return valid lag
    if (returnLag != -1) {
      return(returnLag)
    } else {
      # Otherwise test lags further
      currentLag <- currentLag - 1 
    }
  }
  # By default return lowest lag possible
  return(1)
}