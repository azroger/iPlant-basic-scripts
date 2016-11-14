#!/bin/bash

export HOME=/var/lib/condor

#script to transfer GOA info from gene_association.goa_uniprot file for the agbase uniprot entries -- maintained in the Data Store for public access

/usr/local2/icommands3.3/iget /iplant/home/shared/iplantcollaborative/protein_blast_dbs/go_info/gene_association.goa_uniprot


blastfile=$1

#Pull out uniprot ids, replace the underline with a tab to separate out the main protein ids
cut -f2 $blastfile > blastf2
sed 's/_/\t/' < blastf2 | cut -f1 | uniq > blastids.txt

mkdir "splitgoa"

perl splitB.pl gene_association.goa_uniprot "splitgoa"

for x in splitgoa/temp*
do
perl -e ' $col1=0; $col2=1; ($f1,$f2)=@ARGV; open(F2,$f2); while (<F2>) { s/\r?\n//; @F=split /\t/, $_; $line2{$F[$col2]} .= "$_\n" }; $count2 = $.; open(F1,$f1); while (<F1>) { s/\r?\n//; @F=split /\t/, $_; $x = $line2{$F[$col1]}; if ($x) { $num_changes = ($x =~ s/^/$_\t/gm); print $x; $merged += $num_changes } } warn "\nJoining $f1 column $col1 with $f2 column $col2\n$f1: $. lines\n$f2: $count2 lines\nMerged file: $merged lines\n"; ' blastids.txt $x >> goa_entries.txt 
done

echo "I think I'm done!"
