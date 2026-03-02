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

qiime feature-table filter-samples\
 --i-table ${FAPROTABLE}\
 --m-metadata-file ${METADATA}\
 --o-filtered-table ${PREFIX}_FAPROTAX_filtered.qza


echo "Starting alignment and tree"
date


qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ${TREE} \
  --i-table ${PREFIX}_filtered.qza \
  --p-sampling-depth ${DEPTH} \
  --m-metadata-file ${METADATA} \
  --output-dir ${PREFIX}_core-metrics-results

#group significance
echo "Starting alpha diversity significance"
date

qiime diversity alpha-group-significance \
  --i-alpha-diversity ${PREFIX}_core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file ${METADATA} \
  --o-visualization ${PREFIX}_core-metrics-results/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity ${PREFIX}_core-metrics-results/evenness_vector.qza \
  --m-metadata-file ${METADATA} \
  --o-visualization ${PREFIX}_core-metrics-results/evenness-group-significance.qzv

echo "Beta diversity"
date
qiime emperor plot \
  --i-pcoa ${PREFIX}_core-metrics-results/weighted_unifrac_pcoa_results.qza \
  --m-metadata-file ${METADATA} \
  --o-visualization ${PREFIX}_core-metrics-results/weighted-unifrac-emperor.qzv

qiime emperor plot \
  --i-pcoa ${PREFIX}_core-metrics-results/bray_curtis_pcoa_results.qza \
  --m-metadata-file ${METADATA} \
  --o-visualization ${PREFIX}_core-metrics-results/bray-curtis-emperor.qzv

#alpha
echo "Alpha rarefaction"
date

qiime diversity alpha-rarefaction \
  --i-table ${PREFIX}_filtered.qza \
  --i-phylogeny ${TREE} \
  --p-max-depth ${DEPTH} \
  --m-metadata-file ${METADATA} \
  --o-visualization ${PREFIX}_alpha-rarefaction.qzv


#taxonomy
echo "Starting taxonomic analysis"
date


#Subset to just the final timepoints

qiime taxa collapse \
--i-table ${PREFIX}_filtered.qza \
--i-taxonomy ${TAXA} \
--p-level 7 \
--o-collapsed-table ${PREFIX}_filtered-l7.qza

qiime taxa collapse \
--i-table ${PREFIX}_filtered.qza \
--i-taxonomy ${TAXA} \
--p-level 3 \
--o-collapsed-table ${PREFIX}_filtered-l3.qza

#Prepare for ANCOM
qiime composition add-pseudocount \
 --i-table ${PREFIX}_filtered-l7.qza\
 --o-composition-table  ${PREFIX}_filtered-l7_comp.qza

qiime composition add-pseudocount \
 --i-table ${PREFIX}_filtered-l3.qza\
 --o-composition-table  ${PREFIX}_filtered-l3_comp.qza

qiime composition ancom \
 --i-table ${PREFIX}_filtered-l7_comp.qza\
 --m-metadata-file ${METADATA}\
 --m-metadata-column ${COL1}\
 --o-visualization ${PREFIX}_filtered-l7_comp_${COL1}.qzv

qiime composition ancom \
 --i-table ${PREFIX}_filtered-l3_comp.qza\
 --m-metadata-file ${METADATA}\
 --m-metadata-column ${COL1}\
 --o-visualization ${PREFIX}_filtered-l3_comp_${COL1}.qzv

#Also do FAPROTAX table
qiime composition add-pseudocount \
 --i-table ${PREFIX}_FAPROTAX_filtered.qza\
 --o-composition-table  ${PREFIX}_FAPROTAX_filtered_comp.qza

qiime composition ancom \
 --i-table ${PREFIX}_FAPROTAX_filtered_comp.qza\
 --m-metadata-file ${METADATA}\
 --m-metadata-column ${COL1}\
 --o-visualization ${PREFIX}_FAPROTAX_filtered_comp_${COL1}.qzv

#beta group significance
qiime diversity beta-group-significance \
 --i-distance-matrix ${PREFIX}_core-metrics-results/bray_curtis_distance_matrix.qza  \
 --m-metadata-file ${METADATA} \
 --m-metadata-column ${COL1} \
 --o-visualization ${PREFIX}_core-metrics-results/${PREFIX}_BC_${COL1}.qzv \
 --p-pairwise

qiime diversity beta-group-significance \
 --i-distance-matrix ${PREFIX}_core-metrics-results/weighted_unifrac_distance_matrix.qza  \
 --m-metadata-file ${METADATA} \
 --m-metadata-column ${COL1} \
 --o-visualization ${PREFIX}_core-metrics-results/${PREFIX}_WUF_${COL1}.qzv \
 --p-pairwise


echo "End of script"
date

