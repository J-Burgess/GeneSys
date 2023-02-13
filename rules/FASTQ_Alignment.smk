#Snakefile to perform alignment of paired end FASTQ reads to the reference genome supplied in the config. 

#Perform alignment of the FASTQ reads per sample to the reference index.
rule align_FASTQ:
	input:
		#Per sample in the config file, get the forward and reverse FASTQ files
		r1 = lambda wildcards: config["FASTQ"]["SAMPLES"][wildcards.sample]["R1"],
		r2 = lambda wildcards: config["FASTQ"]["SAMPLES"][wildcards.sample]["R2"]
	output:
		#Output the BAM file to the output directory
		bam = os.path.join(config["OUTDIR"], "BAM", "{sample}", "BAM_{sample}.bam"),
	threads:
		20
	conda:
		os.path.join(REPO_DIR, "fastq_align.yaml")
	shell:
		"bowtie2 -p {threads} -x {config[BOWTIE2_IDX]} -1 {input.r1} -2 {input.r2} | samtools view -f2 -bS - > {output.bam}"



#Split BAM by chromosomal targets to facilitate parallelization of downstream analysis.
rule split_bam:
	input:
		#Input the BAM file from the previous rule
		bam = os.path.join(config["OUTDIR"], "BAM", "{sample}", "BAM_{sample}.bam")
	output:
		#Output the BAM file to the output directory
		chr_bam = os.path.join(config["OUTDIR"], "BAM", "{sample}", "BAM_{sample}_{chr}.bam")
	threads:
		1
	params:
		chr = "{chr}",
	conda:
		os.path.join(REPO_DIR, "fastq_align.yaml")
	shell:
		"samtools view -b {input.bam} {params.chr} > {output.chr_bam}"


