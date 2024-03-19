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

bwa index -p index_db -a bwtsw data/raw/ref.fa
bwa mem -P reports/bwa_alignment/index_db data/raw/reads.fastq > aln_output.sam

##################
### SAMtools view: views and converts SAM/BAM files
##################

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

