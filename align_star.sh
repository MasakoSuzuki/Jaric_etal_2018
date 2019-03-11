#!/bin/sh
#$ -cwd
#$ -j y
#$ -N starAlign
#$ -pe smp 1
#$ -l h_vmem=20G
#$ -S /bin/bash


module load STAR/2.6.1b/gcc.4.9.2

STAR --runThreadN 1 --runMode genomeGenerate --genomeDir /indexes/mm10_gencode/Star_2018  --genomeFastaFiles indexes/mm10_gencode/GRCm38.primary_assembly.genome.fa --sjdbGTFfile indexes/mm10_gencode/gencode.VM11.gtf

mkdir Mapped_mm10

for s in *_L001_001.R1_trimmed.fastq.gz

do

SampleName=`basename ${s/_L001_001.R1_trimmed.fastq.gz/}`

qsub -S /bin/bash -N ${SampleName}_align -cwd -l h_vmem=20G -pe smp 2 -j y << EOF

gunzip ${SampleName}_L001_001.R1_trimmed.fastq.gz
gunzip ${SampleName}_L002_001.R1_trimmed.fastq.gz
gunzip ${SampleName}_L001_001.R2_trimmed.fastq.gz
gunzip ${SampleName}_L002_001.R2_trimmed.fastq.gz

module load STAR/2.6.1b/gcc.4.9.2

STAR --runThreadN 2 \
--genomeDir indexes/mm10_gencode/STAR \
--readFilesIn ${SampleName}_L001_001.R1_trimmed.fastq,${SampleName}_L002_001.R1_trimmed.fastq ${SampleName}_L001_001.R2_trimmed.fastq,${SampleName}_L002_001.R2_trimmed.fastq \
--outFilterType BySJout \
--outFilterMultimapNmax 20 \
--alignSJoverhangMin 8 \
--alignSJDBoverhangMin 1 \
--outFilterMismatchNmax 999 \
--outFilterMismatchNoverReadLmax 0.04 \
--alignIntronMin 20 \
--alignIntronMax 1000000 \
--alignMatesGapMax 1000000 \
--outSAMtype BAM SortedByCoordinate \
--quantMode GeneCounts \
--sjdbGTFfile indexes/mm10_gencode/gencode.vM15.primary_assembly.annotation.gtf \
--outFileNamePrefix Mapped_mm10/${SampleName}

EOF

done


