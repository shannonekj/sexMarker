#!/bin/bash
#SBATCH --mail-user=sejoslin@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH -J unzip
#SBATCH -e 02_unzip.%j.err
#SBATCH -o 02_unzip.%j.out
#SBATCH -c 20
#SBATCH -p med
#SBATCH --time=1-20:00:00

set -e
set -x

#  This script will unzip all raw RAD data for Delta Smelt sex marker BMAG051
#       Run with
#               sbatch -t 1-20:00:00 -p med -A millermrgrp --mem MaxMemPerNode 02_unzip.sh

#################################
###  declare local variables  ###
#################################
pop="sexMarker"
code_dir="/home/sejoslin/projects/${pop}/code"
data_dir="/home/sejoslin/projects/${pop}/data"

###############
###  unzip  ###
###############

cd $data_dir
echo "start at:"
date

for i in BMAG0??
do
cd $i
for file in *.gz
do
newname=$(basename $file .gz)
echo "unzipping " $file " to " $newname
gunzip $file
chmod a=r $newname
done
cd ../
done

echo "end at:"
date
