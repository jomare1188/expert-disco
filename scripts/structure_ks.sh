#!/bin/bash
# This script run structure analysis
# Author: Jorge Mario Muñoz <jomare8811@gmail.com>
# Date: 05/22/2018


## step 1 set variables
. vars.sh 

str_numbers () {
	let indv_number=$(grep ^G  $STR_INPUT | wc -l)/2
	let locus_number=$(head $STR_INPUT -n 1 | awk -F ' '  '{print NF }')
}
# Parallelization of the structure runs in 4 cores

#####################################################

(
str_numbers
limite=15
i1=1
while [ $limite -ge $i1 ]
do
	let aux_nucleo1=$i1-1
	nucleo1=(6 6 6 5 5 4 4 4 3 3 3 2 2 1 1)
	echo nucleo 1 ciclo "$i1" de "$limite"
	structure -i $STR_INPUT -N $indv_number -L $locus_number -m $PARAMS_PATH/$MAINPARAMS_FILE -e $PARAMS_PATH/$EXTRA_FILE -K "${nucleo1[$aux_nucleo1]}" -o mkdir $STRUCTURE_DIR/structure_n1_K"${nucleo1[$aux_nucleo1]}"."$i1" > /dev/null
	let i1=$i1+1
done
) &  
(
str_numbers
limite=15
i2=1
while [ $limite -ge $i2 ]
do
	let aux_nucleo2=$i2-1
	nucleo2=(6 6 6 5 5 4 4 3 4 3 3 2 2 1 1)
	echo nucleo 2 ciclo "$i2" de "$limite"
	structure -i $STR_INPUT -N $indv_number -L $locus_number -m $PARAMS_PATH/$MAINPARAMS_FILE -e $PARAMS_PATH/$EXTRA_FILE -K "${nucleo2[$aux_nucleo2]}" -o $STRUCTURE_DIR/structuren_n2_K"${nucleo2[$aux_nucleo2]}"."$i2" > /dev/null
	let i2=$i2+1
done
) &   
(
str_numbers
limite=15
i3=1
while [ $limite -ge $i3 ]
do
	let aux_nucleo3=$i3-1
	nucleo3=(6 6 5 5 5 4 4 3 3 2 2 2 1 1 1)
	echo nucleo 3 ciclo "$i3" de "$limite"
	structure  -i $STR_INPUT -N $indv_number -L $locus_number -m $PARAMS_PATH/$MAINPARAMS_FILE -e $PARAMS_PATH/$EXTRA_FILE -K "${nucleo3[$aux_nucleo3]}" -o $STRUCTURE_DIR/structure_n3_K"${nucleo3[$aux_nucleo3]}"."$i3" > /dev/null
	let i3=$i3+1
done
) &
(
str_numbers
limite=15
i4=1
while [ $limite -ge $i4 ]
do
	let aux_nucleo4=$i4-1
	nucleo4=(6 6 5 5 5 4 4 3 3 2 2 2 1 1 1)
	echo nucleo 4 ciclo "$i4" de "$limite"
	structure -i $STR_INPUT -N $indv_number -L $locus_number -m $PARAMS_PATH/$MAINPARAMS_FILE -e $PARAMS_PATH/$EXTRA_FILE -K "${nucleo4[$aux_nucleo4]}" -o mkdir $STRUCTURE_DIR/structure_n4_K"${nucleo4[$aux_nucleo4]}"."$i4" > /dev/null 
	let i4=$i4+1
done
) &

wait

echo FINSH
