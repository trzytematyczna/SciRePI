VisualizeInfluenceGraph <- function(g) {
  layout <- layout_with_kk(g)
  plot(g, 
      # vertex.size=rank(V(g)$ema)*0.5,
       edge.arrow.size=.2, 
       layout=layout,
       vertex.label.color="navy",
       vertex.label.cex=1.2)
}