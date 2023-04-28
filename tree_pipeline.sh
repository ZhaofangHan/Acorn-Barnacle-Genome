## OrthoMCL

# 1. prepare fasta
mkdir compliantFasta
cd compliantFasta
ls ../cds_pep/*.pep.fa | sed 's/..\/cds_pep\///g; s/.pep.fa//g' | while read id; do ~/bioSoft/orthomcl-v2.0.9/bin/orthomclAdjustFasta ${id} ../cds_pep/${id}.pep.fa 1 ; done

# 2. filter fasta
~/bioSoft/orthomcl-v2.0.9/bin/orthomclFilterFasta compliantFasta/ 30 20

# 3. all-vs-all BLAST
makeblastdb -in goodProteins.fasta -dbtype prot -title orthomcl -out orthomcl
blastp -db orthomcl -query goodProteins.fasta -seg yes -out orthomcl.blastout -evalue 1e-5 -outfmt 6 -num_threads 28

# 4. blast out
~/bioSoft/orthomcl-v2.0.9/bin/orthomclBlastParser orthomcl.blastout compliantFasta > similarSequences.txt
perl -p -i -e 's/0\t0/1\t-181/' similarSequences.txt

# 5. similarSequences.txt load in mysql
# 5.1 create orthmcl database in mysql 
## This step need to open mysql, and use "create database orthomcl;".
# 5.2 create orthomcl table
~/bioSoft/orthomcl-v2.0.9/bin/orthomclInstallSchema ~/bioSoft/orthomcl-v2.0.9/orthomcl.config
# load data
~/bioSoft/orthomcl-v2.0.9/bin/orthomclLoadBlast ~/bioSoft/orthomcl-v2.0.9/orthomcl.config similarSequences.txt

# 6. pair protein
~/bioSoft/orthomcl-v2.0.9/bin/orthomclPairs ~/bioSoft/orthomcl-v2.0.9/orthomcl.config orthomcl_pairs.log cleanup=no

# 7. export mysql data
~/bioSoft/orthomcl-v2.0.9/bin/orthomclDumpPairsFiles ~/bioSoft/orthomcl-v2.0.9/orthomcl.config


## mcl

# 1. cluster
~/bioSoft/mcl-14-137/bin/mcl mclInput --abc -I 1.5 -o mclOutput -te 24

# 2. number the cluster
~/bioSoft/orthomcl-v2.0.9/bin/orthomclMclToGroups group 1 < mclOutput > groups.txt

## tree

# 1. find single copy gene
~/scripts/bin/orthomcl_findSingleCopyOrtholog.pl groups.txt compliantFasta/

mkdir muscle_Gblocks
cd muscle_Gblocks
cp muscle_Gblocks.sh muscle_Gblocks/
sh muscle_Gblocks.sh

## 2. ProtTest
mkdir ProtTest
cd ProtTest
mv ../muscle_Gblocks/all_new.fa . 
~/bioSoft/RAxML/usefulScripts/convertFasta2Phylip.sh all_new.fa > all_new.phy
java -jar ~/bioSoft/prottest-3.4-20140123/prottest-3.4.jar -i all_new.phy -all-distributions -F -AIC -BIC -tc 0.5 -threads 24 -o ProtTest.out

## 3. RAxML
~/bioSoft/RAxML/raxmlHPC-PTHREADS-SSE3 -f a -x 12345 -p 12345 -N 1000 -m PROTGAMMAILGF -s all_new.phy -n all.tree -T 24 -k -o Strigamia_maritima
