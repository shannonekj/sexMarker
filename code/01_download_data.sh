#!/bin/bash
#SBATCH --mail-user=sejoslin@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH -J downSex
#SBATCH -e 01_download_data.%j.err
#SBATCH -o 01_download_data.%j.out
#SBATCH -c 20
#SBATCH -p med
#SBATCH --time=1-20:00:00

set -e
set -x

#  This script will download all raw RAD data for finding a sex marker for delta smelt
#	Run with 
#		sbatch -t 1-20:00:00 -p med -A millermrgrp --mem MaxMemPerNode 01_download_data.sh
# don't forget to change modifications to raw files after download

cd /home/sejoslin/projects/sexMarker/data/
echo "Starting to download sexMarker data at"
date

#download and sort
wget -r -nH -nc -np -R index.html* http://slims.bioinformatics.ucdavis.edu/Data/sbzve7eghj/
date

