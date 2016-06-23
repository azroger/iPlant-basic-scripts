#!/bin/bash

#wrapper script for blastp on condor
#more stuff from Roger Barthelson

deltablast="/usr/local2/ncbi-blast-2.2.29+/bin/deltablast"
CDD="/usr/local2/ncbi-blast-2.2.29+/databases/cdd_delta"

database="$1"
#iget -fr $database ./
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

$deltablast -num_threads 4 -db $dbname -query $query -out $outfilename -outfmt $outformat -evalue $evalue -rpsdb $CDD $options $options1 $options2

rm -r $dbname*

