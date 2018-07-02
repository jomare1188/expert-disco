#!/bin/bash
#SBATCH --partition=longjobs
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --time=2:00:00
#SBATCH --job-name=bowtie2_example
#SBATCH -o result_%N_%j.out      # File to which STDOUT will be written
#SBATCH -e result_%N_%j.err      # File to which STDERR will be written
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jomare1188@gmail.com

export SBATCH_EXPORT=NONE
export OMP_NUM_THREADS=1

#module load bowtie2/2.3.0_intel-2017_update-1

# Load the needed vars and create dirs for this pipeline
. vars.sh

### First Step: Bowtie2 Build ###
# Run Bowtie2

#bowtie2-build --threads 3 $REF_DIR/$FASTA_FILE $INDEX_DIR/$PRODUCT
#bowtie2-build --threads $SLURM_NTASKS $REF_DIR/$FASTA_FILE $INDEX_DIR/$PRODUCT

### Second Step: Generate FastQ ###
#TODO: Refactor this scripts to generate SAM
#$SCRIPT_DIR/$PREPROC_SCRIPT

### Third Step: Generate SAM and BAM with Bowtie2 and Samtools ###
mapfile -t Vbarcode < $LIST_DIR/$CODES_FILE

let limit=${#Vbarcode[@]}-1
i=0
while [ $limit -ge $i ]
do
    #bowtie2 --threads 3 -x $INDEX_DIR/$PRODUCT -1 $FASTQS_DIR/"${Vbarcode[i]}"_R1_.fastq -2 $FASTQS_DIR/"${Vbarcode[i]}"_R2_.fastq -S $SAM_DIR/"${Vbarcode[i]}".sam | samtools view -hbS -T $REF_DIR/$FASTA_FILE | samtools sort -o $BAM_DIR/"${Vbarcode[i]}".bam
    #bowtie2 --threads 3 -x $INDEX_DIR/$PRODUCT -1 $FASTQS_DIR/"${Vbarcode[i]}"_R1_.fastq -2 $FASTQS_DIR/"${Vbarcode[i]}"_R2_.fastq -S $SAM_DIR/"${Vbarcode[i]}".sam
    samtools view -hb -T $REF_DIR/$FASTA_FILE $SAM_DIR/${Vbarcode[i]}.sam | samtools sort -o $BAM_DIR/${Vbarcode[i]}.bam 
    let i=$i+1

done

### Fourth Step: Run Stacks ###
#module load stacks/1.46_gcc-5.4.0
$SCRIPT_DIR/$POPFILE_SCRIPT

ref_map.pl -o $REFMAP_DIR/P1 -O $LIST_DIR/$POPMAP_FILE -T 4 -X "populations:--fasta_loci --fasta_samples_raw --phylip_var --phylip --vcf_haplotypes --genepop --fasta_samples --ordered_export --fasta_samples_raw  --write_random_snp --structure --vcf -p 1 -r 0.75 --fstats -f p_value --bootstrap --verbose -M $LIST_DIR/$POPMAP_FILE -k --smooth_fstats --smooth_popstats --hwe" --samples $BAM_DIR

populations -P $REFMAP_DIR/P1 -O $REFMAP_DIR/P2 -M $LIST_DIR/$POPMAP_FILE --fasta_samples_raw --phylip_var --phylip --vcf_haplotypes --genepop --fasta_samples --ordered_export --fasta_samples_raw  --write_random_snp --structure --vcf -p 2 -r 0.75 --fstats -f p_value --bootstrap --verbose -k --smooth_fstats --smooth_popstats --hwe --fasta_loci

populations -P $REFMAP_DIR/P1 -O $REFMAP_DIR/P5 -M $LIST_DIR/$POPMAP_FILE --fasta_samples_raw --phylip_var --phylip --vcf_haplotypes --genepop --fasta_samples --ordered_export --fasta_samples_raw  --write_random_snp --structure --vcf -p 5 -r 0.75 --fstats -f p_value --bootstrap --verbose -k --smooth_fstats --smooth_popstats --hwe --fasta_loci

