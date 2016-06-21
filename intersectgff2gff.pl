#! /usr/bin/perl

# This is a piece taken from of one of Matt Vaughn's script and then modified extensively by Roger Barthelson

open (INTERSECT, $ARGV[0]) or die "Cannot open input file\n";

my $regex = $ARGV[1];
my $newgff = $ARGV[2];
my $assembly_tag = $ARGV[3];
my $regex_2 = $ARGV[4];
open( GFIL,  ">>$newgff" )  or die "Cannot open output file\n";

while (<INTERSECT>) {
    s/#.*//;
    next unless /\S/;
    
    my @f = split /\t/, $_,;
    if (@f < 10) { warn @f,"Not correct format"; next }
    $seqname = $f[0];
    $source = $f[1];
    $type = $f[2];
    $begin = $f[3];
    $end = $f[4];
    $score = $f[5];
    $strand = $f[6];
    $frame = $f[7];
    $grp = $f[8];

    $Grp = $f[17];
    my $name;
    my $identity;
    my $other_id;
    my $exon = '';
    $grp =~ s/=/ /g;
    $grp =~ s/;/ /g;
    $grp =~ s/  / /g;
    my @n = split /\s/, $grp, 5;

    for ( $x = 0 ; $x <= 5 ; $x++ ) { if ( $n[$x] eq $assembly_tag ) { $y = $x+1; $name = "$n[$y]"; } }
    $identity = $name;
    $other_id = $name;
    $name =~ s/"//g;

    $Grp =~ s/=/ /g;
    $Grp =~ s/;/ /g;
    $Grp =~ s/  / /g;
    my @g = split /\s/, $Grp;

    for ( $i = 0 ; $i <= 12 ; $i++ ) { if ( $g[$i] eq $regex ) { $j = $i+1; $identity = "$g[$j]"; } }

    $identity =~ s/"//g;
    $identity =~ s/;//;
    $identity =~ s/\s//;
    
    for ( $i = 0 ; $i <= 12 ; $i++ ) { if ( $g[$i] eq $regex_2 ) { $j = $i+1; $other_id = "$g[$j]"; } }

    $other_id =~ s/"//g;
    $other_id =~ s/;//;
    $other_id =~ s/\s//;
    
    for ( $i = 0 ; $i <= 12 ; $i++ ) { if ( $g[$i] eq "exon_number" ) { $j = $i+1; $exon = "$g[$j]"; } }

    $exon =~ s/"//g;
    $exon =~ s/;//;
    $exon =~ s/\s//;
	
    print GFIL "$seqname\t$source\t$type\t$begin\t$end\t$score\t$strand\t$frame\t"; 
    print GFIL "$regex";
    print GFIL " ";
    print GFIL '"';
    print GFIL "$identity";
    print GFIL '"';
    print GFIL ';';
    print GFIL " ";
    print GFIL "$regex_2";
    print GFIL " ";
    print GFIL '"';
    print GFIL "$other_id";
    print GFIL '"';
    print GFIL ';';
    print GFIL " ";   
    print GFIL "exon_id";
    print GFIL " ";
    print GFIL '"';
    print GFIL "$name";
    print GFIL "__";
    print GFIL "$identity";
		if ($exon and $regex =~ m/transcript*/ ) {
		print GFIL ".exon";
		print GFIL "$exon";
		}
    print GFIL '"';
    print GFIL ';';
		if ($exon) {
		print GFIL " ";
		print GFIL "exon_number";
		print GFIL " ";
		print GFIL '"';
		print GFIL "$exon";
		print GFIL '";';
		}
    print GFIL "\n";
    }
    close GFIL;
########################
    
