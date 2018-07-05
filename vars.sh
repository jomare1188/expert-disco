#!/bin/bash
# This script initializes the variables and creates the
# folders to work with bowtie2 and stacks from all the
# related scripts.
# Author: Jorge Mario Muñoz <jomare8811@gmail.com>
# Date: 06/22/2018
# At: Centro de Computación Científica APOLO
# Company: CIB - EAFIT

# To not edit
BASE=$(pwd)
SPID_DIR=$BASE/spid_files
LIST_DIR=$BASE/lists
REF_DIR=$BASE/reference
INDEX_DIR=$REF_DIR/index
SCRIPT_DIR=$BASE/scripts
SAM_DIR=$REF_DIR/sam
BAM_DIR=$REF_DIR/bam
REFMAP_DIR=$REF_DIR/refmap
FASTQS_DIR=$BASE/fastqs
RAW_DIR=$BASE/../RE_processed
DENOVO_DIR=$BASE/denovo
FOF_FILE=fof.txt
VCF_WORKFILE=${DENOVO_DIR}/P1/${VCF_FINAL_FILE}.recode.vcf

# To edit
VCF_FINAL_FILE=filtered_final.vcf
PRODUCT=coco
FASTA_FILE=CoConut_test.genome.fa
CODES_FILE=codes.txt
PREPROC_SCRIPT=samples2.sh
POPMAP_FILE=popfile_stacks
POPFILE_SCRIPT=stacks_popfile.sh
STR_POPSCRIPT=popfile2.sh
## samples2.sh options

NO_SAMPLES=6
LINES=1000000
MAX_LINES=1000000

## DiscoSnpRad options
SRC=$HOME/rconnector
FOF_FILE=fof.txt
PREFIX="Q"
k=31
b=1
c=12
de=8
D=10
P=5
FILTER_SNP_SCRIPT=snp_filters.sh
VCF_UNLINKED=ul-snp.vcf
VCF_SNP_FILE=snp.vcf
VCF_INDEL_FILE=indel.vcf
VCF_INDV_FIL=filter_ind.vcf
DISCO_RESULTS=disco1
VCF_RAW_FILE=${PREFIX}_k_${k}_c_${c}_D_${D}_P_${P}_m_0_coherent_sorted_with_clusters.vcf
## Discosnp filter options
missing_per_pop=0.2
pops_cutoff=1
## PGD spider
PGDspiderPATH=$HOME/PGDSpider_2.1.1.2
OUT_PGD=recode_pgd
OUT_STR=recode_str
OUT_NEXUS=recode_nexus
OUT_RXML=recode_rxml
OUT_BAYESCAN=recode_bayescan
OUT_GENPOP=recode_genpop
VCF_PGD_SPID=vcf-pgd.spid
PGD_STR_SPID=pgd-str.spid
PGD_NEXUS_SPID=pgd_nexus.spid
PGD_RMXL_SPID=pgd_rxml.spid
PGD_BAYESCAN_SPID=pgd-bayescan.spid
PGD_GENEPOP_SPID=pgd-genepop.spid
# populations parameters
min_samples=0.8
min_maf=0.05
max_obs_het=0.70
min_pop=1
NUM_POP=5
# structure parameters
P_=1 # from 1 to 5
STR_INPUT=${DENOVO_DIR}/P$P_/${OUT_STR}
PARAMS_PATH=$HOME/Downloads/structure_console
MAINPARAMS_FILE=mainparams_ensayo
EXTRA_LAMBDA_FILE=extraparams_definelambda
STRUCTURE_DIR=$BASE/STRUCTURE
EXTRA_FILE=extraparams
# Create dirs
mkdir -p $LIST_DIR $REF_DIR $INDEX_DIR $SCRIPT_DIR $SAM_DIR $FASTQS_DIR $REFMAP_DIR $DENOVO_DIR $SAM_DIR $BAM_DIR $STRUCTURE_DIR 
