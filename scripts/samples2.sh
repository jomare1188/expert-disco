#!/bin/bash
# Load the needed vars and create dirs for this pipeline
. vars.sh

## Step 1: locate .bz2 files and extract samples names and .bz2 paths

if [ $NO_SAMPLES -eq 0 ]
	then
	find ${RAW_DIR} -name "*.bz2" | sort  > ${LIST_DIR}/listbz2.txt
	else
	find ${RAW_DIR} -name "*.bz2" | sort | head -n ${NO_SAMPLES} > ${LIST_DIR}/listbz2.txt
fi

cat ${LIST_DIR}/listbz2.txt | rev | cut -d'/' -f 1 | rev | sed 's/_clipped_passed-re-filter//g' | sed 's/.bz2//g' | sed 's/_R1/_R1_/g' | sed 's/_R2/_R2_/g'  > ${LIST_DIR}/samples.txt
mapfile -t LIST_BZ2 < ${LIST_DIR}/listbz2.txt # read listabz2 into an array
mapfile -t SAMPLES < ${LIST_DIR}/samples.txt


## Step 2 create fof for discosnp ###############################################
echo creando fofs para DiscoSNP
sed -e 's#^#'${BASE}/fastqs/'#' ${LIST_DIR}/samples.txt > ${LIST_DIR}/temp
cut -d "_" -f 1  ${LIST_DIR}/temp | rev | cut -d "/" -f 1 | rev | sort -u > ${LIST_DIR}/codes.txt
mapfile -t CODES < ${LIST_DIR}/codes.txt

LIMIT=0
i=0
let LIMIT=${#CODES[@]}-1
while [ $LIMIT -ge $i ]
do
    grep ${CODES[i]} ${LIST_DIR}/temp >> $BASE/denovo/fof_set_${CODES[i]}
    echo fof_set_${CODES[i]} >> $BASE/denovo/fof.txt
    let i=$i+1
done

## Step 3 unzip bz2 files, format names to code_R#_.fastq, filter big and small files.
if [ $LINES -eq 0 ]
then
    echo corriendo modo full samples
	i1=0
	let LIMIT0=${#LIST_BZ2[@]}-1
	while [  $LIMIT0 -ge $i1 ]
	do
			bzip2 -dck ${LIST_BZ2[i1]} > "${BASE}"/fastqs/${SAMPLES[i1]}
	    	echo $i1 de ${LIMIT0}  "${BASE}"/fastqs/${SAMPLES[i1]}
	    	let i1=$i1+1
	done
else ### discard files below a min number of reads
    echo corriendo modo selectivo con $LINES lineas
    i=0
    LIMIT2=0
    let LIMIT2=${#LIST_BZ2[@]}-1
    while [ $LIMIT2 -ge $i ]
    do
		#bzcat ${LIST_BZ2[i]} | head -n ${MAX_LINES} > "${BASE}"/fastqs/${SAMPLES[i]}  ### activate to discard lines above ${MAX_LINES} 
		bzcat ${LIST_BZ2[i]} > "${BASE}"/fastqs/${SAMPLES[i]}
		echo $i de ${LIMIT2}
		let READS=$(wc -l   ${BASE}/fastqs/${SAMPLES[i]} | cut -d " " -f 1)
		if (($READS < $LINES))
		then
			echo el archivo ${BASE}/fastqs/${SAMPLES[i]} no tiene mas de 1M reads y se eliminara del analisis && rm  "${BASE}"/fastqs/${SAMPLES[i]} -v
			echo ${BASE}/fastqs/${SAMPLES[i]} >> ${LIST_DIR}/eliminated.txt
		fi
	let i=$i+1
    done    
## Step 4 rewritting fof taking into account the eliminated files
	if [ -e ${LIST_DIR}/eliminated.txt ]
	then
		cat ${LIST_DIR}/eliminated.txt | rev | cut -d "/" -f 1 | rev | cut -d  "_" -f 1 | sort -u >> ${LIST_DIR}/eliminated_codes.txt
		mapfile -t ELIMINATED < ${LIST_DIR}/eliminated.txt


		echo corrigiendo fof
		LIMIT=0
		i=0
		let LIMIT=${#ELIMINATED[@]}-1
		while [  $LIMIT -ge $i ]
		do
			rm "$BASE"/denovo/fof_set_${ELIMINATED[i]}
			let i=$i+1
		done

		ls ${BASE}/denovo/ | grep fof_set_* > ${BASE}/denovo/fof.txt
	else
		echo no se borro ningun archivo luego del filtro
	fi
fi


