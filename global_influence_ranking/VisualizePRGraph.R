VisualizePRGraph <- function(gpr, title) {
  layout_gpr <- layout_in_circle(gpr, order=order(V(gpr)$pagerank))
  plot(gpr,
       vertex.size=rank(V(gpr)$pagerank)*0.5,
       layout=layout_gpr,
       vertex.label.color="navy",
       vertex.label.cex=1.2)
  title(title)
}