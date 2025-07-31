 ###Set working directory to folder that conatines filtered matrix
 setwd("C:/Users/danie/OneDrive/Documents/Postdoc/flyscrna/cellrangerouts/Library2")


install.packages("Seurat")
install.packages("dplyr")
install.packages("patchwork")
install.packages("ggplot2")

###Software needed. Use install.packages("Seurat") if not installed before
library(dplyr)
library(Seurat)
library(patchwork)
library(ggplot2)

# Load the PBMC dataset
pbmc.data <- Read10X(data.dir = "filtered_feature_bc_matrix")

# Initialize the Seurat object with the raw (non-normalized data).
pbmc <- CreateSeuratObject(counts = pbmc.data, project = "library12_nhe2null_rep3", min.cells = 3, min.features = 200)
pbmc

###Identify number of RNA molecules and genes in cells and plot

VlnPlot(pbmc, features = c("nFeature_RNA", "nCount_RNA"), ncol = 2)

plot1 <- FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 = "percent.mt")
plot2 <- FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
plot1 + plot2



# filter cells based on number of nFeature
pbmc <- subset(pbmc, subset = nFeature_RNA > 270 & nFeature_RNA < 2000)

###Log normalize expression
pbmc <- NormalizeData(pbmc, normalization.method = "LogNormalize", scale.factor = 10000)

pbmc <- NormalizeData(pbmc)

####This will find the most variably expressed genes that we will use to avoid clustering on noise
pbmc <- FindVariableFeatures(pbmc, selection.method = "vst", nfeatures = 2000)

# Identify the 10 most highly variable genes
top10 <- head(VariableFeatures(pbmc), 10)

# plot variable features with and without labels
plot1 <- VariableFeaturePlot(pbmc)
plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
plot1 + plot2

###set gene names 
all.genes <- rownames(pbmc)

###Normalize expression across cluster with Scaledata
pbmc <- ScaleData(pbmc, features = all.genes)



###RUN PCA
pbmc <- RunPCA(pbmc, features = VariableFeatures(object = pbmc))


print(pbmc[["pca"]], dims = 1:5, nfeatures = 5)


VizDimLoadings(pbmc, dims = 1:2, reduction = "pca")

###Plot PCA
DimPlot(pbmc, reduction = "pca")




# NOTE: This process can take a long time for big datasets, comment out for expediency. More
# approximate techniques such as those implemented in ElbowPlot() can be used to reduce
# computation time
pbmc <- JackStraw(pbmc, num.replicate = 100)
pbmc <- ScoreJackStraw(pbmc, dims = 1:20)

JackStrawPlot(pbmc, dims = 1:20)

###Determing number of signficant dims
ElbowPlot(pbmc)

###Clustering, Can alter dims and resolution to change UMAP projection and number of clustering
pbmc <- FindNeighbors(pbmc, dims = 1:15)
pbmc <- FindClusters(pbmc, resolution = 0.4)



pbmc <- RunUMAP(pbmc, dims = 1:15)


#Plot UMAP
DimPlot(pbmc, reduction = "umap")


###save R obj
saveRDS(pbmc, file = "merged3obj")



###open file after logging out of R
pbmc <- readRDS(file = "pbmc")


###Identify all differentially expressed genes one cluster vs all others

pbmc.markers <- FindAllMarkers(pbmc, only.pos = TRUE)
pbmc.markers %>%
    group_by(cluster) %>%
    dplyr::filter(avg_log2FC > 1)
	
write.table(pbmc.markers, file='allmarkersall.txt')

	
