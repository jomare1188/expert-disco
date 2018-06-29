#!/bin/bash
# This script initializes the variables and creates the
# folders to work with bowtie2 and stacks from all the
# related scripts.
# Author: Jorge Mario Muñoz <jmoare8811@gmail.com>
# Date: 06/22/2018
# At: Centro de Computación Científica APOLO
# Company: CIB - EAFIT

# To not edit
BASE=$(pwd)
LIST_DIR=$BASE/lists
REF_DIR=$BASE/reference
INDEX_DIR=$REF_DIR/index
SCRIPT_DIR=$BASE/scripts
SAM_DIR=$REF_DIR/sam
REFMAP_DIR=$REF_DIR/refmap
FASTQS_DIR=$BASE/fastqs
RAW_DIR=$BASE/RE_processed
DENOVO_DIR=$BASE/denovo
FOF_FILE=fof.txt
VCF_WORKFILE=${DENOVO_DIR}/${VCF_FINAL_FILE}.recode.vcf

# To edit
VCF_FINAL_FILE=filtered_final.vcf
PRODUCT=coco
FASTA_FILE=CoConut.genome.fa
CODES_FILE=codes.txt
PREPROC_SCRIPT=samples2.sh
POPMAP_FILE=popfile_stacks
POPFILE_SCRIPT=stacks_popfile.sh
## samples2.sh options
NO_SAMPLES=0  
LINES=3000000
MAX_LINES=3000000
## DiscoSnpRad options 
SRC=$HOME/rconnector
FOF_FILE=fof.txt
PREFIX="Q"
k=31
b=1
c=12
de=0
D=0
P=1
FILTER_SNP_SCRIPT=snp_filters.sh
VCF_UNLINKED=ul-snp.vcf
VCF_SNP_FILE=snp.vcf
VCF_INDEL_FILE=indel.vcf
VCF_INDV_FIL=filter_ind.vcf
DISCO_RESULTS=disco1
VCF_RAW_FILE=${PREFIX}_k_${k}_c_${c}_D_${D}_P_${P}_m_0_coherent_sorted_with_clusters.vcf
## PGD spider
OUT_PGD=recode_pgd
OUT_STR=recode_str
OUT_NEXUS=recode_str
OUT_RXML=recode_rxml
OUT_BAYESCAN=recode_bayescan
OUT_GENPOP=recode_genpop
VCF_PGD_SPID=vcf-pgd.spid
PGD_STR_SPID=pgd-str.spid
PGD_NEXUS_SPID=pgd_nexus.spid
PGD_RMXL_SPID=pgd_rxml.spid
PGD_BAYESCAN_SPID=pgd-bayescan.spid
PGD_GENEPOP_SPID=pgd-genepop.spid

# Create dirs
mkdir -p $LIST_DIR $REF_DIR $INDEX_DIR $SCRIPT_DIR $SAM_DIR $FASTQS_DIR $REFMAP_DIR $RAW_DIR $DENOVO_DIR $REFMAP_DIR/P1 $REFMAP_DIR/P2 $REFMAP_DIR/P5
