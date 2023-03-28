# Pipeline used for phylogenic trees computations
# Author: Ada Hryniewicka

Input file: list_proteomes.txt- a list with proteomes names separated by new line

Output files: generated NJ set of trees, trees after bootstrap with >70% mean of scores, trees with paralogs, consensus trees + bootstrap selected, supertrees + bootstrap + super tree for paralogs. Trees are saved in .newick format and visualisations are in .pdf.

The input file needs to be in the same folder as program. The rest of the process is automatic. The output is a collection of different phylogenic trees located in working directory.

To run this pipeline it is required to have installed in the same environment (despite python3 and R): 
snakemake [https://snakemake.readthedocs.io/en/stable/], 
mmseqs [https://github.com/soedinglab/MMseqs2],
fasturec [https://bitbucket.org/pgor17/fasturec]

Snakefile is responsible for running the pipeline.
Example: 'snakemake --cores n raport.pdf', where n is the number of used cores for computations
The usage is typical for snakemake procedures. 
