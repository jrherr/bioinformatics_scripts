#!/usr/bin/perl -w

#########################################################################################################
# Program: reverseComplement.pl
# Purpose: get reverse complement sequences from a fasta sequence file
# Input: sequence fasta file
# Output: reverse complement sequences in fasta file
# Author: Wenjie Deng
# Date: 2009-01-05
###########################################################################################################

use strict;

my $usage = "perl reverseComplement.pl input_fasta_file output_fasta_file\n";
my $inFastaFile = shift or die $usage;
my $outFastaFile = shift or die $usage;
my $unixFile = $inFastaFile.".unix";

my (@seqNames, %nameSeq);
my $flag = my $totalSeq = 0;
my $seqName = "";

ConvertToUnix ($inFastaFile, $unixFile);

open INFASTA, $unixFile or die "couldn't open $unixFile: $!\n";
while (my $line = <INFASTA>) {
	chomp $line;
	next if $line =~ /^\s*$/;
	if ($line =~ /^>(.*)/) {
		$seqName = $1;
		push @seqNames, $seqName;
		$totalSeq++;
	}else {
		$nameSeq{$seqName} .= $line;
	}
}
close INFASTA;
unlink $unixFile;

open OUTFASTA, ">$outFastaFile" or die "couldn't open $outFastaFile: $!\n";
foreach my $seqName (@seqNames) {
	my $seq = reverse $nameSeq{$seqName};
	$seq =~ tr /ACGTacgt/TGCAtgca/;		
	print OUTFASTA ">",$seqName, "\n";
	print OUTFASTA $seq,"\n";
}
close OUTFASTA;

print "Total $totalSeq sequences in input fasta file. All done!\n";


######################################################################################
sub ConvertToUnix {
	my ($infile, $unixFile) = @_;
	open (IN, $infile) or die "Couldn't open $infile: $!\n";
	open (OUT, ">$unixFile") or die "Couldn't open $unixFile: $!\n";
	my @buffer = <IN>;
	close IN;
	my $line = "";
	foreach my $element (@buffer) {
		$line .= $element;
	}
	if ($line =~ /\r\n/) {
		$line =~ s/\r//g;
	}elsif ($line =~ /\r/) {
		$line =~ s/\r/\n/g;
	}
	print OUT $line;	
	close OUT;	
}