#!/bin/bash

# Input: BAM file representing alignment of
# RNAseq reads mapped to a reference genome
# Written by Roger Barthelson, based largely on a set of scripts by Matt Vaughn at TACC.

# PATH extension
# BEDtools
export PATH=/usr/local3/bin/BEDTools-Version-2.15.0/bin:${PATH}
# SAMTools
export PATH=/usr/local3/bin/samtools-0.1.16:${PATH}
# This script
# export PATH=/usr/local3/bin/bam2counts-1.00:${PATH}

usage()
{
cat << EOF
usage: $0 options

Generates a tab-delimited read count file from  
RNAseq alignments. Input is suitable for further 
use in packages such as edgeR and DEGseq.

OPTIONS:
	-h	Show this message
	-i	BAM file containing RNAseq alignments 
	-a	GFF3 annotation file for genome
	-q	Minimum PHRED-scaled mapping quality for reads
		[default: 20]
	-t	GFF type to be mapped against
		[default: exon]
	-r	Regex for defining transcript names
		[default: gene_id]
	-1	Short name for sample (ex Sample)
	-o	Name of the output text file containing count data
		[default: counts.txt]
	
Please note that the chromosome names and lengths for the BAM, VCF, 
and annotation files must be identical.
	
EOF
}

BAMFILE=
#ANNO="/usr/local3/bin/bam2counts-1.00/ZmB73_5b_FGS.gff"
ANNO=
ANNO_MODE="GFF"

MINMAPQUAL=
GFFTYPE="exon"
LOCUS_REGEX="gene_id"
COLNAME="Sample"

OUTPUT="sample_counts.txt"

while getopts “?ha:i:q:t:r:o:1:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         i)
             BAMFILE=$OPTARG
             ;;
         a)
             ANNO=$OPTARG
             ANNO=${ANNO/gtf/gff}
             ;;
         q)
             MINMAPQUAL=$OPTARG
             ;;
         t)
             GFFTYPE=$OPTARG
             ;;
         r)
             LOCUS_REGEX=$OPTARG
             ;;
         1)
             COLNAME=$OPTARG
             ;;
         o)
             OUTPUT=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

# Filter input BAM on mapping quality
# This basically removes non-unique matches and other cruft
# May be a better way to do this but will do for now

if [ -n "$MINMAPQUAL" ]
then
echo "Filtering ${BAMFILE} to minimum mapping quality"
	samtools view -bq ${MINMAPQUAL} ${BAMFILE} > filtered.bam
else
	ln -s ${BAMFILE} filtered.bam
fi

# Stats report
echo "Summarizing alignment index stats"
samtools index filtered.bam
samtools flagstat filtered.bam > bam-flagstat.txt
samtools idxstats filtered.bam > bam-idxstats.txt

SUBSET=

	# Filter annotation down to one feature type
	## May need to make this configurable in future
	SUBSET="subset.gff"
	echo "Extracting features from ${ANNO}"
	gfffilter.pl '$feature eq "exon"' ${ANNO} > $SUBSET
	# Creating gene manifest
	echo "Creating gene manifest from ${ANNO}"
		if [ $LOCUS_REGEX == gene_id ]
		then
		cut -f 9 $SUBSET | perl -e ' while(<>) { @F=split /\s/, $_; $reg = $ARGV[0]; for ( $i = 0 ; $i <= 12 ; $i++ ) { if ( $F[$i] eq gene_id ) { $j = $i+1; print "$F[$j]\n"; } } next }' | sed 's/"//g' | sed 's/;//' | sort | uniq > mrna.manifest
		fi
		if [ $LOCUS_REGEX == transcript_id ]
		then
		cut -f 9 $SUBSET | perl -e ' while(<>) { @F=split /\s/, $_; $reg = $ARGV[0]; for ( $i = 0 ; $i <= 12 ; $i++ ) { if ( $F[$i] eq transcript_id ) { $j = $i+1; print "$F[$j]\n"; } } next }' | sed 's/"//g' | sed 's/;//' | sort | uniq > mrna.manifest
		fi		 
		if [ $LOCUS_REGEX == gene_name ]
		then
		cut -f 9 $SUBSET | perl -e ' while(<>) { @F=split /\s/, $_; $reg = $ARGV[0]; for ( $i = 0 ; $i <= 12 ; $i++ ) { if ( $F[$i] eq gene_name ) { $j = $i+1; print "$F[$j]\n"; } } next }' | sed 's/"//g' | sed 's/;//' | sort | uniq > mrna.manifest
		fi	
		if [ $LOCUS_REGEX == transcript_name ]
		then
		cut -f 9 $SUBSET | perl -e ' while(<>) { @F=split /\s/, $_; $reg = $ARGV[0]; for ( $i = 0 ; $i <= 12 ; $i++ ) { if ( $F[$i] eq transcript_name ) { $j = $i+1; print "$F[$j]\n"; } } next }' | sed 's/"//g' | sed 's/;//' | sort | uniq > mrna.manifest
		fi
	# coverageBed
	# Result doesn't need to be annotated by the mRNA it is linked to
	coverageBed -abam filtered.bam -b $SUBSET | cut -f 1,4,5,9,10 > ${SUBSET}.bed

# Summarize counts by feature
# summarize_bed.pl bed regex manifest > counts.txt

echo -n -e "Gene\t${COLNAME}\n" > ${OUTPUT}
summarize_bed2.pl ${SUBSET}.bed "${LOCUS_REGEX}" | sort -k1 >> ${OUTPUT}
mv ${SUBSET}.bed ${OUTPUT}.bed

# Clean up
echo "Cleaning up"
#rm ${SUBSET} filtered.bam filtered.bam.bai mrna.manifest

exit 0
