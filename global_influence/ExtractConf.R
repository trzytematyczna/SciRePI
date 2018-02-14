###
# ExtractConf:
#   Extract conference names from data filename (in lexical order)
###
ExtractConf <- function(filename) {
  names <- strsplit(filename, "_")[[1]][1]
  strsplit(names, "-")[[1]]
}