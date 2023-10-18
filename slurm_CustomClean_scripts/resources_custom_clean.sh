#!/bin/bash -l

#SBATCH -J customclean
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH -c 2
#SBATCH --mem=180G
#SBATCH --tmp=100gb
#SBATCH -t 5:00:00
#SBATCH -p amd512,amdsmall,amdlarge,ram256g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lmoore@umn.edu
#SBATCH -o output_logs/customclean_%A_%a.out
#SBATCH -e output_logs/customclean_%A_%a.err
#SBATCH -A feczk001

cd run_files.custom_clean

module load singularity

file=run${SLURM_ARRAY_TASK_ID}

bash ${file}