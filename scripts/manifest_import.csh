#!/bin/sh
#
##SBATCH --job-name=QIIME2_single
#SBATCH --time=24:00:00
#SBATCH --partition=bigmem
#SBATCH --nodes=1

module load qiime2/2023.5.1

qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path MANIFEST_file_list.csv --output-path demux.qza --input-format PairedEndFastqManifestPhred33
qiime demux summarize --i-data demux.qza --o-visualization demux.qzv

