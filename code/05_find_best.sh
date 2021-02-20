#!/bin/bash
#BATCH --mail-user=sejoslin@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH -J findBEST
#SBATCH -e 05_find_best.%j.err
#SBATCH -o 05_find_best.%j.out
#SBATCH -c 20
#SBATCH -p high
#SBATCH --time=1-20:00:00
#SBATCH --mem MaxMemPerNode

set -e # exits upon failing command
set -v # verbose -- all lines

# run script with
#       sbatch 05_find_best.sh

# set up directories
pop="sexMarker"
code_dir="/home/sejoslin/projects/${pop}/code"
data_dir="/home/sejoslin/projects/${pop}/data"
sum_file="/home/sejoslin/projects/${pop}/data/line_count.all"


cd ${data_dir}
touch ${sum_file}

# go into the run's directory
for i in BMAG0??
do
cd ${i}
echo "Finding top individuals for" ${i}
  # then go into each library's directory and count lines for each individual
  for library in 04_split_wells.${i}.??????.sh
  do
  index=$(echo ${library} | cut -d. -f3)
  echo ${index}
  cd ${index}
  wc -l *R?.fastq >> ${sum_file}
  cd ../
  done
cd ../
done

sort -n ${sum_file} > ${sum_file}.sorted
head ${sum_file}.sorted

mkdir ${data_dir}/id_loci
