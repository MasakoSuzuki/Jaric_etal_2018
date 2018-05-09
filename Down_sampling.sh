#!/bin/sh
#$ -cwd
#$ -j y
#$ -N PeakC
#$ -pe smp 1
#$ -l h_vmem=25G
#$ -S /bin/bash

mkdir DS_28Nov17
module load samtools/1.5/gcc.4.4.7

samtools view -b -h -s  0.79 Pr_1_final.bam  > DS_28Nov17/Pr_1_final.bam
cp Pr_2_final.bam DS_28Nov17/Pr_2_final.bam
samtools view -b -h -s  0.74 Pr_3_final.bam  > DS_28Nov17/Pr_3_final.bam

cp Di_1_final.bam DS_28Nov17/Di_1_final.bam
cp Di_2_final.bam DS_28Nov17/Di_2_final.bam
samtools view -b -h -s  0.99 Di_3_final.bam  > DS_28Nov17/Di_3_final.bam

cp Ma_1_final.bam DS_28Nov17/Ma_1_final.bam
cp Ma_2_final.bam DS_28Nov17/Ma_2_final.bam
samtools view -b -h -s  0.72 Ma_3_final.bam  > DS_28Nov17/Ma_3_final.bam

samtools index DS_28Nov17/Pr_1_final.bam
samtools index DS_28Nov17/Pr_2_final.bam
samtools index DS_28Nov17/Pr_3_final.bam
samtools index DS_28Nov17/Di_1_final.bam
samtools index DS_28Nov17/Di_2_final.bam
samtools index DS_28Nov17/Di_3_final.bam
samtools index DS_28Nov17/Ma_1_final.bam
samtools index DS_28Nov17/Ma_2_final.bam
samtools index DS_28Nov17/Ma_3_final.bam

#  DS_28Nov17.sh
#
#
#  Created by Masako Suzuki on 11/28/17.
#
