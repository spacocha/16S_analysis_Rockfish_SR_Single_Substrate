# 16S_analysis_Rockfish_SR_Single_Substrate
#Analysis of the V4V5 region of the 16S rRNA gene from inocula and enrichments grown on single substrates.

#Start with the cleaned ASV table from the 16S_analysis_Rockfish_SR_Biomass pipeline (before filter_and_quantify.csh step)

cp ../../../16S_analysis_Rockfish_SR_Biomass/analysis/kabirs_merged/merged_dada2_MicrobIEM_hits_removed_no_euks.qza .

cp ../../../16S_analysis_Rockfish_SR_Biomass/analysis/kabirs_merged/merged_dada2_MicrobIEM_reps_hits_removed_no_euks.qza .

cp ../../../16S_analysis_Rockfish_SR_Biomass/analysis/kabirs_merged/sample-metadata.tsv .

cp ../../../16S_analysis_Rockfish_SR_Biomass/analysis/kabirs_merged/emp_paired_MPA_taxonomy.qza .

cp ../../../16S_analysis_Rockfish_SR_Biomass/db/V4-V5_classifier.qza ../../db/.

cp -r ../../../16S_analysis_Rockfish_SR_Biomass/config_files/ ../../.

cp -r ../../../16S_analysis_Rockfish_SR_Biomass/scripts/ ../../.

#Begin to filter by the substrate and sediment samples

cp ../../config_files/filter_and_quantify.config .

#edit to make sure it's the right variables and submit

sbatch ../../scripts/filter_and_quantify.csh 

#Fix the metadata file to have group names manually and rename

cp ../../config_files/exp_only_moving_pictures.config .

sbatch ../../scripts/exp_only_moving_pictures.csh

#Test beta diversity difference between substrates

cp ../../config_files/beta_group_significance.config  .

sbatch ../../scripts/beta_group_significance.csh 

#make the filtered metadata file

cat sample-metadata.tsv_substrate_exp_group.txt | grep "substrates" | grep -v "T0" >> sample-metadata_biomass_exp_group_SS_FINAL.txt

#Copy and edit with new metadata file and prefixes

cp ../../config_files/filter_and_ANCOM_generic.config .

#Run the script

sbatch ../../scripts/filter_and_ANCOM_generic.csh ./filter_and_ANCOM_generic.config
