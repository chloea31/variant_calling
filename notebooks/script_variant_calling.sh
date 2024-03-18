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
