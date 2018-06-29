#!/bin/bash

# Load needed vars and create dirs for the pipeline
. vars.sh

# Create pop map for runing stacks: codes_samples{\t}pop_codes
cut -c 1 $LIST_DIR/codes.txt > $LIST_DIR/pop_temp.txt
paste -d "\t" $LIST_DIR/codes.txt $LIST_DIR/pop_temp.txt > $LIST_DIR/popfile_stacks
rm -v $LIST_DIR/pop_temp.txt

 
