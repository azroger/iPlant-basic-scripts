#!/bin/bash
#wrapper script for blastp on the iPlant DE
#more stuff from Roger Barthelson
#Designed to work with the app in the DE

export HOME=/var/lib/condor

while getopts a:b:c:d:e:f:g:h:k:l:m:n:o:p:q:r:s:t:u:v:x:y:z option
do
        case "${option}"
        in
        
                a) database=${OPTARG};;
                b) experimental=${OPTARG};;
                c) transcript_peps=${OPTARG};;
                d) out_fmt=${OPTARG};;
                e) max_matches=${OPTARG};;
                f) E_value=${OPTARG};;
                g) matrix=${OPTARG};;
                h) word_Size=${OPTARG};;
                k) gap_Open=${OPTARG};;
                l) gap_Extend=${OPTARG};;
                m) lcase_masking=${assembly_mode};;
#                 r) reference=${OPTARG};;
#                 s) min_isoform=${OPTARG};;
                t) Options1=${OPTARG};;
        esac
done

export blastbin="/usr/local2/ncbi-blast-2.2.30+/bin"

ARGS=''
database="${database}"
experimental="${experimental}"
transcript_peps="${transcript_peps}"
trans_peps=$(basename "${transcript_peps}")

if [ -n "${matrix}" ]; then ARGS="$ARGS -matrix $matrix"; fi
if [ -n "${word_Size}" ]; then ARGS="$ARGS -word_size $word_Size"; fi
if [ -n "${gap_Open}" ]; then ARGS="$ARGS -gapopen $gap_Open"; fi
if [ -n "${gap_Extend}" ]; then ARGS="$ARGS -gapextend $gap_Extend"; fi
if [ -n "${lcase_masking}" ]; then ARGS="$ARGS -lcase_masking"; fi
if [ -n "${max_matches}" ]; then ARGS="$ARGS -max_target_seqs $max_matches"; fi
if [ -n "${Options1}" ]; then ARGS="$ARGS $Options1"; fi

if [[ "$experimental" = "yes" ]]; then database="$database"'_exponly'; fi
name="$database"
database='/iplant/home/shared/iplantcollaborative/protein_blast_dbs/agbase_database/'"$database"'.fa'
/usr/local2/icommands3.3/iget $database
Dbase="$name"'.fa'
$blastbin/makeblastdb -in $Dbase -dbtype prot -title $name -out $name

$blastbin/blastp -num_threads 4 -query $trans_peps -db $name -out blastp_out.txt -outfmt $out_fmt $ARGS -evalue $E_value


