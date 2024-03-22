#!/bin/bash

#######################################################################################################################################
#######################################################################################################################################
#*/                                                   VARIANT CALLING HUMAN GENOME                                                  /*#
#######################################################################################################################################
#######################################################################################################################################

####################
### Activate the working environment
####################

#conda activate VariantCalling

####################
### Running the pipeline
####################

# in /home/Documents/Bioinformatique/variant_calling/ tape: ./notebooks/script_variant_calling.sh

####################
### Variable initialization
####################

WORK_DIR=. # working directory -> absolute way of the current (working) directory

####################
### Data collection
####################

# Data already downloaded

####################
### Unzip FASTQ files
####################

# gunzip $WORK_DIR/data/raw/reads.fastq.gz 

####################
### Quality control of the data
####################
echo "> quality control of the data"

mkdir -p $WORK_DIR/reports/QC # to create all folders recursively

# basename and without the extension
for file in $WORK_DIR/data/raw/*.fastq; do 
    #fastq_file="$(basename -- $file)"
    if [[ ! -f $WORK_DIR/reports/QC/${file} ]]; then
        fastqc ${file} -o $WORK_DIR/reports/QC/
    fi
done

##################
### Trimming of the data
##################

##################
### MultiQC on FASTQ files
##################

# Maybe no need to perform the multiQC, as we have only one file

##################
### Indexing and mapping: BWA
##################
echo "> indexing and mapping using BWA"

if [ ! -d $WORK_DIR/data/interm/ ]; then
    mkdir -p $WORK_DIR/data/interm
fi

if [[ ! -f $WORK_DIR/data/interm/db* ]]; then
    bwa index db $WORK_DIR/data/raw/ref.fa
fi

if [ ! -d $WORK_DIR/reports/bwa_alignment ]; then
    mkdir -p $WORK_DIR/reports/bwa_alignment
fi

if [[ ! -f $WORK_DIR/reports/bwa_alignment/aln_output.sam ]]; then
    bwa mem $WORK_DIR/data/interm/db $WORK_DIR/data/raw/reads.fastq \
        | samtools view -bS -h \
        | samtools sort -o $WORK_DIR/reports/bwa_alignment/aln_output.bam 
    # > $WORK_DIR/reports/bwa_alignment/aln_output.sam        
fi

if [[ ! -f $WORK_DIR/reports/bwa_alignment/aln_output.bam.bai ]]; then
    samtools index $WORK_DIR/reports/bwa_alignment/aln_output.bam
fi

##################
### Variant calling: BCFtools 
##################

# Manipulates variant calls in VCF (and BCF) formats
echo "> run bcftools mpileup"

if [ ! -d $WORK_DIR/reports/vcf ]; then
    mkdir -p $WORK_DIR/reports/vcf
fi

if [[ ! -f $WORK_DIR/reports/vcf/aln_output_calls.vcf.gz ]]; then
    bcftools mpileup -Ou -Q 20 -f $WORK_DIR/data/raw/ref.fa $WORK_DIR/reports/bwa_alignment/aln_output.bam \
        | bcftools call -mv -Oz -o $WORK_DIR/reports/vcf/aln_output_calls.vcf.gz
fi

echo "> run bcftools index"

if [[ ! -f $WORK_DIR/reports/vcf/aln_output_calls.vcf.gz.csi ]]; then
    bcftools index $WORK_DIR/reports/vcf/aln_output_calls.vcf.gz
fi

##################
### Statistical analysis
##################
