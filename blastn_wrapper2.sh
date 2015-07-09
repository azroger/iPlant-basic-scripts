#!/bin/bash

#wrapper script for blastn on iPlant DE
#more stuff from Roger Barthelson
#works with app built in the DE

blastn="/usr/local2/blast-2.2.26/bin/blastn-2.2.26"

database="$1"

INPUT_RD=$(basename $database)
if [ -r $INPUT_RD/*.nal ] ; then dbname=$(basename $INPUT_RD/*.nal .nal);
else
dbname=$(basename $INPUT_RD/*.nsq .nsq)
fi

mv $INPUT_RD/$dbname* ./
query="$2"
outfilename="$3"
outformat="$4"
evalue="$5"
options1="$7"
options2="$8"
if [ "$6" == ungapped ]; then options="-ungapped"; fi

$blastn -num_threads 4 -db $dbname -query $query -out $outfilename -outfmt $outformat -evalue $evalue $options $options1 $options2

rm -r $dbname.*

