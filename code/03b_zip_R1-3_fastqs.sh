#!/bin/bash
#SBATCH --mail-user=sejoslin@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH -J comp051
#SBATCH -e 03b_zip_R1-3_fastqs.%j.out
#SBATCH -o 03b_zip_R1-3_fastqs.%j.out
#SBATCH -c 20
#SBATCH -p bigmemh
#SBATCH --time=4-20:00:00

set -e # exits upon failing command
set -v # verbose -- all lines
set -x # trace of all commands after expansion before execution

data_dir="/home/sejoslin/projects/sexMarker/data"

i="BMAG051"
barcode="CCGTCC"

cd ${data_dir}/$i

echo Compressing fastq files in ${i} on $(date | awk '{print $4 " " $3 $2 $6}')
call="lzma *.fastq"
echo $call
eval $call
echo Compression complete at $(date | awk '{print $4 " " $3 $2 $6}')
