#!/bin/sh
#
##SBATCH --job-name=QIIME2_single
#SBATCH --time=24:00:00
#SBATCH --tasks=5
#SBATCH --nodes=1
#SBATCH --partition=bigmem

module load qiime2/2023.5.1

#config file will download FAPROTAX
#Do only once
source ./FINAL_analysis.config

#get proper classifier

#echo the time for each
echo "Starting FINAL analysis"
date

#Subset to just the final timepoints

qiime feature-table filter-samples\
 --i-table ${TABLE}\
 --m-metadata-file ${METADATA}\
 --p-where '[Timepoint] IN ("5","7","10")'\
 --o-filtered-table ${PREFIX}_table_finaltps.qza

qiime taxa collapse \
--i-table ${PREFIX}_table_finaltps.qza \
--i-taxonomy ${TAXA} \
--p-level 7 \
--o-collapsed-table ${PREFIX}_table_finaltps-l7.qza

qiime taxa collapse \
--i-table ${PREFIX}_table_finaltps.qza \
--i-taxonomy ${TAXA} \
--p-level 3 \
--o-collapsed-table ${PREFIX}_table_finaltps-l3.qza

#Prepare for ANCOM
qiime composition add-pseudocount \
 --i-table ${PREFIX}_table_finaltps-l7.qza\
 --o-composition-table  ${PREFIX}_table_finaltps-l7_comp.qza

qiime composition add-pseudocount \
 --i-table ${PREFIX}_table_finaltps-l3.qza\
 --o-composition-table  ${PREFIX}_table_finaltps-l3_comp.qza

qiime composition ancom \
 --i-table ${PREFIX}_table_finaltps-l7_comp.qza\
 --m-metadata-file ${METADATA}\
 --m-metadata-column ${COL1}\
 --o-visualization ${PREFIX}_table_finaltps-l7_comp_${COL1}.qzv

qiime composition ancom \
 --i-table ${PREFIX}_table_finaltps-l3_comp.qza\
 --m-metadata-file ${METADATA}\
 --m-metadata-column ${COL1}\
 --o-visualization ${PREFIX}_table_finaltps-l3_comp_${COL1}.qzv

qiime composition ancom \
 --i-table ${PREFIX}_table_finaltps-l7_comp.qza\
 --m-metadata-file ${METADATA}\
 --m-metadata-column ${COL2}\
 --o-visualization ${PREFIX}_table_finaltps-l7_comp_${COL2}.qzv

qiime composition ancom \
 --i-table ${PREFIX}_table_finaltps-l3_comp.qza\
 --m-metadata-file ${METADATA}\
 --m-metadata-column ${COL2}\
 --o-visualization ${PREFIX}_table_finaltps-l3_comp_${COL2}.qzv

echo "End of script"
date

