nprocs=24

DB=~/project/20190801_balanus_genome/02_annotation/09.filter/Aam_pep
QUERY=~/project/20190801_balanus_genome/02_annotation/09.filter/Aam.longest.filter.pep
INPUT=~/project/20190801_balanus_genome/10_kaks/Amphibalanus_amphitrite

cd ${INPUT}

echo "blast begins"
blastp -db ${DB} -query ${QUERY} -out blastOut.txt -evalue 1e-5 -outfmt 6 -max_target_seqs 2 -num_threads ${nprocs}

echo "** Job finished! **"
