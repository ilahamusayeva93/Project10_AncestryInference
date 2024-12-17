#!/bin/bash
#SBATCH --job-name=bwa_mem2_alignment  # Job name
#SBATCH --output=bwa_mem2_alignment.log  # Output log file
#SBATCH --error=bwa_mem2_alignment.err   # Error log file
#SBATCH --ntasks=1                      # Number of tasks
#SBATCH --cpus-per-task=24              # Number of CPU cores to use
#SBATCH --mem=200G                      # Memory limit
#SBATCH --time=18:00:00                 # Maximum execution time (12 hours)
#SBATCH --partition=pace-cpu            # Use correct partition

# Email notifications (BEGIN, END, FAIL)
#SBATCH --mail-user=imusayeva3@gatech.edu
#SBATCH --mail-type=BEGIN,END,FAIL

# Path to PLINK binary files and Admixture tool
ADMIXTURE_OUTPUT_DIR="/home/hice1/imusayeva3/biol6150/ProjectSubmissions/Group6/Project10/Admixture_Results"
ADMIXTURE_PATH="/home/hice1/imusayeva3/biol6150/ProjectSubmissions/Group6/Project10/dist/admixture_linux-1.3.0/admixture"
PLINK_BASE_PATH="/home/hice1/imusayeva3/biol6150/ProjectSubmissions/Group6/Project10/Plink_Binary"

# Create the output directory if it doesn't exist
mkdir -p $ADMIXTURE_OUTPUT_DIR

# Define K values to test
K_VALUES=(2 3 4)

# Iterate through all chromosomes (1–22) and K values
for chrom in {1..22}; do
  for k in "${K_VALUES[@]}"; do
    PLINK_PREFIX="${PLINK_BASE_PATH}/phase3.chr${chrom}.GRCh38.GT.crossmap_binary"
    ADMIXTURE_PREFIX="${ADMIXTURE_OUTPUT_DIR}/chr${chrom}_K${k}"

    # Check if the PLINK file exists for this chromosome
    if [ ! -f "${PLINK_PREFIX}.bed" ]; then
      echo "File ${PLINK_PREFIX}.bed does not exist. Skipping chromosome ${chrom}, K=${k}."
      continue
    fi

    # Run Admixture for this chromosome and K value
    echo "Running Admixture for chromosome ${chrom} and K=${k}..."
    $ADMIXTURE_PATH --cv ${PLINK_PREFIX}.bed $k > "${ADMIXTURE_PREFIX}.log" 2>&1

    # Check if Admixture failed
    if [ $? -ne 0 ]; then
      echo "Admixture failed for chromosome ${chrom}, K=${k}. Check logs for details."
    else
      echo "Admixture completed for chromosome ${chrom}, K=${k}. Results saved to ${ADMIXTURE_PREFIX}."
    fi
  done
done

echo "Admixture inference completed for all chromosomes (1–22) and K values (2–10)."
