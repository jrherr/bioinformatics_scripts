#! /usr/bin/perl -w

#################################################################
# This script converts the GenBank sequence flat format to fasta format
# usage: gbk_2_fasta.pl inFile outFile
#################################################################

use strict;

my $usage = "Usage: GB2Fasta.pl inFile outFile\n";
my $infile = shift or die $usage;	# input sequence file name
my $outfile = shift or die $usage;	# output fasta file
my $unixFile = $infile."_unix";

my $count = 0;
my $seq_flag = 0;
system ("tr '\r' '\n' <$infile >$unixFile");
open IN, $unixFile || die "Can't open $unixFile: $!\n";
open OUT, ">$outfile" || die "Can't open $outfile: $!\n";

while(my $line = <IN>) {
	chomp $line;
	next if (!$line);
	if($line =~ /^\/\/$/) {
		$seq_flag = 0;
		$count++;
	}elsif($line =~ /^VERSION\s+(\S+)\s+GI:(\S+)/) {
		my $acc = $1;
		my $gi = $2;
		print OUT ">|gi|$gi|gb|$acc|\n";
	}elsif($line =~ /^ORIGIN/) {
		$seq_flag = 1;
	}elsif($seq_flag == 1 && $line =~ /^\s*\d+\s(.*)$/) {
		my $seq = $1;
		$seq =~ s/\s//g;
		$seq = uc $seq;
		print OUT $seq."\n";
	}
}
close IN;
close OUT;
unlink $unixFile;
print "There are total $count sequences\n";
