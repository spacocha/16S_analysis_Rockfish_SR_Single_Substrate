#!/bin/sh
#
##SBATCH --job-name=QIIME2_single
#SBATCH --time=24:00:00
#SBATCH --tasks=5
#SBATCH --nodes=1
#SBATCH --partition=bigmem

module load qiime2/2023.5.1

source ./taxonomy_only.config

#taxonomy
echo "Starting taxonomic analysis"
date

qiime feature-classifier classify-sklearn \
  --i-classifier ${CLASSI} \
  --i-reads ${REPS} \
  --o-classification ${PREFIX}_taxonomy.qza

qiime metadata tabulate \
  --m-input-file ${PREFIX}_taxonomy.qza \
  --o-visualization ${PREFIX}_taxonomy.qzv

qiime taxa barplot \
	--i-table ${TABLE} \
	--i-taxonomy ${PREFIX}_taxonomy.qza \
	--m-metadata-file ${METADATA} \
	--o-visualization ${PREFIX}_taxonomy_barplots.qzv

echo "End of script"
date

