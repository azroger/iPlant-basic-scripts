#!/bin/bash

while getopts a:b: option
do
        case "${option}" in
        
                a) inputDirectory=${OPTARG};;
                
done

cd "$inputDirectory"
mkdir ../sorted_data

grep fold_change gene_exp.diff > ../sorted_data/sig_genes.sorted_by_fdr.txt
grep yes gene_exp.diff > test
sort -k13  test >> ../sorted_data/sig_genes.sorted_by_fdr.txt
grep fold_change gene_exp.diff > ../sorted_data/sig_genes.sorted_by_fold.txt
grep yes gene_exp.diff | sort -r -k10 >> ../sorted_data/sig_genes.sorted_by_fold.txt
grep fold_change gene_exp.diff > ../sorted_data/sig_genes.sorted_by_expression1.txt
grep yes gene_exp.diff | sort -r -k8 -k9 >> ../sorted_data/sig_genes.sorted_by_expression1.txt

grep fold_change isoform_exp.diff > ../sorted_data/sig_isoforms.sorted_by_fdr.txt
grep yes isoform_exp.diff | sort -k13 >> ../sorted_data/sig_isoforms.sorted_by_fdr.txt
grep fold_change isoform_exp.diff > ../sorted_data/sig_isoforms.sorted_by_fold.txt
grep yes isoform_exp.diff | sort -r -k10 >> ../sorted_data/sig_isoforms.sorted_by_fold.txt
grep fold_change isoform_exp.diff > ../sorted_data/sig_isoforms.sorted_by_expression1.txt
grep yes isoform_exp.diff | sort -r -k8 -k9 >> ../sorted_data/sig_isoforms.sorted_by_expression1.txt

