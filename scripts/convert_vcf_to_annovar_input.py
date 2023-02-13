import sys

input_filename = snakemake.input["vcf"]
output_filename = snakemake.output["annovar_input"]

with open(input_filename, "r") as input_file:
    with open(output_filename, "w") as output_file:
        for line in input_file:
            if line.startswith("#"):
                continue
            fields = line.strip().split("\t")
            chromosome = fields[0]
            position = fields[1]
            reference = fields[3]
            alternative = fields[4]
            output_file.write("\t".join([chromosome, position, position, reference, alternative]) + "\n")

