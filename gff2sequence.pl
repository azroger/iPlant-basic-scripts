#!/usr/local/bin/perl

@fields = qw(seqname source feature start end score strand frame group);

$width = 50;

use SeqFileIndex;
use GFFTransform;

$usage .= "$0 - extract GFF-specified sequences from a sequence database\n";
$usage .= "\n";
$usage .= "Usage: $0 [-prefix prefix|-name expr] [-trans <GFF transformation file>] [-regx <regex expression>] <sequence file> [<GFF file>]\n";
$usage .= "\n";

while (@ARGV) {
    last unless $ARGV[0] =~ /^-/;
    $opt = lc shift;
    if ($opt eq "-prefix") { defined($prefix = shift) or die $usage }
    elsif ($opt eq "-name") { defined($nameexpr = shift) or die $usage }
    elsif ($opt eq "-trans") { defined($trans = shift) or die $usage }
    elsif ($opt eq "-regx") { defined($regx = shift) or die $usage }
    else { die "$usage\nUnknown option: $opt\n" }
}

if (defined $nameexpr) { for ($i=0;$i<@fields;$i++) { $nameexpr =~ s/\$gff$fields[$i]/\$gff->[$i]/g } }

if (defined $trans) { read_transformation($trans); sort_seqnames() }

@ARGV>=1 or die $usage;
$seqfile = shift;

$index = new SeqFileIndex($seqfile);

while (<>) {
    s/#.*//;
    next unless /\S/;
    chomp;
     my $identity;
     my $exon;
    @f = split /\t/;
    $gff = \@f;
    ++$count;
        $Grp = $f[8];
        my @g = split /\s/, $Grp;
    	for ( $i = 0 ; $i <= 12 ; $i++ ) { if ( $g[$i] eq $regx ) { $j = $i+1; $identity = "$g[$j]"; } }
    	$identity =~ s/"//g;
    	$identity =~ s/;//;
    	$identity =~ s/\s//;
        for ( $i = 0 ; $i <= 12 ; $i++ ) { if ( $g[$i] eq "exon_number" ) { $j = $i+1; $exon = "$g[$j]"; } }
    	$exon =~ s/"//g;
    	$exon =~ s/;//;
    	$exon =~ s/\s//;
    if (defined $trans) { @nse = back_transform(@f[0,3,4]) }
    else { @nse = ([@f[0,3,4]]) }
    if (@nse) {
	if (defined $prefix) { $name = "$f[0]x$f[3]-$f[4]x.$identity" }
	elsif (defined $nameexpr) { $name = eval $nameexpr }
	elsif ($exon and $regx =~ m/transcript*/ ) { $name = "$identity"".exon""$exon" } 
	else { $name = "$identity" }
	$seq = "";
	foreach $nse (@nse) { $seq .= $index->getseq(@$nse) }
	if (length $seq) {
	    print ">$name\n";
	    for ($i=0;$i<length $seq;$i+=$width) { print substr($seq,$i,$width),"\n" }
	}
    }
}

