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
source ./FAPROTAX_analysis.config

#get proper classifier

#echo the time for each
echo "Starting FAPROTAX analysis"
date


qiime taxa collapse \
--i-table ${TABLE} \
--i-taxonomy ${TAXA} \
--p-level 7 \
--o-collapsed-table ${PREFIX}_dada2_l7.qza


qiime feature-table rarefy \
 --i-table ${PREFIX}_dada2_l7.qza\
 --p-sampling-depth ${RAREDEPTH}\
 --o-rarefied-table ${PREFIX}_dada2_l7_rare.qza


qiime tools export \
 --input-path ${PREFIX}_dada2_l7_rare.qza\
 --output-path ${PREFIX}_dada2_l7_rare_dir

FAPROTAX_1.2.12/collapse_table.py -i ${PREFIX}_dada2_l7_rare_dir/feature-table.biom -o ${PREFIX}_dada2_l7_rare_dir/feature-table_FAPROTAX.txt -r ${PREFIX}_dada2_l7_rare_dir/FAPROTAX_report.txt -l ${PREFIX}_dada2_l7_rare_dir/FAPROTAX_log.txt --input_groups_file FAPROTAX_1.2.12/FAPROTAX.txt --missing_entry NO_FAPROTAX_ASSIGNMENT

biom convert -i ${PREFIX}_dada2_l7_rare_dir/feature-table_FAPROTAX.txt -o ${PREFIX}_dada2_l7_rare_dir/feature-table_FAPROTAX.biom --table-type="OTU table" --to-hdf5

qiime tools import \
 --input-path ${PREFIX}_dada2_l7_rare_dir/feature-table_FAPROTAX.biom \
 --type 'FeatureTable[Frequency]'\
 --output-path ${PREFIX}_dada2_l7_rare_FAPRO.qza

#Prepare for ANCOM
qiime composition add-pseudocount \
 --i-table ${PREFIX}_dada2_l7_rare_FAPRO.qza\
 --o-composition-table  ${PREFIX}_dada2_l7_rare_FAPRO_comp.qza

qiime composition ancom \
 --i-table ${PREFIX}_dada2_l7_rare_FAPRO_comp.qza\
 --m-metadata-file ${METADATA}\
 --m-metadata-column ${COL1}\
 --o-visualization ${PREFIX}_dada2_l7_rare_FAPRO_comp_ancom_AG2.qza

qiime composition ancom \
 --i-table ${PREFIX}_dada2_l7_rare_FAPRO_comp.qza\
 --m-metadata-file ${METADATA}\
 --m-metadata-column ${COL2}\
 --o-visualization ${PREFIX}_dada2_l7_rare_FAPRO_comp_ancom_Inh.qza

echo "End of script"
date

