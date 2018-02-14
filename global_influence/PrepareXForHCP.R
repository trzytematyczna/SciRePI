PrepareXForHCP <- function(start, points, end) {
  span <- end - start
  (1/span) * (points - start)
}