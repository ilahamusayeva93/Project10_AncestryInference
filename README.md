# Project10_AncestryInference

Admixture-Based Ancestry Inference on HPC Cluster

This project focuses on performing population structure inference using Admixture and PLINK on an HPC cluster. It includes SBATCH job scripts for efficient execution and a Jupyter Notebook (Project10-AncestryInference.ipynb) for post-processing and visualization of results.

Project Overview

This project is designed to achieve the following steps:

Data Preparation
Convert input genomic data (VCF files) into binary PLINK format.
Organize input files for downstream Admixture analysis.
Quality Control (QC)
Perform PLINK-based filtering to ensure high-quality data for ancestry inference.
Running Admixture
Use Admixture to estimate ancestry proportions for multiple K values (number of populations) across all chromosomes (1–22).
Identify the optimal K for each chromosome using cross-validation (CV) errors.
Post-Processing & Visualization
Summarize and visualize Admixture results using the provided Jupyter Notebook.
Generate ancestry proportion plots and identify top individuals per chromosome.


Software Tools
PLINK: For genotype QC and binary format conversion.
Admixture: For population structure inference.
SLURM: Job scheduling on the HPC cluster.
Python & Jupyter Notebook: For post-processing and visualizations.
Setup & Execution

1. Submit SBATCH Jobs
Run Admixture Across Chromosomes and K Values
Submit the run_admixture.sbatch script:
sbatch scripts/run_admixture.sbatch
Run QC and Admixture in Parallel
Submit the qc_admixture.sbatch script:
sbatch scripts/qc_admixture.sbatch
2. Post-Processing with Jupyter Notebook
After running the SBATCH scripts, the results can be analyzed and visualized using the provided Jupyter Notebook.

Start Jupyter Notebook on your local system or via HPC tools like JupyterLab:
jupyter notebook
Open the notebook located at:
notebooks/Project10-AncestryInference.ipynb.
Notebook Features:
Summarizes optimal K values for each chromosome based on CV errors.
Visualizes ancestry proportions for the top individuals.
Computes population-level average ancestry proportions.
Output Details

PLINK Files: Binary .bed, .bim, and .fam files generated per chromosome.
Admixture Results:
.Q files: Ancestry proportions per individual.
.log files: Cross-validation errors for each K value.
Visualization:
Ancestry proportion bar plots.
Summary tables of optimal K values and average ancestry proportions.
