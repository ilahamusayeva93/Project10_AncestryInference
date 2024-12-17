#!/bin/bash
#SBATCH --job-name=admixture_optimal_K  # Job name
#SBATCH --output=admixture_optimal_K.log  # Output log file
#SBATCH --error=admixture_optimal_K.err   # Error log file
#SBATCH --ntasks=22                       # Number of tasks
#SBATCH --cpus-per-task=1               # Number of CPU cores to use
#SBATCH --mem=200G                       # Memory limit
#SBATCH --time=18:00:00                  # Maximum execution time
#SBATCH --partition=pace-cpu             # Partition to use

# Email notifications
#SBATCH --mail-user=imusayeva3@gatech.edu
#SBATCH --mail-type=BEGIN,END,FAIL

# Define the path to the Admixture binary
ADMIXTURE_PATH="/home/hice1/imusayeva3/biol6150/ProjectSubmissions/Group6/Project10/dist/admixture_linux-1.3.0/admixture"

# Define directories
QC_OUTPUT_BASE="/home/hice1/imusayeva3/biol6150/ProjectSubmissions/Group6/Project10/QC_Output"
RESULTS_DIR="/home/hice1/imusayeva3/biol6150/ProjectSubmissions/Group6/Project10/QC_Admixture_Results"
mkdir -p $RESULTS_DIR

# Number of populations to test
K_VALUES=$(seq 2 10)  # Test K from 2 to 10

# Run Admixture for each chromosome and K value in parallel
for chrom in {1..22}; do
    QC_DIR="${QC_OUTPUT_BASE}/phase3.chr${chrom}.GRCh38.GT.crossmap_binary"
    QC_BED="${QC_DIR}/phase3.chr${chrom}.GRCh38.GT.crossmap_binary_QC.bed"
    
    if [ ! -f "$QC_BED" ]; then
        echo "QC file for chromosome ${chrom} not found. Skipping..."
        continue
    fi

    for K in $K_VALUES; do
        OUT_PREFIX="${RESULTS_DIR}/chr${chrom}_K${K}"
        LOG_FILE="${RESULTS_DIR}/chr${chrom}_K${K}.log"

        echo "Running Admixture for chromosome ${chrom}, K=${K}..."
        $ADMIXTURE_PATH --cv $QC_BED $K > $LOG_FILE 2>&1 &
        
        # Limit parallel jobs to avoid overloading resources
        while [ $(jobs | wc -l) -ge 22 ]; do
            sleep 5
        done
    done
done

# Wait for all jobs to complete
wait

echo "Admixture analysis completed for all chromosomes and K values."
