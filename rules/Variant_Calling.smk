#Snakefile to perform variant calling on the aligned BAM files produced in the prior FASTQ_Alignment module. 

#Perform variant calling for each sample chromosomal BAM. 
rule variant_call:
	input:
		bam = os.path.join(config["OUTDIR"], "BAM", "{sample}", "BAM_{sample}_{chr}.bam"),
	output:
		vcf = os.path.join(config["OUTDIR"], "VCF", "{sample}", "VCF_{sample}_{chr}.vcf"),
		log = os.path.join(config["OUTDIR"], "VCF", "{sample}", "VCF_{sample}_{chr}.log"),
	threads:
		1
	conda:
		os.path.join(REPO_DIR, "envs", "variant_calling.yaml")
	shell:
		"bcftools mpileup -Ou -f {config[REF_FASTA]} {input.bam} | bcftools call -mv -Oz -o {output.vcf} > {output.log}"



