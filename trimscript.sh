#!/bin/bash

#cp $3 trimfile.txt
cat $3 | sed 's/ILLUMINACLIP:/ILLUMINACLIP:\/staging\//' > trimfile.txt
mkdir trimout
cuts=`cat trimfile.txt | grep -v \#`
if [ $1 == PE ]; then
for x in $2/*
do

        if [[ "$x" =~ .*1\.fq$ ]]; 
        then
        z=$(basename $x 1.fq)
                java -jar -Xmx1024m /root/Trimmomatic-0.33/trimmomatic-0.33.jar PE "$2"/"$z"'1.fq' "$2"/"$z"'2.fq' trimout/'trmPr_'"$z"'1.fq' trimout/'trmS_'"$z"'1.fq' trimout/'trmPr_'"$z"'2.fq' trimout/'trmS_'"$z"'2.fq' $cuts
        fi
        
        if [[ "$x" =~ .*1\.fastq$ ]]; 
        then
        z=$(basename $x 1.fastq)
                java -jar -Xmx1024m /root/Trimmomatic-0.33/trimmomatic-0.33.jar PE "$2"/"$z"'1.fastq' "$2"/"$z"'2.fastq' trimout/'trmPr_'"$z"'1.fastq' trimout/'trmS_'"$z"'1.fastq' trimout/'trmPr_'"$z"'2.fastq' trimout/'trmS_'"$z"'2.fastq' $cuts
        fi
done
fi
if [ $1 == SE ]; then
for x in $2/*
do
				y=$(basename $x)
				z='trimS'$y
				java -jar -Xmx1024m /root/Trimmomatic-0.33/trimmomatic-0.33.jar SE $x trimout/$z $cuts
done
fi
mv trimfile.txt trimmersettings.txt
