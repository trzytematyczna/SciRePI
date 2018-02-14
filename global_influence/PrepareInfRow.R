PrepareInfRow <- function(A, B, influence, epsilon=1e-2) {
  if (influence$hasInfluence) {
    data.frame(confFrom=A, confTo=B, pvalue=influence$pvalue)
  } else {
    NULL
  }
}
