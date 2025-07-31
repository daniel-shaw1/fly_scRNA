#!/bin/bash

#SBATCH --job-name=cellrangercounts
#SBATCH --partition="cpu(all)"
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --time=100:00:00
#SBATCH --mem=80G
#SBATCH --output=counts.%j.out
#SBATCH --error=counts.%j.err

        ## Command(s) to run:
        ###change path to your desired output folder
cd /mnt/beegfs/scratch/ds221041e/fly/

export PATH=~/software/cellranger-9.0.1/:$PATH

cellranger count --id=samplelib1 \
           --transcriptome=/mnt/beegfs/scratch/ds221041e/fly/cellrangerfly_genome/ \ ###path to where the mkref output directory is on your folder
           --fastqs=/mnt/beegfs/scratch/bl180922/data/01.RawData/Lib_1/ \    ###path to where the fastq reads are
           --sample=Lib_1-SI_TT_A1_22V5MTLT4 \
           --create-bam=true \
           --localcores=8 \
           --localmem=64





