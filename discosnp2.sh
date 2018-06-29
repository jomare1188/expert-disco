#!/bin/bash

# script to run DiscosnpRAD, DiscoSnpFinalization and to convert the vcf files to str files ready to structure analysis
# load variables
. vars.sh

# load samples
$SCRIPT_DIR/$PREPROC_SCRIPT

# run discosnp
cd ${DENOVO_DIR}
run_discoSnpRad.sh -l -t -S $SRC -r ${DENOVO_DIR}/${FOF_FILE} -p "${PREFIX}" -k $k -b $b -c $c -d $de -D $D -P $P
cd ${BASE}

# filter indels and snps
grep '^#' ${DENOVO_DIR}/${VCF_RAW_FILE} > ${DENOVO_DIR}/${VCF_SNP_FILE}
grep '^#' ${DENOVO_DIR}/${VCF_RAW_FILE} > ${DENOVO_DIR}/${VCF_INDEL_FILE}
grep SNP_ ${DENOVO_DIR}/${VCF_RAW_FILE} >> ${DENOVO_DIR}/${VCF_SNP_FILE}
grep INDEL_ ${DENOVO_DIR}/${VCF_RAW_FILE} >> ${DENOVO_DIR}/${VCF_INDEL_FILE}

# filter only one snp per cluster
1SNP_by_cluster.py ${DENOVO_DIR}/${VCF_SNP_FILE} ${DENOVO_DIR}/${VCF_UNLINKED} 

# filter snps by invd and pop
${SCRIPT_DIR}/${FILTER_SNP_SCRIPT}

# filter randomly 1k snp 
grep '^#' ${DENOVO_DIR}/${VCF_FINAL_FILE}.recode.vcf > ${DENOVO_DIR}/1krandom.vcf
grep '^#' -v ${DENOVO_DIR}/${VCF_FINAL_FILE}.recode.vcf | shuf | head -n 1000 >> ${DENOVO_DIR}/1krandom.vcf && echo 1krandom creado


############################


PATHPGDSPIDER=$(find $HOME -name PGDSpider_2*)


OUT_PGD=${BASE}/denovo/recode_pgd






PGD_FSTR_SPID=$(find $HOME/samples/spid_files -name pgd-fstr.spid)

OUT_FSTR=${BASE}/denovo/recode_fstr

PATH_DISCOPARAMS=$(find $HOME -name run_discoSnpRad.sh)
##########################################3


java -Xmx3072m -Xms512M -jar PGDSpider2-cli.jar -inputfile ${VCF_WORKFILE} -inputformat VCF -outputfile ${DENOVO_DIR}/${OUT_PGD} -outputformat PGD -spid ${LIST_DIR}/${VCF_PGD_SPID}
java -Xmx3072m -Xms512M -jar PGDSpider2-cli.jar -inputfile ${DENOVO_DIR}/${OUT_PGD} -inputformat PGD -outputfile ${DENOVO_DIR}/${OUT_STR} -outputformat STRUCTURE -spid ${LIST_DIR}/${PGD_STR_SPID}
java -Xmx3072m -Xms512M -jar PGDSpider2-cli.jar -inputfile ${DENOVO_DIR}/${OUT_PGD} -inputformat PGD -outputfile ${DENOVO_DIR}/${OUT_FSTR} -outputformat STRUCTURE -spid ${LIST_DIR}/${PGD_FSTR_SPID}
java -Xmx3072m -Xms512M -jar PGDSpider2-cli.jar -inputfile ${DENOVO_DIR}/${OUT_PGD} -inputformat PGD -outputfile ${DENOVO_DIR}/${OUT_NEXUS} -outputformat NEXUS -spid ${LIST_DIR}/${PGD_NEXUS_SPID}
java -Xmx3072m -Xms512M -jar PGDSpider2-cli.jar -inputfile ${DENOVO_DIR}/${OUT_PGD} -inputformat PGD -outputfile ${DENOVO_DIR}/${OUT_RXML} -outputformat PHYLIP -spid ${LIST_DIR}/${PGD_RXML_SPID}
java -Xmx3072m -Xms512M -jar PGDSpider2-cli.jar -inputfile ${DENOVO_DIR}/${OUT_PGD} -inputformat PGD -outputfile ${DENOVO_DIR}/${OUT_GENEPOP} -outputformat GENEPOP -spid ${LIST_DIR}/${PGD_GENEPOP_SPID}

