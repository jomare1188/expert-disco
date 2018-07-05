#!/bin/bash
# This script run structure analysis
# Author: Jorge Mario Muñoz <jomare8811@gmail.com>
# Date: 05/22/2018


## step 1 set variables
. vars.sh 

# step 2 define number of individuals and locus number
#sed -i '2d' "$STR_INPUT"
str_numbers () {
	let indv_number=$(grep ^G  $STR_INPUT | wc -l)/2
	let locus_number=$(head $STR_INPUT -n 1 | awk -F ' '  '{print NF }')
}
str_numbers
echo
echo son $indv_number individuos y $locus_number locus
echo 

# step 3 run structure for k=1
#echo definiendo lambda

structure -i $STR_INPUT -N $indv_number -L $locus_number -m $PARAMS_PATH/$MAINPARAMS_FILE -e $PARAMS_PATH/$EXTRA_LAMBDA_FILE -K 1 -o $STRUCTURE_DIR/lambda > /dev/null  # defino lambda


# lambda estimation from the results file for k=1
grep "Mean value of lambda"  $STRUCTURE_DIR/lambda_f > lambda
sed -i 's# ##g' lambda
LAMBDA=$(cut lambda -d "=" -f 2)
rm lambda
#rm -v lambda

echo
echo  lambda estimated = "$LAMBDA"
echo

sed -i "30s|^.*$|#define LAMBDA    $LAMBDA // (d) Dirichlet parameter for allele frequencies |" $PARAMS_PATH/$EXTRA_FILE

$SCRIPT_DIR/structure_ks.sh

