#Main snakefile for calling the genesys pipeline. 


import os 
import sys

#Get paths relative to repo. 
SNAKEFILE = workflow.snakefile
REPO_DIR = os.path.dirname(os.path.dirname(SNAKEFILE))

# Input all rule to request final targets.
rule all: 
    input: 
    	#List of pathogenic variants intersected with the variant calling results. 
    	expand(os.path.join(config["OUTDIR"], "PathogenicVariants", "Pathogenic_Variants_{chr}.txt"), chr = config["CHROMOSOMES"]),
	#VCF files. 
	expand(os.path.join(config["OUTDIR"], "VCF", "VCF_{chr}.vcf"), chr = config["CHROMOSOMES"]),
	#BAM files.
	expand(os.path.join(config["OUTDIR"], "BAM", "BAM_{chr}.bam"), chr = config["CHROMOSOMES"]),
	

#Include the snakemake rules per processing module:
#1. FASTQ alignment.
#2. Variant calling.
#3. Variant intersection with known pathogenic variants.

include: os.path.join(REPO_DIR, "rules", "FASTQ_Alignment.smk")	
include: os.path.join(REPO_DIR, "rules", "Variant_Calling.smk")
include: os.path.join(REPO_DIR, "rules", "Variant_Intersection.smk")




