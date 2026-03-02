#!/bin/sh
#
##SBATCH --job-name=QIIME2_single
#SBATCH --time=24:00:00
#SBATCH --tasks=1
#SBATCH --nodes=1
#SBATCH --partition=bigmem

module load qiime2/2023.5.1
module load r/4.2.0

source ./quality_control_biomass.config

#taxonomy
echo "Export table"
date

qiime tools export \
 --input-path ${TABLE}\
 --output-path ${PREFIX}_dir

biom convert -i ${PREFIX}_dir/feature-table.biom -o ${PREFIX}_dir/feature-table.biom.txt --table-type="OTU table" --to-tsv

qiime tools export --input-path ${TAXA} --output-path ${TAXAPRE}_dir

#Only do this once
git clone https://github.com/LuiseRauer/MicrobIEM.git

#Remove the extra first line of the OTU table
grep -v "# Constructed from biom file" ${PREFIX}_dir/feature-table.biom.txt > ${PREFIX}_dir/feature-table.biom.txt2

#Remove \# and Change OTU ID to OTU_ID
perl ../../scripts/adjust_mat.pl ${PREFIX}_dir/feature-table.biom.txt2 > ${PREFIX}_dir/feature-table.biom.txt3

#Run the Rscript
Rscript ../../scripts/MicrobIEM_R_script.R

#Remove those from the table and sequeces

qiime feature-table filter-features --i-table ${TABLE} --m-metadata-file ASV_contam_names.txt  --o-filtered-table ${PREFIX}.qza --p-exclude-ids

qiime feature-table filter-seqs --i-data ${REPS} --o-filtered-data ${PREFIX}_reps.qza --m-metadata-file ASV_contam_names.txt --p-exclude-ids

qiime quality-control exclude-seqs\
 --i-query-sequences ${PREFIX}_reps.qza \
 --i-reference-sequences ../../db/Biomass_Seqs_wFullLengths.qza\
 --p-method blast \
 --p-perc-identity 0.97 \
 --p-perc-query-aligned 0.97 \
 --o-sequence-hits ${PREFIX}_reps_qc_hits.qza \
 --o-sequence-misses ${PREFIX}_reps_qc_misses.qza

qiime feature-table filter-features \
 --i-table ${PREFIX}.qza \
 --m-metadata-file ${PREFIX}_reps_qc_hits.qza \
 --o-filtered-table  ${PREFIX}_hits_removed.qza \
 --p-exclude-ids

#Remove eukaryotic taxa and chloroplasts

qiime taxa filter-table \
 --i-table ${PREFIX}_hits_removed.qza \
 --i-taxonomy ${TAXA} \
 --p-exclude mitochondria,chloroplast \
 --o-filtered-table ${PREFIX}_hits_removed_no_euks.qza

qiime feature-table filter-seqs \
 --i-data ${PREFIX}_reps.qza\
 --i-table ${PREFIX}_hits_removed_no_euks.qza\
 --o-filtered-data ${PREFIX}_reps_hits_removed_no_euks.qza


echo "End of script"
date

