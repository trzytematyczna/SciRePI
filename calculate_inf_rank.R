results_infrank <- read.csv("results/hindex_infrank/hindex_infrank.csv", stringsAsFactors = FALSE)

results_infrank$emaRank <- rank(results_infrank$ema)
results_infrank$hindexRank <- rank(results_infrank$hindex, ties.method = "random")

emaRanking <- results_infrank[order(results_infrank$emaRank), ]$venue
hindexRanking <- results_infrank[order(results_infrank$hindexRank), ]$venue

orderedMatrix <- rbind(rev(emaRanking), rev(hindexRanking))

#rankingCESpearman <- RankAggreg(orderedMatrix, 25, method = "CE", distance = "Spearman", maxIter = 150, seed =100)
#rankingCEKendall <- RankAggreg(orderedMatrix, 25, method = "CE", distance = "Kendall", maxIter = 100, seed =100)

#rankingGASpearman <- RankAggreg(orderedMatrix, 25, method = "GA", distance = "Spearman", maxIter = 1000, seed =100)
#rankingGAKendall <- RankAggreg(orderedMatrix, 25, method = "GA", distance = "Kendall", maxIter = 1000, seed =100)

finalResult <- results_infrank[, c(1, 4, 5)]
CESpearmna <- data.frame(venue=rankingCESpearman$top.list, rankCESpearman=25:1)
GASpearmna <- data.frame(venue=rankingGASpearman$top.list, rankGASpearman=25:1)

finalResultCE <- merge(finalResult, CESpearmna, by="venue")
finalResultCE$emaRank <- 69 - finalResultCE$emaRank
finalResultCE$hindexRank <- 69 - finalResultCE$hindexRank
finalResultCE$rankCESpearman <- 26 - finalResultCE$rankCESpearman
finalResultCE <- finalResultCE[order(finalResultCE$rankCESpearman), ]

finalResultGA <- merge(finalResult, GASpearmna, by="venue")
finalResultGA$emaRank <- 69 - finalResultGA$emaRank
finalResultGA$hindexRank <- 69 - finalResultGA$hindexRank
finalResultGA$rankGASpearman <- 26 - finalResultGA$rankGASpearman
finalResultGA <- finalResultGA[order(finalResultGA$rankGASpearman), ]
