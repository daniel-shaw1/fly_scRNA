#!/bin/bash

#SBATCH --job-name=cellrangermkref
#SBATCH --partition="cpu(all)"
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=80:00:00
#SBATCH --mem=150G
#SBATCH --output=mkref.%j.out
#SBATCH --error=mkref.%j.err

        ## Command(s) to run:
cd /mnt/beegfs/scratch/ds221041e/fly/

export PATH=~/software/cellranger-9.0.1/:$PATH


cellranger mkref --genome=cellrangerfly_genome --fasta=GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna --genes=cellranger_fly_dedup.gtf





