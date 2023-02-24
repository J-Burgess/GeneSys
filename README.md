# GeneSys 

GeneSys is a pipeline that takes in raw FASTQ paired end data, aligns to a reference genome and performs variant calling. Subsequently, the called variants are intersected with known pathogenic variants from ClinVAR. Outputs are a tab separated text file containing variants which were called and also found in the ClinVAR database.

## Singularity container 

This Singularity container sets up a fresh Ubuntu install with Miniconda and Mamba, and installs the Snakemake package along with other dependencies required for the GeneSys pipeline. The GeneSys repository is also cloned to /genesys/repo within the container.

## Building the Singularity container

To build the Singularity container, you must have Singularity installed on your system. You can download Singularity from the official website or follow the installation instructions for your specific operating system.

Once Singularity is installed, you can build the container with the following command:

`singularity build genesys.sif singularity_genesys.def`

This will create a new Singularity image file called ubuntu_snakemake_genesys.sif in the current directory.
Running the Singularity container

To run the Singularity container, you can use the following command:

`singularity run genesys.sif <cores>` 
 
Replace <cores> with the number of cores you want to use for your analysis. This will set the $CORES environment variable within the container, which is used by the Snakemake pipeline to specify the number of cores to use.

When you run this command, the Singularity container will activate the default environment with Snakemake and GeneSys dependencies installed and execute the Snakefile with the specified number of cores.

## Future plans
I envision this pipeline as the foundation for a side project I have of developing an automated gene therapy platform. From known pathogenic variants identified in your sequencing data, a literature mining operation on peer reviewed research papers will be performed to search for potential therapeutic targets. If potential therapeautic targets are identified I would like to automate development of sg-RNA CRISPR sequences which could then be inserted into a vector of choice such as AAV. 

Additionally, my professional work has brought me to the fascinating field of deep learning to predict expression of DNA from sequence alone. Perhaps there lies the opportunity to implement some in-silico predictions for clinical targets.  

