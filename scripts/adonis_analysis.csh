#!/bin/sh
#
##SBATCH --job-name=QIIME2_single
#SBATCH --time=24:00:00
#SBATCH --tasks=5
#SBATCH --nodes=1
#SBATCH --partition=bigmem

module load qiime2/2023.5.1

source $1

#get proper classifier

#echo the time for each
echo "Filter by metadata file"
date

qiime feature-table filter-samples\
 --i-table ${TABLE}\
 --m-metadata-file ${METADATA}\
 --o-filtered-table ${PREFIX}_filtered.qza

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ${TREE} \
  --i-table ${PREFIX}_filtered.qza \
  --p-sampling-depth ${DEPTH} \
  --m-metadata-file ${METADATA} \
  --output-dir ${PREFIX}_core-metrics-results

qiime diversity adonis \
--i-distance-matrix ${PREFIX}_core-metrics-results/weighted_unifrac_distance_matrix.qza\
 --m-metadata-file ${METADATA} \
--o-visualization ${PREFIX}_core-metrics-results/weighted_unifrac_distance_adonis.qzv \
--p-formula ${FORMULA}

qiime diversity adonis \
--i-distance-matrix ${PREFIX}_core-metrics-results/bray_curtis_distance_matrix.qza\
 --m-metadata-file ${METADATA} \
--o-visualization ${PREFIX}_core-metrics-results/bray_curtis_distance_adonis.qzv \
--p-formula ${FORMULA}

echo "End of script"
date

