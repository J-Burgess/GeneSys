#Main snakefile for calling the genesys pipeline.


import os
import sys

#Get paths relative to repo.
SNAKEFILE = workflow.snakefile
REPO_DIR = os.path.dirname(SNAKEFILE)

# Input all rule to request final targets.
rule all:
	input:
	#BAM files.
		expand(os.path.join(config["OUTDIR"], "BAM", "{sample}", "BAM_{sample}_{chr}.bam"), chr = config["CHROMOSOMES"], sample=config["FASTQ"]["SAMPLES"].keys())

    		#List of pathogenic variants intersected with the variant calling results.
		#expand(os.path.join(config["OUTDIR"], "PathogenicVariants", "{sample}" "Pathogenic_Variants_{sample}_{chr}.txt"), chr = config["CHROMOSOMES"], sample = config["FASTQ"].keys()),
		#VCF files.
		#expand(os.path.join(config["OUTDIR"], "VCF", "{sample}" "VCF_{sample}_{chr}.vcf"), chr = config["CHROMOSOMES"], sample = config["FASTQ"].keys()),
	

#Include the snakemake rules per processing modul:
#1. FASTQ alignment.
#2. Variant calling.
#3. Variant intersection with known pathogenic variants.


include: os.path.join(REPO_DIR, "rules", "FASTQ_Alignment.smk")
include: os.path.join(REPO_DIR, "rules", "Variant_Calling.smk")
include: os.path.join(REPO_DIR, "rules", "Variant_Intersection.smk")
