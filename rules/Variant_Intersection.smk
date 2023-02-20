#Snakefile to perform called variant vs pathogenic variant intersection and output a tab separated text file of intersected variants.



#Use bcftools annotate to annotate rsID of called variants from the dbSNP reference VCF file. 
rule annotate_vcf_with_rsID:
	input:
		vcf = os.path.join(config["OUTDIR"], "VCF", "{sample}", "VCF_{sample}_{chr}.vcf"),
		ref_vcf = config["REF_VCF"],
	output:
		annotated = os.path.join(config["OUTDIR"], "VCF", "{sample}", "VCF_rsIDannot_{sample}_{chr}.txt"),
	threads:
		1
	conda:
		os.path.join(REPO_DIR, "envs", "intersect_variants.yaml")
	shell:
		"bcftools annotate -a {input.ref_vcf} -c ID {input.vcf} > {output.annotated}"
		

#Use bcftools query to extract information from the annotated VCF file as tab separated text file.
#Query the rsID column of the VCF to match with the ClinVar text file containing rsID column.
#Use bcftools query to also extract the called variant position and reference and alternate alleles in addition to coverage. 
rule query_info_from_VCF:
	input:
		annotated = os.path.join(config["OUTDIR"], "VCF", "{sample}", "VCF_rsIDannot_{sample}_{chr}.txt"),
	output:
		query = os.path.join(config["OUTDIR"], "VCF", "{sample}", "VCF_query_{sample}_{chr}.txt"),
	threads:
		1
	conda:
		os.path.join(REPO_DIR, "envs", "intersect_variants.yaml")
	shell:
		"bcftools query -f '%ID\t%CHROM\t%POS\t%REF\t%ALT\t%DP\n' {input.annotated} > {output.query}"


#For each sample, concatenate all the VCF query text files into one file.
rule cat_queried_VCF:
	input:
		expand(os.path.join(config["OUTDIR"], "VCF", "{{sample}}", "VCF_query_{{sample}}_{chr}.txt"), chr = config["CHROMOSOMES"]),
	output:
		os.path.join(config["OUTDIR"], "VCF", "Concatenated_Chromosomes", "{sample}", "VCF_query_{sample}_genome.txt"),
	threads:
		1
	conda:
		os.path.join(REPO_DIR, "envs", "intersect_variants.yaml")
	shell:
		"cat {input} > {output}"

	
#Match the concatenated VCF query text file with the ClinVar text file containing rsID column.
#Output a tab separated text file containing the ClinVar information of the intersected variants.
rule intersect_pathogenic_variants:
	input:
		query = os.path.join(config["OUTDIR"], "VCF", "Concatenated_Chromosomes", "{sample}", "VCF_query_{sample}_genome.txt"),
		clinvar = config["CLINVAR_VARIANTS"],
	output:
		intersected = os.path.join(config["OUTDIR"], "VCF", "{sample}", "VCF_intersect_{sample}_genome.txt"),
	threads:	
		10
	conda:
		os.path.join(REPO_DIR, "envs", "r_data_table.yaml")
	script:
		os.path.join(REPO_DIR, "scripts", "intersect_pathogenic_variants.R")




 



