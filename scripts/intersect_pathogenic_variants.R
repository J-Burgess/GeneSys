library(data.table)

clinvar <- fread("/home/james/Desktop/Projects/GeneSys/External_Data/ClinVAR/variant_summary.txt", header = T)
called_vcf <- fread(snakemake@input[["query"]], header = F)


#Setnames such that RSID column is identical in both dataframes.
names(clinvar)[names(clinvar) == 'RS# (dbSNP)'] <- 'rsID'
colnames(called_vcf) <- c("rsID", "Chrom", "Pos", "Ref", "Alt", "Depth")



#Merge on matching RS ID
merged <- merge(called_vcf, clinvar, by="rsID")

#Write output of intersected pathogenic variants.
fwrite(merged, snakemake@output[["intersected"]], sep = "\t", quote = F, col.names = T, row.names = F)