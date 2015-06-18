#! /usr/bin/perl -w

########################################################################################
# This script takes a fasta file, removes non-alphabetical characters such as
# "-, ?, #, $", and outputs fasta file with non-nucleotide characters removed
# usage: SequCleaner.pl infile outfile
########################################################################################
use strict;

my $usage = "usage: SequCleaner.pl infile outfile\n";
my $infile = shift or die $usage;	# input file name
my $outfile = shift or die $usage;	# output file name
my $unixfile = $infile."_unix";
my $seq_num = my $flag = 0;
my $seq;

system ("tr '\r' '\n' <$infile >$unixfile");
open(IN, $unixfile) || die "Can't open $unixfile: $!\n";
open(OUT, ">$outfile") || die "Can't open $outfile: $!\n";

while(my $line = <IN>) {
	chomp $line;
	if(!$line) {
		next;
	}
	if($line =~ /^>/) {
		print OUT $line."\n";
		$seq_num++;
	}else {
		$line =~ tr/a-z/A-Z/;
		for(my $i = 0; $i < length $line; $i++) {
			my $char = substr($line, $i, 1);
			unless ($char =~ /[A-Z]/) {
				$char = "";
			}
			$seq .= $char; # get clean sequence
		}
		if ($seq) {
			print OUT $seq."\n";
		}
		$seq = "";
	}
}
close IN;
close OUT;
unlink $unixfile;
print "There are total $seq_num sequences.\n";
