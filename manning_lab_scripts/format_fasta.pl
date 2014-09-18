#!usr/bin/perl -w

### Script reads in sequence file, formats sequence and creates
# formatted output file, with sequence either contiguous, or 
# in lines of defined length ###

use strict;
use library;

my $filename = usrquery ("Please enter filename");
my @filedata = read_file_data ($filename);
my $sequence = extract_sequence (@filedata);
$sequence =~ tr/actg/ACTG/;
$sequence =~ s/[\s0-9]//g;
composition ($sequence);

my $tag = extract_tag (@filedata);
my $length = usrquery ("Length of line? (0 returns one-word sequence)");
my $outputfile = usrquery ("Please enter output filename");

unless 	(open(OUTFILE, ">$outputfile"))
	{print "Cannot open file \"OUTFILE\" to write to";
	exit;}
if ($length == 0)
	{print OUTFILE "$tag\n";
	print OUTFILE "$sequence";
	close (OUTFILE);
	exit;
	}
else 	{print OUTFILE "$tag\n";
	for (my $pos = 0; $pos < length($sequence); $pos += $length)
		{print OUTFILE substr($sequence, $pos, $length), "\n";}	
	}
exit;


