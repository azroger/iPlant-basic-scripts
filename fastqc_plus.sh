#! /bin/bash

#script to run fastqc and generate fancy reports in .html files with embedded images
#Roger Barthelson

for x in *.fastq
do
fastqc -t 4 $x -o ./
done
for y in *.fq
do
fastqc -t 4 $y -o ./
done
unzip *.zip

	echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN">' > fastqc_summary.html
	echo '<html' >> fastqc_summary.html
	echo '<head><title>Summary of Fastqc Reports</title>' >> fastqc_summary.html
	echo '<style type="text/css">' >> fastqc_summary.html
	echo '	body { font-family: sans-serif; color: #0098aa; background-color: #FFF; font-size: 100%; border: 0; margin: 0; padding: 0; }' >> fastqc_summary.html
	echo '	h1 { font-family: sans-serif; color: #0098aa; background-color: #FFF; font-size: 300%; font-weight: bold; border: 0; margin: 0; padding: 0; }' >> fastqc_summary.html
	echo '	h2 { font-family: sans-serif; color: #0098aa; background-color: #FFF; font-size: 200%; font-weight: bold; border: 0; margin: 0; padding: 0; }' >> fastqc_summary.html	
	echo '	h3 { font-family: sans-serif; color: #0098aa; background-color: #FFF; font-size: 40%; font-weight: bold; border: 0; margin: 0; padding: 0; }' >> fastqc_summary.html
	echo '	.TFtable tr:nth-child(even){ background: #D2DADC; }'	>> fastqc_summary.html	
	echo '	</style>' >> fastqc_summary.html
	echo '	</head>' >> fastqc_summary.html
	echo '	<h1> Summary of Fastqc Reports' >> fastqc_summary.html
	echo '	<br/>' >> fastqc_summary.html
	echo '	<br/>' >> fastqc_summary.html
	echo '	<br/> </h1>' >> fastqc_summary.html
	echo '	<body> ' >> fastqc_summary.html
	echo '	<table border="1" cellpadding="10" bgcolor="white" class="TFtable">' >> fastqc_summary.html
	echo '	<tr>' >> fastqc_summary.html
	echo '	<td><b>Fastq File Name</b></td>' >> fastqc_summary.html
	echo '    <td><b>Basic Statistics</b></td>' >> fastqc_summary.html
	echo '    <td><b>Per base sequence quality</b></td>' >> fastqc_summary.html
	echo '    <td><b>Per sequence quality scores</b></td>' >> fastqc_summary.html
	echo '    <td><b>Per base sequence content</b></td>' >> fastqc_summary.html
	echo '    <td><b>Per base GC content</b></td>' >> fastqc_summary.html
	echo '    <td><b>Per sequence GC content</b></td>' >> fastqc_summary.html
	echo '    <td><b>Per base N content</b></td>' >> fastqc_summary.html
	echo '    <td><b>Sequence Length Distribution</b></td>' >> fastqc_summary.html
	echo '    <td><b>Sequence Duplication Levels</b></td>' >> fastqc_summary.html
	echo '    <td><b>Overrepresented sequences</b></td>' >> fastqc_summary.html
	echo '    <td><b>Kmer Content</b></td>' >> fastqc_summary.html
	echo ' </tr>' >> fastqc_summary.html

	WW=0
	for w in *_fastqc
	do
	WW=`expr $WW + 1`
	echo ' <tr>' >> fastqc_summary.html
	echo '	<div>' >> fastqc_summary.html
	echo '	<ul>' >> fastqc_summary.html
	cd $w
	ww=`echo $w | sed 's/_fastqc/_report.html'/`
	embed_images.pl fastqc_report.html ../"$ww"
	csplit -f sum ../"$ww" /\<li\>/ {10} /class=\"main\"\>/
	test=`grep 'Kmer graph' ../"$ww"`	
	if [[ -n $test ]];
	then 	
	csplit ../"$ww" /'<div class="module">'/ {10} /'alt="Kmer graph"'/
	else
	csplit ../"$ww" /'<div class="module">'/ {10} /'<p>No overrepresented Kmers</p>'/ 
	fi
	seq_file=`grep title\> xx00 | sed 's/<head><title>//'  | sed 's/FastQC\ Report<\/title>//'`
	echo "	<td><b>$seq_file</b></td>" >> ../fastqc_summary.html
	sumRe=( sum01 sum02 sum03 sum04 sum05 sum06 sum07 sum08 sum09 sum10 sum11 )
	for ((RR=0; RR < 11; RR += 1))
	do
	cellcontent=`cat "${sumRe[$RR]}" | sed s/#M/\#\$WW-M/`
	echo "	<td><b>$cellcontent</b></td>" >> ../fastqc_summary.html
	done		
	cd ..
	echo ' </tr>' >> fastqc_summary.html
	done
	echo '</table>' >> fastqc_summary.html
	echo '	<br/>' >> fastqc_summary.html
	echo '	<br/>' >> fastqc_summary.html
	echo '	<br/>' >> fastqc_summary.html
	echo '	<br/>' >> fastqc_summary.html
	echo '<table border="1" cellpadding="10" bgcolor="white" class="TFtable">' >> fastqc_summary.html
	echo '	<tr>' >> fastqc_summary.html
	echo '    <td><b>Basic Statistics</b></td>' >> fastqc_summary.html
	echo '    <td><b>Per base sequence quality</b></td>' >> fastqc_summary.html
	echo '    <td><b>Per sequence quality scores</b></td>' >> fastqc_summary.html
	echo '    <td><b>Per base sequence content</b></td>' >> fastqc_summary.html
	echo '    <td><b>Per base GC content</b></td>' >> fastqc_summary.html
	echo '    <td><b>Per sequence GC content</b></td>' >> fastqc_summary.html
	echo '    <td><b>Per base N content</b></td>' >> fastqc_summary.html
	echo '    <td><b>Sequence Length Distribution</b></td>' >> fastqc_summary.html
	echo '    <td><b>Sequence Duplication Levels</b></td>' >> fastqc_summary.html
	echo '    <td><b>Overrepresented sequences</b></td>' >> fastqc_summary.html
	echo '    <td><b>Kmer Content</b></td>' >> fastqc_summary.html
	echo ' </tr>' >> fastqc_summary.html
	WW=0
	for w in *_fastqc
	do
	WW=`expr $WW + 1`
	echo ' <tr>' >> fastqc_summary.html	
	cd $w	
	seq_file=`grep title\> xx00 | sed 's/<head><title>//'  | sed 's/FastQC\ Report<\/title>//'`	
	xxRe=( xx01 xx02 xx03 xx04 xx05 xx06 xx07 xx08 xx09 xx10 xx11 )	
	for ((SS=0; SS < 10; SS += 1))
	do
	graphstuff=`cat "${xxRe[$SS]}" | sed 's/"indented" src=/"indented" height="320" width="400" src=/g'`
	graphcontent="<h3 id=$WW-M$SS > $seq_file $graphstuff </h3>"

	echo "	<td><b>$graphcontent</b></td>" >> ../fastqc_summary.html
	done
	test=`grep 'Kmer graph' ../"$ww"`	
	if [[ -n $test ]];
	then
	graphstuff11=`cat "xx11" | sed 's/"indented" src=/"indented" height="320" width="400" src=/g'`
	graphcontent11="<h3 id=$WW-M10 > $seq_file $graphstuff11 "'"</h2></p></div></h3>'
    else
	graphstuff11=`cat "xx11"`
	graphcontent11="<h3 id=$WW-M10 > $seq_file $graphstuff11 "'"alt="[OK]"> Kmer Content</h2><h3><p>No overrepresented Kmers</p></div></h3>'
	fi
	echo "	<td><b>$graphcontent11</b></td>" >> ../fastqc_summary.html
	cd ..
	echo ' </tr>' >> fastqc_summary.html
	done
	echo '</table>' >> fastqc_summary.html					
	echo '</body>' >> fastqc_summary.html
	echo '</html' >> fastqc_summary.html
	
	rm -r *_fastqc
	if [[ -n "$Dir1" ]];
    then 
	rm validate*
	fi
	mkdir individual_reports
	mv *report.html individual_reports/
	mv *fastqc.zip individual_reports/
