salloc --ntasks=10 --mem-per-cpu=20G

##download dmel genome and annotation from ncbi
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/215/GCF_000001215.4_Release_6_plus_ISO1_MT/GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.gtf.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/215/GCF_000001215.4_Release_6_plus_ISO1_MT/GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna.gz

###download cellranger

wget -O cellranger-9.0.1.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-9.0.1.tar.gz?Expires=1751106137&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA&Signature=maUd0gHecJavzqtmz4wNb48Wso47EFrf4J23DKHR3I0BYSzUNvnz-F9IcVK-6rRFG1F88VugpZj~LmmsOHcOylUtFMl70a7G0jvEhdwudubm6hnsgFujLFffh9M4SypS5CI0Xcp-Wq8-UCEB~xWql7awiVow9pyeJ~EHEpbJkm50yIx93ago5dVvpMHZj7gu2RGHvop4nkW3Matn8SxDyFnORfQ9hEo2~bVnvC6SnJkee4L5aJjhmHVSF6iIa9zvx62x9b2Iujfy69~9CsGHKhwGteqAHtJ5Fjw--V2HUr~xSVX58GsUZIRxEDQryKHtDtd6JBbg2Mp1iDSmvkQD1A__"

##unpack 

tar -xzvf cellranger-9.0.1.tar.gz


##move to home directory so that you can use it easily from any directory 

mv cellranger-9.0.1/ /mnt/beegfs/hellgate/home/ds221041e/software/


##export path so that you can call cellranger from command line and source

export PATH=~/software/cellranger-9.0.1/:$PATH
source ~/.bashrc

##verfiy that cellranger is loaded properly, manual with commands should appear if so, if not, it will say command not found
cellranger --help

###Needed to go back and clean gtf to remove ambiguous strands after receiving error in mkref
zcat GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.gtf.gz | awk '$7 == "+" || $7 == "-" || $0 ~ /^#/' > cleaned.gtf

###Cellranger does not allow duplicate gene names in gtf in the case of Isoforms. I used dedup.py script to count duplicate genes and add a digit to each name so that all duplicates can be used in cellranger

##format gtf for cellranger
cellranger mkgtf cleaned.gtf cellranger_fly_filtered.gtf --attribute=gene_biotype:protein_coding


###index reference with annotation using mkref,, run as a slurm script, needs > 80G memory, needs new name if running twice can't overwrite output folder if you need to run it twice
export PATH=~/software/cellranger-9.0.1/:$PATH


