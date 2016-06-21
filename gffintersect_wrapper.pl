#!/usr/bin/perl -w

# Author: Roger Barthelson

# This script runs a transcript annotation pipeline
# Please enter the installation path on line 16, for $install_directory

use strict;
use warnings;
use Getopt::Std;

$ENV{PATH} = "/usr/local2/bin:$ENV{PATH}";
$ENV{PATH} = "/bin:$ENV{PATH}";
$ENV{PATH} = "/usr/bin:$ENV{PATH}";

my %opts = (a=>'', b=>'', c=>'', d=>'', e=>'', f=>'', g=>'',  h=>'', r=>'', t=>'', k=>'',);
getopts('a:b:c:d:e:f:g:h:p:r:t:k', \%opts);
die("Usage:[-a $opts{a}] [-b $opts{b}] [-c $opts{c}] [-d $opts{d}] [-e $opts{e}] [-f $opts{f}] [-g $opts{g}]  [-h $opts{h}] [-r $opts{r}] [-t $opts{t}] [-k $opts{k}] \n") if (@ARGV eq '' && -t STDIN);

my $install_directory = "/usr/local2/AnnotateTranscripts/annotate_transcripts";
my $bedtools_dir = "/usr/local2/bin";
my $intersect2gff = "$install_directory/intersectgff2gff.pl";
my $sort_gff;
my $write_fasta;

my ($a, $b, $c, $d, $e, $f, $g, $h, $r, $t, $k, ) = ($opts{a}, $opts{b}, $opts{c}, $opts{d}, $opts{e}, $opts{f}, $opts{g}, $opts{h}, $opts{r}, $opts{t}, $opts{k},);
print "$a, $b, $c, $d, $e, $f, $g, $h, $r, $t, $k, \n";

my $filter_command1 = "$install_directory/gfffilter.pl '\$gfffeature eq exon' '$a' > anno_exons.gff";
my $filter_command2 = "$install_directory/gfffilter.pl '\$gfffeature eq exon' '$b' > transcripts.gff";
my $intersectBed = "bedtools intersect -wao -f $f -r -a transcripts.gff -b anno_exons.gff > exons_intersect_all.out";
my $intersect_script = "$install_directory/intersectgff2gff.pl exons_intersect_all.out $c intersect.gff $d $e";
$sort_gff = "sort -k 8 intersect.gff | uniq > $g";
if ($h and $k) {
$write_fasta = "$install_directory/gff2sequence.pl -prefix $h -regx $t $r $g > $g.fa 2>gff2seq.err";
} elsif ($k) {
$write_fasta = "$install_directory/gff2sequence.pl -regx $t $r $g > $g.fa 2>gff2seq.err";
} else {
$write_fasta = "";
}
report("$intersectBed");
system("$filter_command1");
system("$filter_command2");
system("$intersectBed");
system("$intersect_script");
system("$sort_gff");

system("$write_fasta");

#system("rm gff2seq.err");

print "Your annotation filter command was $filter_command1 \n";
print "Your assembly gff filter command was $filter_command2 \n";
print "Your Intersect-Bed command was $intersectBed \n";
print "Your gff parsing command was $intersect_script \n";
print "Your script for writing the fasta file was $write_fasta \n";

sub report {

my $text = shift;
print STDERR $text, "\n";

}
