#!/bin/bash
#SBATCH --mail-user=sejoslin@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH -J qualFILT
#SBATCH -e 08_novoWork.%j.err
#SBATCH -o 08_novoWork.%j.out
#SBATCH -c 20
#SBATCH -p high
#SBATCH --time=2-20:00:00
#SBATCH --mem=32G

set -e # exits upon failing command
set -v # verbose -- all lines

# run script with
#       sbatch 08_novoWork.sh

## Only run this script on the 4-8 best individuals <- found in /home/sejoslin/projects/DS_history/dataline_count.all.sorted


#####################
###  directories  ###
#####################
pop="sexMarker"
data_dir="/home/sejoslin/projects/${pop}/data/id_loci"
code_dir="/home/sejoslin/projects/${pop}/code"
script_dir="/home/sejoslin/scripts/"
fem_dir="/home/sejoslin/projects/${pop}/data/id_loci/females"
mal_dir="/home/sejoslin/projects/${pop}/data/id_loci/males"

##########################
###  id loci for both  ### 
###  females & males   ###
##########################
cd ${data_dir}

for sex in *males
do
	cd ${sex}
	## make file with all hashes
	echo "making file with all hashes for" ${sex}
	cat hashes/*.hash > ${tag}.fasta
	chmod a=r ${tag}.fasta

	## index DS_history.fasta
	echo "indexing" ${sex} 
	novoindex ${tag}.fa.index ${tag}.fasta
	chmod a=r ${tag}.fa.index

	## align DS_history.fasta
	echo "aligning" ${sex}
	novoalign  -r E 48 -t 180 -d ${tag}.fa.index -f ${tag}.fasta > ${tag}.novo
	chmod a=r ${tag}.novo
	cd ${data_dir}
done

