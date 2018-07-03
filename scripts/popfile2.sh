#!/bin/bash
. vars.sh
## create pop file  for .vcf file created bt disco snp
CORRES_FILE=${DENOVO_DIR}/${PREFIX}_read_files_correspondance.txt
cut -d " " -f 1 ${CORRES_FILE} | cut -d "_" -f 2 | sed 's/^/G/' > indiv_temp
mapfile -t individuos < indiv_temp
rev $CORRES_FILE | cut -d " " -f 2 | cut -d "/" -f 1 | rev | cut -d "_" -f 1 > temp_indiv_codes

mapfile -t individuos_codes < temp_indiv_codes


for i in "${individuos_codes[@]}"
do
   echo $i | head -c 1 >> temp_pop_file
   echo >> temp_pop_file
done


sed 's/^/POP/' temp_pop_file > temp_pop_file_2
paste -d "\t" indiv_temp temp_pop_file_2 > ${LIST_DIR}/str_popfile

sed -i '21s#.*#VCF_PARSER_POP_FILE_QUESTION='${LIST_DIR}'/str_popfile#' $SPID_DIR/$VCF_PGD_SPID 
rm indiv_temp temp_indiv_codes temp_pop_file temp_pop_file_2



