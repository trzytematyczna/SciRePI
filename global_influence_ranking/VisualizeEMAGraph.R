VisualizeEMAGraph <- function(g, title) {
  layout <- layout_in_circle(g, order=order(V(g)$ema))
  plot(g, 
       vertex.size=rank(V(g)$ema)*0.5,
       edge.arrow.size=.2, 
       layout=layout,
       vertex.label.color="navy",
       vertex.label.cex=1.2)
  title(title)
}