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

if [ ! -d $WORK_DIR/reports/bwa_alignment ]; then
    mkdir -p $WORK_DIR/reports/bwa_alignment
fi

if [[ ! -f $WORK_DIR/reports/bwa_alignment/index_db.bwt ]]; then
    bwa index -p index_db -a bwtsw $WORK_DIR/data/raw/ref.fa
fi

if [[ ! -f $WORK_DIR/reports/bwa_alignment/aln_output.sam ]]; then
    bwa mem -P $WORK_DIR/reports/bwa_alignment/index_db $WORK_DIR/data/raw/reads.fastq \
        > $WORK_DIR/reports/bwa_alignment/aln_output.sam
fi

##################
### SAMtools view: views and converts SAM/BAM files
##################
echo "> run SAMtools view"

##################
### Variant calling: BCFtools 
##################

# Manipulates variant calls in VCF (and BCF) formats

##################
### Statistical analysis
##################

##################
### Validation of the pipeline
##################

