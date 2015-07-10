#!/bin/bash

#wrapper script for blastp on the iPlant DE
#more stuff from Roger Barthelson
#Designed to work with the app in the DE

blastp="/usr/local2/ncbi-blast-2.2.29+/bin/blastp"

database="$1"

INPUT_RD=$(basename $database)
if [ -r $INPUT_RD/*.pal ] ; then dbname=$(basename $INPUT_RD/*.pal .pal);
else
dbname=$(basename $INPUT_RD/*.psq .psq)
fi

mv $INPUT_RD/$dbname* ./
query="$2"
outfilename="$3"
outformat="$4"
evalue="$5"
options1="$6"
options2="$7"

$blastp -num_threads 4 -db $dbname -query $query -out $outfilename -outfmt $outformat -evalue $evalue $options $options1 $options2

rm -r $dbname.*

