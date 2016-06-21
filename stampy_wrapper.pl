#!/usr/bin/perl -w

# Author: Roger Barthelson

# This script runs STAMPY


use strict;
use warnings;
use Getopt::Std;

my %opts = (a=>'', b=>'', c=>'', d=>'', e=>'', f=>'', g=>'', h=>'', p=>'', r=>'', t=>'', u=>'',);
getopts('a:b:c:d:e:f:g:h:p:r:t:u', \%opts);
die("Usage:[-a $opts{a}] [-b $opts{b}] [-c $opts{c}] [-d $opts{d}] [-e $opts{e}] [-f $opts{f}] [-g $opts{g}] [-h $opts{h}] [-p $opts{p}] [-r $opts{r}] [-t $opts{t}] [-u $opts{u}] \n") if (@ARGV eq '' && -t STDIN);

my $stampy = "/usr/local2/stampy-1.0.17/stampy.py";
my $bwabuild = "/usr/local2/bin/bwa index";
my $bwa = "/usr/local2/bin/bwa";
#my $stampybuild2 = "stampy.py";

my ($a, $b, $c, $d, $e, $f, $g, $h, $p, $r, $t , $u) = ($opts{a}, $opts{b}, $opts{c}, $opts{d}, $opts{e}, $opts{f}, $opts{g}, $opts{h}, $opts{p}, $opts{r}, $opts{t}, $opts{u});
print "$a, $b, $c, $d, $e, $f, $g, $h, $p, $r, $t, $u \n";

my $indx = "$p";

my $reads ='';
if ($b ne '') {
$reads = "$a,$b";
}
else {
$reads = $a;
}
my $align_command = '';
my $build_command1 = "$stampy -G $indx $r";
my $build_command2 = "$stampy -g $indx -H $indx";
my $bwabuild_command = "$bwabuild -a bwtsw -p $indx $r";
my $tar_command = "tar --remove-files -cf $indx.tar $indx.*";
my $zip_command = "gzip -9 -S .gz $indx.tar";
if ($t ne '') {
$align_command = "$stampy -g $indx -h $indx -o $f -M $reads $g $c $d $e";
} else {
$align_command = "$stampy --bwaoptions='-q$h $indx' -g $indx -h $indx -o $f -M $reads $g $c $d $e --bwa='/usr/local2/bin/bwa' ";
#
}
report("$align_command");
system("$build_command1");
system("$build_command2");
if ($t eq '') {
system("$bwabuild_command");
}
system("$align_command");
system("$tar_command");
system("$zip_command");
print "Your stampy command was $align_command \n";
print "Your build1 command was $build_command1 \n";
print "Your build2 command was $build_command2 \n";
sub report {

my $text = shift;
print STDERR $text, "\n";

}
