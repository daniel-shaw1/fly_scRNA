# fly_scRNA
Repository for single nuclei RNA analysis for D. mel brain

1. pre_countsworkflow-- sets up enviornment and downloads cellranger, fasta reference, and annotation
2. dedup.py- fixes gtf to work with cellranger
3. mkref.sh- formats reference for cellranger
4. count.sh- uses cell ranger to generate counts
5. seruat_singlesample.r- performs QC filtering, clustering, umap, and DE for one sample
6. merge.r- merges multiple sample objects together and creates merged umap
7. plotexpression- base file for making plots 
