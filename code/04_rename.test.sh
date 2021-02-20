#!/bin/bash -l
#SBATCH --mail-user=sejoslin@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH -J renameALL
#SBATCH -e 04_rename.test.%j.err
#SBATCH -o 04_rename.test.%j.out
#SBATCH -c 20
#SBATCH -p high
#SBATCH --time=1-20:00:00
#SBATCH --mem=32G

set -e # exits upon failing command
set -v # verbose -- all lines

## NOTE: Before executing this script you need to make a metadata file in proper format (see example below)
#	Name: BMAG047_GTCCGC.noNA.metadata
#	Content:
#		BMAG047	A01	ACAAGCTA	Ht18-01_2011_A01
#		BMAG047	B01	AACAACCA	Ht18-02_2011_B01
#		BMAG047	C01	AGATCGCA	Ht18-03_2011_C01	
#		^runID	^well#	^sample index	^unique name (can be anything but must be the same # of characters)

# run script with
#       sbatch 04_rename.test.sh

#################################
###  declare local variables  ###
#################################

pop="sexMarker"

# directories
code_dir="/home/sejoslin/projects/${pop}/code"
data_dir="/home/sejoslin/projects/${pop}/data"
script_dir="/home/sejoslin/scripts"
meta_dir="/home/sejoslin/projects/${pop}/data/metadata"

#################
###  BMAG051  ###
#################
dir="BMAG051"
# Barcode 1 #
index="CCGTCC"

cd ${data_dir}/${dir}/${index}
input="${meta_dir}/${dir}_${index}.noNA.metadata" # <-this is the metadata file
wc=$(wc -l ${input} | awk '{print $1}')
x=1
while [ $x -le $wc ]
do
        string="sed -n ${x}p ${input}"
        str=$($string)
        var=$(echo ${str} | awk -F"\t" '{print $1,$2,$3,$4}')
        set -- $var
        c1=$1 # run ID
        c2=$2 # well number
        c3=$3 # barcode
        c4=$4 # unique ID
        mv ${c1}_${index}_GG${c3}TGCAGG_R1.fastq ${c4}_R1.fastq
        mv ${c1}_${index}_GG${c3}TGCAGG_R2.fastq ${c4}_R2.fastq
        x=$(( $x + 1 ))
done

