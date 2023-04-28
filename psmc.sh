#!/bin/bash
#PBS -N psmc
#PBS -l nodes=1:ppn=12,mem=1gb
#PBS -e /public/home/benthic/hanzhaofang/project/jobs_out/
#PBS -o /public/home/benthic/hanzhaofang/project/jobs_out/
#PBS -q middle

# Kill script if any commands fail
set -e

nprocs=`wc -l < $PBS_NODEFILE`

REF=~/project/20190801_balanus_genome/01_Genomic_Aam/Aam_genome.fa
INPUT=~/project/20190801_balanus_genome/08_psmc/data
OUTPUT=~/project/20190801_balanus_genome/08_psmc/new
PSMC=~/bioSoft/psmc-0.6.5

cd ${INPUT}

R1=(`ls *_L1_1_clean_paired.fq.gz`)

Sample=`echo ${R1[$PBS_ARRAYID]} | awk '{split($0,arra,"_"); print arra[1]}'`
#Sample=`echo ${R1[$PBS_ARRAYID]} | sed 's/_1_clean_paired.fq.gz//g'`

echo "** Sample is the " ${Sample} " **"

cd ${OUTPUT}

samtools mpileup -Q 30 -q 30 -C 50 -uf ${REF} ../bam/${Sample}_filter.bam | bcftools call -c - \
      | vcfutils.pl vcf2fq -d 20 -D 120 | gzip > ${Sample}_diploid.fq.gz

${PSMC}/utils/fq2psmcfa -q 20 -s 50 ${Sample}_diploid.fq.gz > ${Sample}_diploid.psmcfa

${PSMC}/utils/splitfa ${Sample}_diploid.psmcfa > ${Sample}_split.psmcfa

${PSMC}/psmc -N25 -t15 -r5 -b -p "4+25*2+4+6" -o ${Sample}_diploid.psmc ${Sample}_diploid.psmcfa

seq 30 | xargs -i echo ${PSMC}/psmc -N25 -t15 -r5 -b -p "4+25*2+4+6" -o ${Sample}_round-{}.psmc ${Sample}_split.psmcfa | sh

cat ${Sample}_diploid.psmc ${Sample}_round-*.psmc > ${Sample}_combined.psmc

${PSMC}/utils/psmc_plot.pl -g 0.25 -u 3.1e-09 ${Sample}_combined ${Sample}_combined.psmc

mv ${Sample}_round-*.psmc round/

echo "** Job finished! **"
