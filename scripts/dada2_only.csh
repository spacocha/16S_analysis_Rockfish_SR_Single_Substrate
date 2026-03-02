#!/bin/sh
#
##SBATCH --job-name=QIIME2_single
#SBATCH --time=48:00:00
#SBATCH --tasks=1
#SBATCH --cpus-per-task=5
#SBATCH --nodes=1
#SBATCH --partition=bigmem


module load qiime2/2023.5.1

source ./dada2_only.config



echo "Starting dada2"

date

qiime dada2 denoise-paired --i-demultiplexed-seqs demux.qza --p-trim-left-f 19 --p-trim-left-r 20 --p-trunc-len-f 250 --p-trunc-len-r 240 --o-representative-sequences ${OUTPUT}/reps.qza --o-table ${OUTPUT}/table-dada2.qza --o-denoising-stats ${OUTPUT}/stats-dada2.qza

qiime feature-table summarize --i-table ${OUTPUT}/table-dada2.qza --o-visualization ${OUTPUT}/table-dada2_summarize.qzv --m-sample-metadata-file sample_metadata.tsv

echo "End of dada2"
date



