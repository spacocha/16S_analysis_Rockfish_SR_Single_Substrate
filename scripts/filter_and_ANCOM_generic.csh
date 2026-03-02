#!/bin/sh
#
##SBATCH --job-name=filter_ANCOMD
#SBATCH --time=24:00:00
#SBATCH --tasks=5
#SBATCH --nodes=1
#SBATCH --partition=bigmem

module load qiime2/2023.5.1

#Pass the config file as a command line argument after the script
source $1

#echo the time for each
echo "Starting FINAL analysis"
date

#Subset to just the final timepoints

qiime feature-table filter-samples\
 --i-table ${TABLE}\
 --m-metadata-file ${METADATA}\
 --o-filtered-table ${PREFIX}_${SUFFIX}.qza

qiime taxa collapse \
--i-table ${PREFIX}_${SUFFIX}.qza \
--i-taxonomy ${TAXA} \
--p-level 7 \
--o-collapsed-table ${PREFIX}_${SUFFIX}-l7.qza

qiime taxa collapse \
--i-table ${PREFIX}_${SUFFIX}.qza \
--i-taxonomy ${TAXA} \
--p-level 3 \
--o-collapsed-table ${PREFIX}_${SUFFIX}-l3.qza

#Prepare for ANCOM
qiime composition add-pseudocount \
 --i-table ${PREFIX}_${SUFFIX}-l7.qza\
 --o-composition-table  ${PREFIX}_${SUFFIX}-l7_comp.qza

qiime composition add-pseudocount \
 --i-table ${PREFIX}_${SUFFIX}-l3.qza\
 --o-composition-table  ${PREFIX}_${SUFFIX}-l3_comp.qza

qiime composition ancom \
 --i-table ${PREFIX}_${SUFFIX}-l7_comp.qza\
 --m-metadata-file ${METADATA}\
 --m-metadata-column ${COL1}\
 --o-visualization ${PREFIX}_${SUFFIX}-l7_comp_${COL1}.qzv

qiime composition ancom \
 --i-table ${PREFIX}_${SUFFIX}-l3_comp.qza\
 --m-metadata-file ${METADATA}\
 --m-metadata-column ${COL1}\
 --o-visualization ${PREFIX}_${SUFFIX}-l3_comp_${COL1}.qzv

qiime composition ancom \
 --i-table ${PREFIX}_${SUFFIX}-l7_comp.qza\
 --m-metadata-file ${METADATA}\
 --m-metadata-column ${COL2}\
 --o-visualization ${PREFIX}_${SUFFIX}-l7_comp_${COL2}.qzv

qiime composition ancom \
 --i-table ${PREFIX}_${SUFFIX}-l3_comp.qza\
 --m-metadata-file ${METADATA}\
 --m-metadata-column ${COL2}\
 --o-visualization ${PREFIX}_${SUFFIX}-l3_comp_${COL2}.qzv

echo "End of script"
date

