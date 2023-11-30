# Acorn-Barnacle-Genome

1. genomeSize_estimate.sh  ##
   This shell program is used for genome size estimation.
   
   $ sh genomeSize_estimate.sh
   
2. psmc.sh  ##
   This shell program is used to estimate population size using PSMC software.
   
   $ sh psmc.sh
   
3. phylogenetic_tree  ##
   The program is used to contrust phylogenetic tree.
   
   $ sh tree_pipeline.sh
   
4. pickUnigeneFromFa.py ##
   The python script was use to select genes from a FASTA file.
   
   $ python pickUnigeneFromFa.py fastaFile lociInfo  ##
   Note: lociInfo format: queryGene Begin End

5. ka_ks  ##
   The program is used to calculate ka and ks.

   $ sh run_ka_ks.sh
