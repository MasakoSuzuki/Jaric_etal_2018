#!/bin/sh
#$ -cwd
#$ -j y
#$ -N IDR_qsubs
#$ -pe smp 1
#$ -l h_vmem=3G
#$ -S /bin/bash


## testing reproducibility between samples

for f1 in *_1_peaks.narrowPeak
#
do
SampleName=`basename ${f1/_1_peaks.narrowPeak/}`
echo $SampleName

qsub -S /bin/bash -N ${SampleName}_IDR -j y -cwd -pe smp 4 -l h_vmem=15G << EOF

module load idr/2.0.2/python.3.4.1-atlas-3.11.30
module load bedtools2/2.26.0/gcc.4.4.7

idr --samples ${SampleName}_1_peaks.narrowPeak ${SampleName}_2_peaks.narrowPeak --output-file ${SampleName}_12 --input-file-type narrowPeak --peak-merge-method avg --idr-threshold 0.05
idr --samples ${SampleName}_2_peaks.narrowPeak ${SampleName}_3_peaks.narrowPeak --output-file ${SampleName}_23 --input-file-type narrowPeak --peak-merge-method avg --idr-threshold 0.05
idr --samples ${SampleName}_1_peaks.narrowPeak ${SampleName}_3_peaks.narrowPeak --output-file ${SampleName}_13 --input-file-type narrowPeak --peak-merge-method avg --idr-threshold 0.05

cat ${SampleName}_12 ${SampleName}_23 ${SampleName}_13 > ${SampleName}_123
sort -k1,1 -k2,2n -k3,3n ${SampleName}_123 > ${SampleName}_sort
cat ${SampleName}_sort | awk '{print $1"\t"$2"\t"$3"\t"$7}' > ${SampleName}_sort.bed
bedtools merge -d 10 -c 4 -o mean -i ${SampleName}_sort.bed > ${SampleName}_IDR05.bed


EOF

done
