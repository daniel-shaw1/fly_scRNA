merged3objjoined <- readRDS(file = "merged3objjoined")

###Umap with colored cells
FeaturePlot(merged3objjoined, features = c("Dmel-CG5888.1"))
##Violin plot across clusters
VlnPlot(merged3objjoined, features = c("Dmel-CG5888.1"))
###Dots with proportion of cells expressed
DotPlot(merged3objjoined, features = c("Dmel-CG5888.1"))
##Ridge plots across clusters
RidgePlot(merged3objjoined, features = c("Dmel-CG5888.1"))


