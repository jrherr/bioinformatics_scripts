#! /usr/bin/perl -w

#################################################################
# This script converts the sequences with SWISS-PROT format to
# fasta format
# usage: swissprot_2_fasta.pl infile outfile
#################################################################
use strict;

my $infile = $ARGV[0];	# input SwissProt sequence file name
my $outfile = $ARGV[1];	# output fasta file
my $unixFile = $infile."_unix";
my $count = my $sequence_flag = 0;
my $sp_id = my $seqName = "";

unless($infile && $outfile) {
	print "Usage: SwissProt2Fasta.pl infile outfile\n";
	exit;
}
system ("tr '\r' '\n' <$infile >$unixFile");
open(IN, $unixFile) || die "Can't open $unixFile: $!\n";
open(OUT, ">$outfile") || die "Can't open out $outfile: $!\n";

while(my $line = <IN>) {
	chomp $line;
	next if (!$line);
	if($line =~ /^\/\//) {
		$count++;
		$sequence_flag = 0;
		$sp_id = $seqName = "";
	}elsif($line =~ /^ID\s+(\S+)/) {
		$sp_id = $1;
	}elsif($line =~ /^AC\s+(\w+)/) {
		$seqName = $sp_id."|".$1;
	}
	elsif($line =~ /^SQ/) {
		print OUT ">$seqName\n";
		$sequence_flag = 1;
	}elsif($sequence_flag == 1) {
		$line =~ s/\s//g;
		print OUT $line."\n";
	}
}
close IN;
close OUT;
unlink $unixFile;
print "There are total $count sequences\n";
