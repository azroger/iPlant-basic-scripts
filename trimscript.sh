#!/bin/bash

cp $3 trimfile.txt
cuts=`cat trimfile.txt | grep -v \#`
if [ $1 == PE ]; then
for x in $2/*
do

        if [[ "$x" =~ .*1\.fq$ ]]; 
        then
        z=$(basename $x 1.fq)
                java -jar -Xmx1024m /root/Trimmomatic-0.33/trimmomatic-0.33.jar PE "$2"/"$z"'1.fq' "$2"/"$z"'2.fq' 'trmPr_'"$z"'1.fq' 'trmS_'"$z"'1.fq' 'trmPr_'"$z"'2.fq' 'trmS_'"$z"'2.fq' $cuts
        fi
        
        if [[ "$x" =~ .*1\.fastq$ ]]; 
        then
        z=$(basename $x 1.fastq)
                java -jar -Xmx1024m /root/Trimmomatic-0.33/trimmomatic-0.33.jar PE "$2"/"$z"'1.fastq' "$2"/"$z"'2.fastq' 'trmPr_'"$z"'1.fastq' 'trmS_'"$z"'1.fastq' 'trmPr_'"$z"'2.fastq' 'trmS_'"$z"'2.fastq' $cuts
        fi
done
fi
if [ $1 == SE ]; then
for x in $2/*
do
				y=$(basename $x)
				z='trimS'$y
				java -jar -Xmx1024m /root/Trimmomatic-0.33/trimmomatic-0.33.jar SE $x $z $cuts
done
fi
