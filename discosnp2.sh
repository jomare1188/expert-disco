#!/bin/bash

## script to run DiscosnpRAD, DiscoSnpFinalization and to convert the vcf files to str files ready to structure analysis
## step 1 load variables
. vars.sh

## step 3 load samples
#$SCRIPT_DIR/$PREPROC_SCRIPT

## step 4 run discosnp
cd ${DENOVO_DIR}
#run_discoSnpRad.sh -l -t -S $SRC -r ${DENOVO_DIR}/${FOF_FILE} -p "${PREFIX}" -k $k -b $b -c $c -d $de -D $D -P $P
cd ${BASE}

## step 5 filter indels and snps
grep '^#' ${DENOVO_DIR}/${VCF_RAW_FILE} > ${DENOVO_DIR}/${VCF_SNP_FILE}
grep '^#' ${DENOVO_DIR}/${VCF_RAW_FILE} > ${DENOVO_DIR}/${VCF_INDEL_FILE}
grep SNP_ ${DENOVO_DIR}/${VCF_RAW_FILE} >> ${DENOVO_DIR}/${VCF_SNP_FILE}
grep INDEL_ ${DENOVO_DIR}/${VCF_RAW_FILE} >> ${DENOVO_DIR}/${VCF_INDEL_FILE}

## filter step 6 only one snp per cluster
#1SNP_by_cluster.py ${DENOVO_DIR}/${VCF_SNP_FILE} ${DENOVO_DIR}/${VCF_UNLINKED}

## filter step 6 snps by invd and pop
#${SCRIPT_DIR}/${FILTER_SNP_SCRIPT}

# filter step 7 (run 6 or 7) with populations script from stacks

${SCRIPT_DIR}/${STR_POPSCRIPT}
 

let limit=$NUM_POP
let i=$min_pop
while [ $limit -ge $i ]
do
	mkdir -p ${DENOVO_DIR}/P$i
	populations -t 4 -V ${DENOVO_DIR}/${VCF_SNP_FILE} -M ${LIST_DIR}/str_popfile -O ${DENOVO_DIR}/P$i -p $i -r $min_samples --min_maf $min_maf --max_obs_het $max_obs_het --fstats -f p_value --bootstrap --verbose --hwe
	grep '^#' ${DENOVO_DIR}/${VCF_SNP_FILE} > ${DENOVO_DIR}/P$i/pop${i}_filtered.vcf
	grep '^#' -v  ${DENOVO_DIR}/P$i/snp.p.sumstats.tsv | cut -f2 > locus.txt
	mapfile -t LOCUS < locus.txt && rm locus.txt
	for a in "${LOCUS[@]}"
	do
		grep $a ${DENOVO_DIR}/snp.vcf >> ${DENOVO_DIR}/P$i/pop${i}_filtered.vcf
		vcftools --vcf ${DENOVO_DIR}/P$i/pop${i}_filtered.vcf --recode --stdout > ${DENOVO_DIR}/P$i/pop${i}_filtered.recode.vcf
	done
	
	# filter randomly 1k snp (optional)
	#grep '^#' ${DENOVO_DIR}/P$i/pop${i}_filtered.vcf > ${DENOVO_DIR}/P$i/1krandom.vcf
	#grep '^#' -v ${DENOVO_DIR}/P$i/pop${i}_filtered.vcf | shuf | head -n 1000 >> ${DENOVO_DIR}/$i/1krandom.vcf && echo 1krandom creado

	## step 8 convert vcf to phylip(rxml), pgd, nexus, bayescan, genepop, structure.
	cd $PGDspiderPATH
	java -Xmx3072m -Xms512M -jar PGDSpider2-cli.jar -inputfile ${DENOVO_DIR}/P$i/pop${i}_filtered.recode.vcf -inputformat VCF -outputfile ${DENOVO_DIR}/P$i/${OUT_PGD} -outputformat PGD -spid ${SPID_DIR}/${VCF_PGD_SPID}
	java -Xmx3072m -Xms512M -jar PGDSpider2-cli.jar -inputfile ${DENOVO_DIR}/P$i/${OUT_PGD} -inputformat PGD -outputfile ${DENOVO_DIR}/P$i/${OUT_STR} -outputformat STRUCTURE -spid ${SPID_DIR}/${PGD_STR_SPID}
	#java -Xmx3072m -Xms512M -jar PGDSpider2-cli.jar -inputfile ${DENOVO_DIR}/P$i/${OUT_PGD} -inputformat PGD -outputfile ${DENOVO_DIR}/P$i/${OUT_NEXUS} -outputformat NEXUS -spid ${SPID_DIR}/${PGD_NEXUS_SPID}
	#java -Xmx3072m -Xms512M -jar PGDSpider2-cli.jar -inputfile ${DENOVO_DIR}/P$i/${OUT_PGD} -inputformat PGD -outputfile ${DENOVO_DIR}/P$i/${OUT_RXML} -outputformat PHYLIP -spid ${SPID_DIR}/${PGD_RXML_SPID}
	#java -Xmx3072m -Xms512M -jar PGDSpider2-cli.jar -inputfile ${DENOVO_DIR}/P$i/${OUT_PGD} -inputformat PGD -outputfile ${DENOVO_DIR}/P$i/${OUT_GENEPOP} -outputformat GENEPOP -spid ${SPID_DIR}/${PGD_GENEPOP_SPID}
	cd $BASE
	let i=$i+1
done
	


