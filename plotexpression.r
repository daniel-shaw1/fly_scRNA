library(Seurat)
library(SeuratData)
library(ggplot2)
library(patchwork)

merged3objjoined <- readRDS(file = "merged3objjoined")

###Umap with colored cells
FeaturePlot(merged3objjoined, features = c("Dmel-CG5888.1"))
##Violin plot across clusters
VlnPlot(merged3objjoined, features = c("Dmel-CG5888.1"))
###Dots with proportion of cells expressed
DotPlot(merged3objjoined, features = c("Dmel-CG5888.1"))
##Ridge plots across clusters
RidgePlot(merged3objjoined, features = c("Dmel-CG5888.1"))

##heatmap across clusters
DoHeatmap(subset(merged3objjoined, downsample = 100), features = features, size = 3)

## blen multiple features to look for coexpression
FeaturePlot(pbmc3k.final, features = c("MS4A1", "CD79A"), blend = TRUE)



