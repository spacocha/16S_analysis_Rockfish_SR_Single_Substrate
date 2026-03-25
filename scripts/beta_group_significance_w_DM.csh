#!/bin/sh
#
##SBATCH --job-name=QIIME2_single
#SBATCH --time=24:00:00
#SBATCH --tasks=5
#SBATCH --nodes=1
#SBATCH --partition=bigmem

module load qiime2/2023.5.1

source ./beta_group_significance_w_DM.config

#get proper classifier

#echo the time for each
echo "Starting beta groups analysis"
date

qiime diversity-lib weighted-unifrac \
 --i-table ${TABLE}\
 --i-phylogeny ${TREE}\
 --o-distance-matrix ${PREFIX}_weighted-unifrac_distance_matrix.qza

qiime diversity-lib bray-curtis \
 --i-table ${TABLE}\
 --o-distance-matrix ${PREFIX}_bray_curtis_distance_matrix.qza


qiime diversity beta-group-significance \
 --i-distance-matrix ${PREFIX}_bray_curtis_distance_matrix.qza  \
 --m-metadata-file ${METADATA} \
 --m-metadata-column ${COL} \
 --o-visualization ${PREFIX}_BC_${COL}.qzv \
 --p-pairwise

qiime diversity beta-group-significance \
 --i-distance-matrix ${PREFIX}_weighted-unifrac_distance_matrix.qza  \
 --m-metadata-file ${METADATA} \
 --m-metadata-column ${COL} \
 --o-visualization ${PREFIX}_WUnifrac_${COL}.qzv \
 --p-pairwise

echo "End of script"
date

