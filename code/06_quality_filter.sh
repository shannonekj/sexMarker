#!/bin/bash
#SBATCH --mail-user=sejoslin@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH -J qualFILT
#SBATCH -e 06_quality_filter.%j.err
#SBATCH -o 06_quality_filter.%j.out
#SBATCH -c 20
#SBATCH -p high
#SBATCH --time=2-20:00:00
#SBATCH --mem MaxMemPerNode

set -e # exits upon failing command
set -v # verbose -- all lines

# run script with
#       sbatch 06_quality_filter.sh

## Only run this script on the 4-8 best individuals <- found in /home/sejoslin/projects/DS_history/dataline_count.all.sorted

## NOTE: Before executing this script you will want to have a best_individuals.list file listing the best individuals
#	Example:
#		   18226528 Ht27-09_2014_A02_R1.fastq BMAG048 ATTCCT
#		   24013304 Ht20-09_2012_A02_R1.fastq BMAG048 GTGGCC
#		   26550224 Ht22-09_2013_A02_R1.fastq BMAG048 CGTACG
#		   36538932 Ht25-78_2014_F10_R1.fastq BMAG048 ACTGAT
#		   ^wc -l   ^file		      ^batch  ^bar
#
#	AND
# You will need to make sure the following scripts are appropriate and in ${code_dir}
# 	QualityFilter.pl <- P = 80 |  L = 80  | ph = 33
#	HashSeqs.pl
#	PrintHashHisto.pl

########################
### Best Individuals ###
########################

#	Example file name RX70_2_M_H12_GCCAAGAC_R1.fastq

#####################
###  directories  ###
#####################
pop="sexMarker"
out_dir="/home/sejoslin/projects/${pop}/data/id_loci"
code_dir="/home/sejoslin/projects/${pop}/code"
script_dir="/home/sejoslin/scripts/"
in_dir="/home/sejoslin/projects/${pop}/data"
fem_dir="/home/sejoslin/projects/${pop}/data/id_loci/females"
mal_dir="/home/sejoslin/projects/${pop}/data/id_loci/males"

##########################
###  id loci for both  ### 
###  females & males   ###
##########################
cd ${out_dir}
mkdir females
mkdir males

for sex in *males
do
F1="${out_dir}/best_individuals.${sex}.list"
n=$(wc -l $F1 | awk '{print $1}')
echo "Navigating to" ${out_dir}/${sex}
cd ${out_dir}/${sex}
## Grab best individuals
echo "Creating sym links for" ${n} "individuals"
x=1
while [ $x -le $n ]
do
        string="sed -n ${x}p $F1"
        str=$($string)
        var=$(echo $str | awk -F" " '{print $2}')
        bar=$(echo $str | awk -F" " '{print $4}')
        batch=$(echo $str | awk -F" " '{print $3}')
        set -- $var
        ln -s ${in_dir}/${batch}/${bar}/${var} ${var}
        x=$(( $x + 1 ))
done

###############################
###      Quality Filter     ###
###      hash and view      ###
##  occurences vs sequences  ##
###############################

cd ${out_dir}/${sex}
mkdir L80P80
mkdir hashes
mkdir sum_stats
mkdir raw

for i in *_R1.fastq
do
        qual=$(basename $i _R1.fastq)
        echo "Starting" ${sex} ${i}
        date

        echo "Quality filtering" ${sex} ${qual}
        perl ${code_dir}/QualityFilter.pl ${i} > ${qual}_L80P80.${sex}.fastq
        head -2 ${qual}_L80P80.${sex}.fastq
        date

        echo "Shrinking" ${qual}
        perl ${code_dir}/HashSeqs.pl ${qual}_L80P80.${sex}.fastq ${qual}  > ${qual}_L80P80.${sex}.hash
        head -2 ${qual}_L80P80.${sex}.hash
        date

        echo "Creating histogram for data in" ${qual}
        perl ${code_dir}/PrintHashHisto.pl ${qual}_L80P80.${sex}.hash > ${qual}_L80P80.${sex}.txt
        date

        echo "Finished with" ${sex} ${i}
done

# clean up
mv *_L80P80.${sex}.fastq L80P80/.
mv *.hash hashes/.
mv *_L80P80.${sex}.txt sum_stats/.
mv *.fastq raw/.

echo "completed" ${sex}

cd ${out_dir}
done
