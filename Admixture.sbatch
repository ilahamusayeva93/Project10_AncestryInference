#!/bin/bash
#SBATCH --job-name=admixture_parallel  # Job name
#SBATCH --output=admixture_parallel.log  # Output log file
#SBATCH --error=admixture_parallel.err   # Error log file
#SBATCH --ntasks=6                      # Number of tasks
#SBATCH --cpus-per-task=1              # Number of CPU cores to use
#SBATCH --mem=200G                      # Memory limit
#SBATCH --time=18:00:00                 # Maximum execution time (12 hours)
#SBATCH --partition=pace-cpu            # Correct partition

# Email notifications (BEGIN, END, FAIL)
#SBATCH --mail-user=imusayeva3@gatech.edu
#SBATCH --mail-type=BEGIN,END,FAIL

# Define directories and paths
ADMIXTURE_OUTPUT_DIR="/home/hice1/imusayeva3/biol6150/ProjectSubmissions/Group6/Project10/admixture_results"
ADMIXTURE_PATH="/home/hice1/imusayeva3/biol6150/ProjectSubmissions/Group6/Project10/dist/admixture_linux-1.3.0/admixture"
PLINK_BASE_PATH="/home/hice1/imusayeva3/biol6150/ProjectSubmissions/Group6/Project10/Plink_Binary"

# Create the output directory if it doesn't exist
mkdir -p $ADMIXTURE_OUTPUT_DIR

# Define K values to test
K_VALUES=(2 3)

# Run Admixture for each chromosome and K value in parallel
for chrom in {13..15}; do
    PLINK_PREFIX="${PLINK_BASE_PATH}/phase3.chr${chrom}.GRCh38.GT.crossmap_binary"
    
    if [ ! -f "${PLINK_PREFIX}.bed" ]; then
        echo "File ${PLINK_PREFIX}.bed does not exist. Skipping chromosome ${chrom}."
        continue
    fi

    for k in "${K_VALUES[@]}"; do
        OUT_PREFIX="${ADMIXTURE_OUTPUT_DIR}/chr${chrom}_K${k}"
        LOG_FILE="${ADMIXTURE_OUTPUT_DIR}/chr${chrom}_K${k}.log"

        echo "Running Admixture for chromosome ${chrom}, K=${k}..."
        $ADMIXTURE_PATH --cv ${PLINK_PREFIX}.bed $k > $LOG_FILE 2>&1 &

        # Limit parallel jobs to avoid overloading
        while [ $(jobs | wc -l) -ge 6 ]; do
            sleep 5
        done
    done
done

# Wait for all jobs to complete
wait

echo "Admixture analysis completed for all chromosomes and K values."
