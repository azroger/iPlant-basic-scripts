#!/bin/sh
export PATH="${PATH}:/usr/local2/samtools-0.1.19"

samtools-0.1.19 mpileup "$@" > samtools_mpileup_output
