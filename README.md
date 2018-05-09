### Jaric_etal_2018

# Chromatin organization in the female brain fluctuates across the estrous cycle


Detailed ATAC-seq analysis procedures with code.


1. Alignment 

Alignment was performed using BWA mem package (bwa/0.7.15/gcc.4.4.7) and only uniquely aligned reads were used in the analysis. Alignment.sh has the code used in this study. The chr.bed is the list of each canonical chromosome length.

2. Peak-calling 

Peak-calling was performed following the original ATAC-seq protocol [10.1038/nmeth.2688
] using macs2 (MACS2/2.1.0-update/python.2.7.8) on the shifted read1. Peak_call.sh has the code used in this study

3. QC

After the first round of peak-calling, we performed QC with the ChIPQC Bioconductor package. QC_analysis.rmd has the code used in this study

4. Down-sampling

Based on the number of reads in peaks (NPR), we calculated down-sampling factor. Down_sampling.sh has the code used in this study.

Down-sampling factor = NRP of the sample / mean NRP of all samples

If the factor is greater than 1, we used one as the down-sampling factor.

5. Second round peak-calling

We performed peak-calling on the down-sampled bam files using same parameters in step 2. Peak_call.sh has the code used in this study

6. Irreproducible Discovery Rate (IDR)

IDR was calculated with idr (idr/2.0.2/python.3.4.1-atlas-3.11.30). The obtained peaks were merged with bedtools merge function (bedtools2/2.26.0/gcc.4.4.7). We used 0.05 as the threshold. IDR_cal.sh has the code used in this study.
