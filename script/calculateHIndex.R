calculateHIndex <- function(filename = "../dataset/conference_citationCount_perPaper_selected.csv") {
  data <- read.csv(filename)
  venues <- unique(data$venue)
  result <- data.frame(venue=c(), hindex=c())
  for (venue in venues) {
    cat(sprintf("%s: ", venue))
    
    subdata <- data[data$venue == venue, ]
    cat(sprintf("%d publications; ", nrow(subdata)))
    
    subdata <- data.frame(id=1:nrow(subdata), citations=subdata$citationcount)
    hindex <- max(which(subdata$id<=subdata$citations))
    cat(sprintf("h-index: %d\n", hindex))
    result <- rbind(result, data.frame(venue=venue, hindex=hindex))
  }
  result
}
