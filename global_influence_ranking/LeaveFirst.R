LeaveFirst <- function(g, treshold) {
  ema <- V(g)$ema
  treshold <- mean(ema)
  
  to_delete <- c()
  for (vid in V(g)) {
    if (V(g)[vid]$ema < treshold) {
      cat(sprintf("%f\n", V(g)[vid]$ema))
      to_delete <- c(to_delete,vid)
    }
  }
  g <- delete_vertices(g, to_delete)
  g
}