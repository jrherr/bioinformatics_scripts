#! /usr/bin/perl -w

################################################################################
# This script converts the alignment sequences in nexus sequential format to 
# fasta format 
# Author: Wenjie Deng
# usage: perl Nexus2Fasta.pl infile outfile
################################################################################
use strict;

my $usage = "usage: perl Nexus2Fasta.pl infile outfile\n";
my $infile = shift or die $usage;	# input Nexus file name
my $outfile = shift or die $usage;	# output fasta file
my $unixfile = $infile."_unix";
my $count = my $seqStartFlag = 0;

system ("tr '\r' '\n' <$infile >$unixfile");
open(IN, $unixfile) || die "Can't open $unixfile: $!\n";
open(OUT, ">$outfile") || die "Can't open out $outfile: $!\n";

while(my $line = <IN>) {
	chomp $line;
	next if ($line =~ /^\s*$/);
	$line =~ s/^\s+//;
	$line =~ s/\s+$//;
	if ($line =~ /^MATRIX$/i) {
		$seqStartFlag = 1;
	}elsif ($line =~ /^\;$/) {
		$seqStartFlag = 0;
	}elsif ($seqStartFlag) {
		unless ($line =~ /^\[/) {						
			if ($line =~ /^(\S+)\s+(\S+)\s+\[\d+\]$/ || $line =~ /^(\S+)\s+(\S+)$/) {
				my $seqName = $1;
				my $seq = $2;
				print OUT ">$seqName\n$seq\n";
				$count++;					
			}
		} 				
	}
}
close IN;
close OUT;
unlink $unixfile;
print "There are total $count sequences\n";