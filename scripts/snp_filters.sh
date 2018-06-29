#!/bin/bash

## implemtation of https://github.com/jpuritz/dDocent/ for several scripts 
## filter locus by missing individuals and missing populations 
# load needed variables for the pipeline
. vars.sh
#run error count
ErrorCount.sh ${DENOVO_DIR}/${VCF_SNP_FILE}
#run missing indiv
cd ${DENOVO_DIR}
filter_missing_ind.sh ${DENOVO_DIR}/${VCF_SNP_FILE} ${DENOVO_DIR}/${VCF_INDV_FIL}
cd ${BASE}

${SCRIPT_DIR}/popfile2.sh

#run missing pop
cd ${DENOVO_DIR}
pop_missing_filter.sh ${DENOVO_DIR}/${VCF_INDV_FIL}.recode.vcf  ${LIST_DIR}/str_popfile 0.2 1 ${DENOVO_DIR}/${VCF_FINAL_FILE}
cd ${BASE}
