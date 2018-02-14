source("CitationRatios.R")
source("ExtractConf.R")
source("ExtractConfStartYear.R")
source("Influence.R")
source("PrepareInfRow.R")

# Historical citations priority functions
source("hcp/Unity.R")
source("hcp/Linear.R")
source("hcp/Sqrt.R")
source("hcp/ReverseExp.R")

Experiment <- function(hcp, 
                       epsilon=1e-2, 
                       dirResults="../results/TimeSeriesExperiments/", 
                       dirData = "../data/timeseries/") {
  dataFilenames <- list.files(dirData, pattern="*\\.csv")
  filesVisited <- logical(length(dataFilenames))
  confInfluences <- setNames(data.frame(matrix(ncol = 4, nrow = 0)), c("confA", "confB", "infAB", "infBA"))
  
  for (idx in 1:length(dataFilenames)) {
    # Skip already visited files
    if (filesVisited[idx]) {
      next()
    }
    # Open first file (with citations A->B)
    dataFileNameAB <- dataFilenames[idx]
    # Extract names of conferences involved (A->B)
    confNames <- ExtractConf(dataFileNameAB)
    # Locate filename of reverse data file (B->A) 
    reverseDataFileName <- paste(confNames[2], confNames[1], sep="-")
    idx2 <- which(grepl(paste("^", reverseDataFileName, sep=""), dataFilenames))
    dataFileNameBA <- dataFilenames[idx2]
    # Mark both data files (A->B, B->A) as visited
    filesVisited[c(idx, idx2)] <- TRUE
    # Open bi-directional conferences data files (A->B, B->A)
    dataBA <- read.csv(paste(dirData, dataFileNameAB, sep="/"))
    dataAB <- read.csv(paste(dirData, dataFileNameBA, sep="/"))
    # If any of conference files is empty then skip
    if (nrow(dataAB) == 0 || nrow(dataBA) == 0) {
      next()
    }
    # Compute citation ratio time series for both directions (A->B, B->A)
    crAB <- CitationRatios(hcp, ExtractConfStartYear(dataFileNameAB), dataAB)
    crBA <- CitationRatios(hcp, ExtractConfStartYear(dataFileNameBA), dataBA)
    # Compute influence between conferences (A and B) in both directions (A->B, B->A)    
    infAB <- Influence(crAB, crBA, epsilon)
    infBA <- Influence(crBA, crAB, epsilon)

    cat(sprintf("Influence %s->%s: (has: %i? pvalue: %f); %s->%s: (has: %i? pvalue: %f)\n",
                confNames[1], confNames[2], infAB$hasInfluence, infAB$pvalue,
                confNames[2], confNames[1], infBA$hasInfluence, infBA$pvalue))

    confInfluences <- rbind(confInfluences, PrepareInfRow(confNames[1], confNames[2], infAB));
    confInfluences <- rbind(confInfluences, PrepareInfRow(confNames[2], confNames[1], infBA));
  }
  write.csv(confInfluences, paste(dirResults, format(Sys.time(), "results_%Y-%m-%d_%H-%M-%S.csv"), sep="/"),
            quote = FALSE,
            row.names = FALSE);
  confInfluences
}
