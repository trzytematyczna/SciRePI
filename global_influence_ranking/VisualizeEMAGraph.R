VisualizeEMAGraph <- function(g, title) {
  layout <- layout_nicely(g)
  plot(g, 
       vertex.size=rank(V(g)$ema)*0.5,
       edge.arrow.size=.15, 
       layout=layout,
       vertex.frame.color="grey",
       edge.color="grey",
       vertex.color="lightblue",
       vertex.label.color="black",
       vertex.label.cex=1.3)
  title(title)
}