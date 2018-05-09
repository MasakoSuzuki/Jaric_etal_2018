#!/bin/sh
#$ -cwd
#$ -j y
#$ -N PeakC
#$ -pe smp 1
#$ -l h_vmem=5.6G
#$ -S /bin/bash

mkdir Beds
mkdir Peaks_shift

for s in *final.bam
do
SampleName=`basename ${s/_final.bam}`
echo ${SampleName}

qsub -S /bin/bash -N ${SampleName}_Shift -cwd -l h_vmem=20G -j y << EOF

module load MACS2/2.1.0-update/python.2.7.8
module load bedtools2/2.26.0/gcc.4.4.7
module load samtools/1.5/gcc.4.4.7

samtools view -h -f 0x0040 -b ${s} > ${SampleName}_read1.bam
bedtools bamtobed -i ${SampleName}_read1.bam > Beds/${SampleName}.bed

awk 'BEGIN {OFS = "\t"} ; {if (\$6 == "+") print \$1, \$2 + 4, \$3 + 4, \$4, \$5, \$6; else print \$1, \$2 - 5, \$3 - 5, \$4, \$5, \$6}' Beds/${SampleName}.bed > Beds/${SampleName}_shifted.bed


module load MACS2/2.1.0-update/python.2.7.8

macs2 callpeak --nomodel -t Beds/${SampleName}_shifted.bed -n Peaks_shift/${SampleName} --nolambda -g 3e9 --keep-dup 'all' --slocal 10000 #Jason's method

EOF
done

#  Peak_call.sh
#
#
#  Created by Masako Suzuki on 9/26/17.
