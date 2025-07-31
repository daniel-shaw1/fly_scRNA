unique(merged3objjoined$orig.ident)
 [1] "library1_control_rep1"    "library2_nhe3null_rep1"   "library3_controlbp_rep1" 
 [4] "library4_nhe2null_rep1"   "library5_control_rep2"    "library6_control_rep3"   
 [7] "library7_nhe3null_rep2"   "library8_nhe3null_rep3"   "library9_control_rep2"   
[10] "library10_controlBF_rep3" "library11_nhe2null_rep2" 

merged3objjoined$condition <- case_when(
+     grepl("control", merged3objjoined$orig.ident) ~ "control",
+     grepl("nhe3null", merged3objjoined$orig.ident) ~ "nhe3null",
+     grepl("nhe2null", merged3objjoined$orig.ident) ~ "nhe2null",
+     TRUE ~ "other"
+ )

de_nhe3_vs_control <- FindMarkers(
+     merged3objjoined,
+     ident.1 = "nhe3null",
+     ident.2 = "control",
+     only.pos = TRUE
+ )


de_nhe2_vs_control <- FindMarkers(
+     merged3objjoined,
+     ident.1 = "nhe2null",
+     ident.2 = "control",
+     only.pos = TRUE,
+     logfc.threshold = 0.25,
+     min.pct = 0.15
+ )



merged3objjoined$cluster_condition <- paste0(
+     merged3objjoined$seurat_clusters, "_", merged3objjoined$condition
+ )
 
 Idents(merged3objjoined) <- "cluster_condition"
 
 library(Seurat)
 library(dplyr)
 
 # 1. Make sure your cluster labels are accessible
 # Replace with your actual clustering column if different
 merged3objjoined$cluster <- merged3objjoined$seurat_clusters
 
 # 2. Combine cluster and condition
 merged3objjoined$cluster_condition <- paste0(
+     merged3objjoined$cluster, "_", merged3objjoined$condition
+ )
 
 # 3. Set this as identity
 Idents(merged3objjoined) <- "cluster_condition"
 
 # 4. Get all unique cluster numbers
 clusters <- unique(merged3objjoined$cluster)
 
 # 5. Create empty list to hold DE results
 de_results <- list()
 
 # 6. Loop over each cluster and run DE: nhe3null vs control
 for (clust in clusters) {
+     ident1 <- paste0(clust, "_nhe3null")
+     ident2 <- paste0(clust, "_control")
+     
+     # Check if both identities exist
+     if (ident1 %in% levels(merged3objjoined) && ident2 %in% levels(merged3objjoined)) {
+         message("Running DE for cluster ", clust, ": nhe3null vs control")
+         
+         markers <- FindMarkers(
+             merged3objjoined,
+             ident.1 = ident1,
+             ident.2 = ident2,
+             only.pos = TRUE,
+             logfc.threshold = 0.25,
+             min.pct = 0.1
+         )
+         
+         # Add to list
+         de_results[[paste0("cluster_", clust)]] <- markers
+         
+         # Optional: Save each to a CSV
+         # write.csv(markers, paste0("DE_cluster_", clust, "_nhe3null_vs_control.csv"))
+     } else {
+         message("Skipping cluster ", clust, ": missing identity group")
+     }
+ }




merged3objjoined$cluster <- merged3objjoined$seurat_clusters
 
 # 2. Combine cluster and condition
 merged3objjoined$cluster_condition <- paste0(
+     merged3objjoined$cluster, "_", merged3objjoined$condition
+ )
 
 # 3. Set this as identity
 Idents(merged3objjoined) <- "cluster_condition"
 
 # 4. Get all unique cluster numbers
 clusters <- unique(merged3objjoined$cluster)
 
 # 5. Create empty list to hold DE results
 de_results <- list()
 
 # 6. Loop over each cluster and run DE: nhe3null vs control
 for (clust in clusters) {
+     ident1 <- paste0(clust, "_nhe2null")
+     ident2 <- paste0(clust, "_control")
+     
+     # Check if both identities exist
+     if (ident1 %in% levels(merged3objjoined) && ident2 %in% levels(merged3objjoined)) {
+         message("Running DE for cluster ", clust, ": nhe3null vs control")
+         
+         markers <- FindMarkers(
+             merged3objjoined,
+             ident.1 = ident1,
+             ident.2 = ident2,
+             only.pos = TRUE,
+             logfc.threshold = 0.25,
+             min.pct = 0.1
+         )
+         
+         # Add to list
+         de_results[[paste0("cluster_", clust)]] <- markers
+         
+         # Optional: Save each to a CSV
+         write.csv(markers, paste0("DE_cluster_", clust, "_nhe2null_vs_control.csv"))
+     } else {
+         message("Skipping cluster ", clust, ": missing identity group")
+     }
+ }



