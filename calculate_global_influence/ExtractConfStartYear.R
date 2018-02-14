###
# ExtractConfStartYear:
#   Extract conference common start year from CSV filename.
###
ExtractConfStartYear <- function(filename) {
  names <- strsplit(filename, "_")[[1]][2]
  as.integer(strsplit(names, "-")[[1]][1])
}