#!/bin/sh
#
##SBATCH --job-name=filter_ANCOMD
#SBATCH --time=24:00:00
#SBATCH --tasks=1
#SBATCH --nodes=1
#SBATCH --partition=bigmem

module load qiime2/2023.5.1

#Pass the input file as a command line argument after the script
#Pass the output path as second argument (use ./ for both)

#echo the time for each
echo "Starting export"
date

#Subset to just the final timepoints

qiime tools export\
 --input-path $1 \
 --output-path $2

echo "End of script"
date

