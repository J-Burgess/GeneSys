#Snakefile to perform called variant vs pathogenic variant intersection and output a tab separated text file of intersected variants.



#Convert VCF to a standard tab separated text file (ANNOVAR input file format).
rule convert_vcf_to_annovar_input:
	input:
		vcf = os.path.join(config["OUTDIR"], "VCF", "{sample}", "VCF_{sample}_{chr}.vcf"),
	output:
		annovar_input = os.path.join(config["OUTDIR"], "ANNOVAR", "{sample}", "ANNOVAR_{sample}_{chr}.txt"),
	threads:
		1
	log:
		os.path.join(config["OUTDIR"], "LOGS", "{sample}", "ANNOVAR_{sample}_{chr}.log")
	script:
		os.path.join(config["SCRIPTS"], "convert_vcf_to_annovar_input.py")





 



