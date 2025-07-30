#######creating merged matrix of all conditions, use objects from obove, and give new ids. 

###Use merge commmand to combine multiple R objects in this expample i named each library R object as lib1, lib2, etc. 
merged2 <- merge(lib1, y = c(lib2, lib3, lib4, lib5, lib6, lib7, lib8, lib9, lib10, lib11), add.cell.ids = c("control_rep1", "nhe3_null_rep1", "control_BF_rep1", "nhe2_null_rep1", "control_rep2", "control_rep3", "nhe3_null_rep2", "nhe3_null_rep3", "control_BF_rep2", "control_BF_rep3", "nhe2_null_rep2"), project = "Merged_samples_flybrain",
    merge.data = TRUE)
	
###Normalize across conditions, created new name 'merged3', so that you can go back to unnromalized if needed

all.genes <- rownames(merged2)

merged3 <- NormalizeData(merged2, normalization.method = "LogNormalize", scale.factor = 10000)
merged3 <- ScaleData(merged3, features = all.genes)
##subset to varfeatures due to memory
merged3 <- ScaleData(merged3, features = VariableFeatures(object = merged3))


####Find variable features

merged3 <- FindVariableFeatures(merged3, selection.method = "vst", nfeatures = 8000)

###Run pca on merged sample

merged3 <- RunPCA(merged3, features = VariableFeatures(object = merged3))



ElbowPlot(merged3)

###Find neighbros - 15 dimensions
merged3 <- FindNeighbors(merged3, dims = 1:15)

###clustering based on resolution .4-- renamed so you can try other dimensions if wanted.
merged3res.4 <- FindClusters(merged3, resolution = 0.4)


###Run and plot umap based on identities

obj <- RunUMAP(merged3res.4, dims = 1:15)  


DimPlot(obj, reduction = "umap", split.by = "orig.ident")

###Identify all differentially expressed genes one cluster vs all others for all treatments

obj.markers <- FindAllMarkers(obj, only.pos = TRUE)
obj.markers %>%
    group_by(cluster) %>%
    dplyr::filter(avg_log2FC > 1)
	
write.table(obj.markers, file='allmarkers_total.txt')


