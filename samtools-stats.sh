#!/bin/bash

SAMTOOLS="/usr/local2/samtools-0.1.19/samtools-0.1.19"
$SAMTOOLS index $1 && $SAMTOOLS idxstats $1 > $1.idxstats.txt && $SAMTOOLS flagstat $1 > $1.flagstat.txt
