#!/bin/sh
#
##SBATCH --job-name=QIIME2_single
#SBATCH --time=24:00:00
#SBATCH --tasks=1
#SBATCH --nodes=1
#SBATCH --partition=bigmem

module load qiime2/2023.5.1
module load r/4.2.0

source ./filter_and_quantify.config

#taxonomy
echo "Filter for Biomass and experiment"
date

cat ${METADATA} | grep "sample-id" > ${METADATA}_biomass_exp
cat ${METADATA} | grep "biomass" | grep "experiment" >> ${METADATA}_biomass_exp

#Keep only the biomass or biomass inhibition samples
qiime feature-table filter-samples \
 --i-table ${TABLE}\
 --m-metadata-file ${METADATA}_biomass_exp \
 --o-filtered-table ${PREFIX}_biomass_exp.qza

#merge by OriginalName
qiime feature-table group \
 --i-table ${PREFIX}_biomass_exp.qza\
 --p-axis 'sample'\
 --m-metadata-file ${METADATA}\
 --m-metadata-column OriginalName\
 --p-mode 'sum' \
 --o-grouped-table ${PREFIX}_biomass_exp_group.qza

qiime feature-table filter-seqs\
 --i-data ${REPS}\
 --i-table ${PREFIX}_biomass_exp_group.qza\
 --o-filtered-data ${PREFIX}_biomass_exp_group_reps.qza

#export the table to choose the read count
qiime tools export --input-path ${PREFIX}_biomass_exp_group.qza --output-path ${PREFIX}_biomass_exp_group_dir

biom convert -i ${PREFIX}_biomass_exp_group_dir/feature-table.biom -o ${PREFIX}_biomass_exp_group_dir/feature-table.biom.txt --table-type="OTU table" --to-tsv

#Use this file to figure out the sampling depth for core-metrics
perl ../../scripts/sum_mat_cols_qiime.pl ${PREFIX}_biomass_exp_group_dir/feature-table.biom.txt > ${PREFIX}_biomass_exp_group_dir/feature-table.biom.count.txt 

echo "End of script"
date

