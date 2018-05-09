#!/bin/sh
#$ -cwd
#$ -j y
#$ -N bwa
#$ -pe smp 1
#$ -l h_vmem=5.6G
#$ -S /bin/bash


mkdir Bams
mkdir Sams
mkdir Flagstats
mkdir Picard_metrics

module load picard-tools/1.92/java.1.8.0_20
module load bwa/0.7.15/gcc.4.4.7
bwa index Mus_musculus.GRCm38.dna.primary_assembly.fa

for f1 in *i_1.1_val_1.fq.gz
#
do
SampleName=`basename ${f1/.1_val_1.fq.gz/}`
echo $SampleName

qsub -S /bin/bash -N ${SampleName}_align -j y -cwd -pe smp 4 -l h_vmem=15G << EOF
module load bwa/0.7.15/gcc.4.4.7
module load samtools/1.5/gcc.4.4.7
module load FastQC/0.11.4/java.1.8.0_20

# align to reference mm10 with small condigs #
bwa mem -M -t 4 Mus_musculus.GRCm38.dna.primary_assembly.fa ${SampleName}.1_val_1.fq.gz ${SampleName}.2_val_2.fq.gz > Sams/${SampleName}.sam

module load samtools/1.5/gcc.4.4.7
module load picard-tools/1.92/java.1.8.0_20
module load bedtools2/2.26.0/gcc.4.4.7

## Select only uniquely mapped reads and sort

samtools view -bq 1 -F 4 Sams/${SampleName}.sam | samtools sort -@ 15 -o Bams/${SampleName}_UMap.bam
echo "${SampleName}_UMap.bam" >> Flagstats/${SampleName}_flagstat.txt
samtools flagstat Bams/${SampleName}_UMap.bam >> Flagstats/${SampleName}_flagstat.txt
samtools index Bams/${SampleName}_UMap.bam


## Remove Mitochondrial reads
# each chromosome read number
samtools idxstats Bams/${SampleName}_UMap.bam | cut -f 1,3 > ${SampleName}.ind.txt

# Get reads that are not mitochondrial chr

samtools view Bams/${SampleName}_UMap.bam | awk 'BEGIN {OFS="\t"}; {if(\$3=="chrMT") print \$1}' > ${SampleName}.read.list
java -jar $(which FilterSamReads.jar) I=Bams/${SampleName}_UMap.bam O=Bams/${SampleName}_UMap_noMT.bam READ_LIST_FILE=${SampleName}.read.list FILTER=excludeReadList

samtools index Bams/${SampleName}_UMap_noMT.bam
echo "${SampleName}_UMap_noMT.bam" >> Flagstats/${SampleName}_flagstat.txt
samtools flagstat Bams/${SampleName}_UMap_noMT.bam >> Flagstats/${SampleName}_flagstat.txt


## Remove duplicates

java -jar $(which MarkDuplicates.jar) INPUT=Bams/${SampleName}_UMap_noMT.bam OUTPUT=Bams/${SampleName}_UMap_noMT_mkdup.bam METRICS_FILE=Picard_metrics/${SampleName}_UMap_noMT_mkdup_metrics.txt REMOVE_DUPLICATES=true VALIDATION_STRINGENCY=SILENT CREATE_INDEX=false PROGRAM_RECORD_ID=MarkDuplicates PROGRAM_GROUP_NAME=MarkDuplicates ASSUME_SORTED=true MAX_SEQUENCES_FOR_DISK_READ_ENDS_MAP=50000
echo "${SampleName}_UMap_noMT_mkdup.bam" >> Flagstats/${SampleName}_flagstat.txt
samtools flagstat Bams/${SampleName}_UMap_noMT_mkdup.bam >> Flagstats/${SampleName}_flagstat.txt
samtools index Bams/${SampleName}_UMap_noMT_mkdup.bam

## Remove same start and end duplicates

samtools sort Bams/${SampleName}_UMap_noMT_mkdup.bam -o Bams/${SampleName}_UMap_noMT_mkdup_sort.bam
samtools rmdup Bams/${SampleName}_UMap_noMT_mkdup_sort.bam Bams/${SampleName}_UMap_noMT_mkdup_sort_rmdup
mv Bams/${SampleName}_UMap_noMT_mkdup_sort_rmdup Bams/${SampleName}_UMap_noMT_mkdup_sort_rmdup.bam
echo "${SampleName}_UMap_noMT_mkdup_sort_rmdup.bam" >> Flagstats/${SampleName}_flagstat.txt
samtools flagstat Bams/${SampleName}_UMap_noMT_mkdup_sort_rmdup.bam >> Flagstats/${SampleName}_flagstat.txt
samtools index Bams/${SampleName}_UMap_noMT_mkdup_sort_rmdup.bam


## select only chr1 to chr19, chrX and chrY for the further analysis

samtools view -b -L chr.bed Bams/${SampleName}_UMap_noMT_mkdup_sort_rmdup.bam -o Bams/${SampleName}_final.bam
samtools index Bams/${SampleName}_final.bam
echo "${SampleName}_final.bam" >> Flagstats/${SampleName}_flagstat.txt
samtools flagstat Bams/${SampleName}_final.bam >> Flagstats/${SampleName}_flagstat.txt

EOF
done

#  ATACseq.sh


