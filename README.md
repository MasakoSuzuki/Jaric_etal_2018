### Jaric_etal_2018

Detailed ATAC-seq analysis procedures with code.


1. Alignment 

Alignment was performed using BWA mem package (bwa/0.7.15/gcc.4.4.7) and only uniquely aligned reads were used in the analysis.  Alignment.sh has the code used in this study. The chr.bed is the list of each canonical chromosome length.

2. Peak-calling 

Peak-calling was performed following the original ATAC-seq protocol [10.1038/nmeth.2688
] using macs2 (MACS2/2.1.0-update/python.2.7.8) on the shifted read1. Peak_call.sh has the code used in this study.

3. Down-sampling

Based on the number of reads in peaks (NPR), we calculated down-sampling factor. Down_sampling.sh has the code used in this study.

Down-sampling factor = NRP of the sample / mean NRP of all samples

If the factor is greater than 1, we used one as the down-sampling factor.


4. Second round peak-calling. 

We re-performed peak-calling on the down-sampled bam files using same parameters in step. Peak_call.sh has the code used in this study.

5. Irreproducible Discovery Rate (IDR)

IDR was calculated with idr (idr/2.0.2/python.3.4.1-atlas-3.11.30). The obtained peaks were merged with bedtools merge function (bedtools2/2.26.0/gcc.4.4.7). We used 0.05 as the threshold. IDR_cal.sh has the code used in this study.
Data quality

We performed QC on the obtained reads with the ChIPQC Bioconductor package. We obtained 180589 to 310212 peaks at FDR<0.05 (average=229,639, standard deviation=44,830).  QC_analysis.rmd has the code used in this study.

2019 Mar 11 Added

For nucRNA-seq analysis

We performed 100 bp paired-end sequencing using the Illumina HiSeq 4000 instrument.  We obtained 39 to 42  million paired reads per sample (mean=41,290,882 and  standard deviation=1,428,555)

Alignment
We used STAR to align the reference genome (mm10) with GENCODE version m11 annotation.

Differentially expressed gene
The gene expression status was analyzed with DESeq2.
