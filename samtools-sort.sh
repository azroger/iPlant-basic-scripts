#!/bin/bash

SAMTOOLS_BASE="/usr/local2/samtools-0.1.19"

SOURCE=$1
RESULT=$2
RESULT_PREF=`basename $RESULT .bam`

${SAMTOOLS_BASE}/samtools-0.1.19 sort -m 2000000000 $SOURCE $RESULT_PREF && exit 0

exit 1
