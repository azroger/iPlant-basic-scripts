#!/usr/bin/perl -w

# Author: Roger Barthelson, 2014

# This script runs bowtie in the iPlant DE. It makes more sense if you copy the app in the DE and look at the copy in edit mode,
# so that you can see which option goes with which variable
# r=reference fasta, a=read file 1, g=read file 2, p=index name 

use strict;
use warnings;
use Getopt::Std;

my %opts = (a=>'', b=>'', c=>'', d=>'', e=>'', f=>'', g=>'', h=>'', p=>'', r=>'', t=>'', u=>'',);
getopts('a:b:c:d:e:f:g:h:p:r:t:u', \%opts);
die("Usage:[-a $opts{a}] [-b $opts{b}] [-c $opts{c}] [-d $opts{d}] [-e $opts{e}] [-f $opts{f}] [-g $opts{g}] [-h $opts{h}] [-p $opts{p}] [-r $opts{r}] [-t $opts{t}] [-u $opts{u}] \n") if (@ARGV eq '' && -t STDIN);


my $bowtie = "/usr/local2/bowtie2-2.1.0/bowtie2";
my $Bbuild = "/usr/local2/bowtie2-2.1.0/bowtie2-build";


my ($a, $b, $c, $d, $e, $f, $g, $h, $p, $r, $t , $u) = ($opts{a}, $opts{b}, $opts{c}, $opts{d}, $opts{e}, $opts{f}, $opts{g}, $opts{h}, $opts{p}, $opts{r}, $opts{t}, $opts{u});
print "$a, $b, $c, $d, $e, $f, $g, $h, $p, $r, $t, $u \n";
my $rd = '';
my $rd2 = '';
my $a2 = '';
my $indx = "$p";
my $ready_index = "$d";
if ( $g ne '' ) {
$rd2 = '-2'; 
$a2 = $g; 
$rd = '-1';
}
else {
$rd = '-U';
}

#
my $build_command = "$Bbuild $r $indx";
my $tar_command = "tar --remove-files -cf $indx.tar $indx.*.bt2";
my $zip_command = "gzip -S .gz *.tar";
my $align_command = "$bowtie -p 4 -I $b -X $c $f $e $t $indx $rd $a $rd2 $a2 -S $h";
my $untar_command = "tar -xvzf $ready_index";


if ( $d ne '' ) {
system("$untar_command");
} else {
system("$build_command");
}
report("$align_command");
system("$align_command");
#if ( $r ne '' ) {
system("$tar_command");
system("$zip_command");
#}
#print "Your bowtie command was $align_command \n";

sub report {

my $text = shift;
print STDERR $text, "\n";

}
