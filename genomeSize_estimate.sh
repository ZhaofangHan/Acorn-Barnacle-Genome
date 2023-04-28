#!/bin/bash
#PBS -N genomeSize
#PBS -l nodes=1:ppn=28,mem=8gb
#PBS -e /public/home/benthic/hanzhaofang/project/jobs_out/
#PBS -o /public/home/benthic/hanzhaofang/project/jobs_out/
#PBS -q high

# Kill script if any commands fail
set -e

nprocs=`wc -l < $PBS_NODEFILE`

genomescope='/public/home/benthic/hanzhaofang/bioSoft/genomescope'
jellyfish='/public/home/benthic/hanzhaofang/bioSoft/jellyfish-2.3.0/bin/jellyfish'

OUTPUT=~/project/20190801_balanus_genome/00_survey/bak

cd ${OUTPUT}

#gunzip -c NDES00182_L1_1_clean.rd.fq.gz > NDES00182_L1_1_clean.rd.fq 
#gunzip -c NDES00182_L1_2_clean.rd.fq.gz > NDES00182_L1_2_clean.rd.fq
#gunzip -c NDES00182_L2_1_clean.rd.fq.gz > NDES00182_L2_1_clean.rd.fq
#gunzip -c NDES00182_L2_2_clean.rd.fq.gz > NDES00182_L2_2_clean.rd.fq
#
#cat NDES00182_L1_1_clean.rd.fq NDES00182_L2_1_clean.rd.fq > NDES00182_1_clean.rd.fq
#cat NDES00182_L1_2_clean.rd.fq NDES00182_L2_2_clean.rd.fq > NDES00182_2_clean.rd.fq

i=17
    echo $i;

    $jellyfish count -t $nprocs -C -m $i -s 40G -o kmer${i}.out NDES00182_L1_1_clean.rd.fq NDES00182_L1_2_clean.rd.fq

    $jellyfish histo -t $nprocs kmer${i}.out -o kmer${i}.histo

    Rscript ${genomescope}/genomescope.R kmer${i}.histo $i 150 kmer${i}

#rm NDES00182_*rd.fq

echo "** Finished! **"
