source("PrepareXForHCP.R")

CitationRatios <- function(hcp, confStartYear, confCitations, confLastYear = 2016, dir = "../data/") {
  uniqueYears <- unique(confCitations$current_year)
  confPubYears <- read.csv(paste(dir, "conferences_first_publication_year.csv", sep = "/"), stringsAsFactors = FALSE)
  citationRatios <- rep(0, confLastYear-confStartYear)
  
  # For each unique year of citing conference
  for (year in uniqueYears) {
    # Get subset of data with given year
    periodCitation <- confCitations[confCitations$current_year == year, ]
    # Get start year of historical period from cited conference
    periodStart <- confPubYears[confPubYears$normalized_venue == periodCitation$to_base[1], ]$min
    # Calculate the end of historical period
    periodEnd <- year - 1
    # Calculate X's for HCP
    hcpX <- PrepareXForHCP(periodStart, periodCitation$year_cited_papers, periodEnd)
    # For each year of cited conference, divide number of citations by total number of citations of cited conference in that year
    citationSeries <- periodCitation$selected_cited_papers_in_year_no / periodCitation$all_cited_papers_in_year_no
    # Apply stretched HCP function to citationSeries and sum all the ratios
    citationRatio <- sum(hcp(hcpX)*citationSeries)
    # Store summed ratios from current year
    citationRatios[year-confStartYear+1] <- citationRatio
  }
  citationRatios
}