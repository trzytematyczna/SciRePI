EMAWeights <- function(m) {
  alpha<-2/(m+1)
  i<-1:m
  sm<-sum((alpha*(1-alpha)^(1-i)))
  return(((alpha*(1-alpha)^(1-i)))/sm)
}