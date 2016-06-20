#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long qw(:config no_ignore_case no_auto_abbrev pass_through);
use Data::Dumper;


report_input_stack();

my $cannedReference      = '';
my $userReference        = '';
my (@sampleOne,@sampleTwo,@sampleThree,@sampleFour,@sampleFive,@sampleSix,@sampleSeven,@sampleEight,@sampleNine,@sampleTen,@sampleEleven,@sampleTwelve,@sampleThirteen,@sampleFourteen,@sampleFifteen,@sampleSixteen,$fdr);
my ($tophat_out,$cuffmerge_out,$nameOne,$nameTwo,$nameThree,$nameFour,$nameFive,$nameSix,$nameSeven,$nameEight,$nameNine,$nameTen,$nameEleven,$nameTwelve,$nameThirteen,$nameFourteen,$nameFifteen,$nameSixteen,$version,$mask_file);
my $fasta = '';
my $result = GetOptions (
                          'cannedReference=s'     => \$cannedReference,
                          'userReference=s'       => \$userReference,
                          'sampleOne=s'           => \@sampleOne,
                          'sampleTwo=s'           => \@sampleTwo,
                          'sampleThree:s'         => \@sampleThree,
                          'sampleFour:s'          => \@sampleFour,
                          'sampleFive:s'          => \@sampleFive,
                          'sampleSix:s'           => \@sampleSix,
                          'sampleSeven:s'         => \@sampleSeven,
                          'sampleEight:s'         => \@sampleEight,
                          'sampleNine:s'          => \@sampleNine,
                          'sampleTen:s'           => \@sampleTen,
                          'sampleEleven=s'        => \@sampleEleven,
                          'sampleTwelve=s'        => \@sampleTwelve,
                          'sampleThirteen:s'      => \@sampleThirteen,
                          'sampleFourteen:s'      => \@sampleFourteen,
                          'sampleFifteen:s'       => \@sampleFifteen,
                          'sampleSixteen:s'       => \@sampleSixteen,
                          'nameOne=s'             => \$nameOne,
                          'nameTwo=s'             => \$nameTwo,
                          'nameThree:s'           => \$nameThree,
                          'nameFour:s'            => \$nameFour,
                          'nameFive:s'            => \$nameFive,
                          'nameSix:s'             => \$nameSix,
                          'nameSeven:s'           => \$nameSeven,
                          'nameEight:s'           => \$nameEight,
                          'nameNine:s'            => \$nameNine,
                          'nameTen:s'             => \$nameTen,
                          'nameEleven=s'          => \$nameEleven,
                          'nameTwelve=s'          => \$nameTwelve,
                          'nameThirteen:s'        => \$nameThirteen,
                          'nameFourteen:s'        => \$nameFourteen,
                          'nameFifteen:s'         => \$nameFifteen,
                          'nameSixteen:s'         => \$nameSixteen,
#			  'version=s'             => \$version,
			  'mask-file=s'           => \$mask_file,
			  'FDR=s'                 => \$fdr,
			  'frag-bias-correct=s'   => \$fasta
			  
);

# Annotation sanity check
unless ($cannedReference || $userReference) {
    die "Reference or custom annotations must be supplied for CuffDiff\n";
}
# Custom trumps canned
if ($userReference) {
    $cannedReference = $userReference;
}

my $cmd = 'cuffdiff';


# get rid of empty labels (assumes in order)
my @labels = grep {$_} ($nameOne,$nameTwo,$nameThree,$nameFour,$nameFive,$nameSix,$nameSeven,$nameEight,$nameNine,$nameTen,$nameEleven,$nameTwelve,$nameThirteen,$nameFourteen,$nameFifteen,$nameSixteen);
my $ARGS = join(' ', @ARGV);
$cmd .= " $ARGS -o cuffdiff_out";

if ($fdr) {
    $cmd .= " --FDR $fdr";
}

if ($fasta) {
    $cmd .= " --frag-bias-correct $fasta";
}

if ($mask_file) {
    $cmd .= " -M $mask_file";
}

if (@labels) {
    $cmd .= ' --labels '.join(',',@labels).' ';
}

$cmd .= " -p 4 ";

# Append GTF file
# but check it first for p_id and CDS features (cummeRbund will puke otherwise)
if (! `grep p_id $cannedReference` || ! `grep CDS $cannedReference`) {
    system "/cuffdiff_fix_anno.pl $cannedReference $fasta";
}

$cmd .= $cannedReference ? "$cannedReference " : ' ';


for (\@sampleOne,\@sampleTwo,\@sampleThree,\@sampleFour,\@sampleFive,\@sampleSix,\@sampleSeven,\@sampleEight,\@sampleNine,\@sampleTen,\@sampleEleven,\@sampleTwelve,\@sampleThirteen,\@sampleFourteen,\@sampleFifteen,\@sampleSixteen) {
    if ($_ && @$_ == 1) {
	if (-d $_->[0]) {
	    my $d = shift @$_;
	    while (my $f = <$d/*>) {
		push @$_, $f
		}
	}
    }
    
    $cmd .= ' '.join(',',@$_) if @$_;
}

print STDERR "Running $cmd\n";

system("$cmd 2>cuffdiff.stderr");

my $success = -e "cuffdiff_out/gene_exp.diff";

exit 1 unless $success;


# sort the data some
system "/cuffdiff_sort.sh";


sub report {
    print STDERR "$_[0]\n";
}


sub report_input_stack {
    my @stack = @ARGV;
    my %arg;

    while (@stack) {
        my $k = shift @stack;
    my $v = shift @stack;
        if ($v =~ /^-/) {
            unshift @stack, $v;
            $v = 'TRUE';
        }
        push @{$arg{$k}}, $v;
    }

    report("Input parameters:");
    for (sort keys %arg) {
        report(sprintf("%-25s",$_) . join(',',@{$arg{$_}}));
    }
}

