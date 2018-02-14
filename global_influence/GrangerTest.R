GrangerTest <- function(d1, d2, lag) {
  tryCatch({
    result<-grangertest(d1 ~ d2, order = lag)
    result[2, 4] # pvalue
  }, error=function(e) {
    return(NULL)
  })
}