#!/usr/bin/perl -w
# Usage: poly_count.pl -f fasta_file -m integer
#---------------------------------------------------------------------------------------------------------------------------
#Deal with passed parameters
#---------------------------------------------------------------------------------------------------------------------------
#If no arguments are passed, show usage message and exit program.
if ($#ARGV == -1) {
    &usage;
    exit;
}
%my_args = @ARGV;
$minimum = 5;
$out_file = "homopolymers.fasta";
for $i (sort keys %my_args) {
    if ($i eq "-f") {
	$fasta_file = $my_args{$i};
	unless ( open(FASTA, "$fasta_file") ) {
	    print "Got a bad fasta file: $fasta_file\n";
	    &usage;
	}
    }
    elsif ($i eq "-o") {
	$out_file = $my_args{$i};
    }
    elsif ($i eq "-m") {
	$minimum = $my_args{$i};
	if ( !($minimum =~ /\d+/) || $minimum < 1 ) {
	    print "Bad integer: $minimum. Must be >= 1.\n";
	    &usage;
	}
    }
    else {
	print "Unrecognized paramater: $i $my_args{$i}\n";
	&usage;
    }
}
unless ( open(OUT, ">$out_file") ) {
    print "Got a bad ouput file: $out_file\n";
    &usage;
}
#Everything looks good. Print the parameters we've found.
print "Parameters:\nfasta file = $fasta_file\nminimum number to count = $minimum\n\n";

#---------------------------------------------------------------------------------------------------------------------------
#The main event
#---------------------------------------------------------------------------------------------------------------------------
%headers = ();
%records = ();
$homopolymer_count = 9999;
print "Poly Seq Length\tPolyA\tPolyT\tPolyG\tPolyC\tPolyN\tPolyX\n";
@fasta = <FASTA>;
$i = $minimum;
while ($homopolymer_count > 0) {
    $total_seq_length = 0;
    $count = 0;
    $counta = 0;
    $countt = 0;
    $countg = 0;
    $countc = 0;
    $countx = 0;
    $countn = 0;
    $string = "";
    $header = "";
    for $line (@fasta) {
	if ($line =~ /^>/) {
	    $count++;
	    $records{$header} = $string;
	    $homopolymer_count = &process_string($i);
	    $total_seq_length = $total_seq_length + length($string);
	    $header = $line;
	    chomp($header);
	    $header =~ s/\r//g;
	    $header =~ s/^>//g;
	    $string = "";
	}
	else {
	    chomp($line);
	    $string = $string . $line;
	}
    }
    $homopolymer_count = &process_string($i);
    $total_seq_length = $total_seq_length + length($string);
    $average_seq_length = $total_seq_length / $count;
    $total_seq_length = 0;
    print "$i\t$counta\t$countt\t$countg\t$countc\t$countn\t$countx\n";
    $i++;
}
print "Number of Fasta Entries = $count\n";
print "Average Sequence Length = $average_seq_length\n";
close(FASTA);

for $i (sort keys %headers) {
    if ($headers{$i} =~ /\t/) {
	$acount = 0;
	$tcount = 0;
	$gcount = 0;
	$ccount = 0;
	$xcount = 0;
	$ncount = 0;
	@polycounts = split(/\t/, $headers{$i});
	for $j (0..$#polycounts) {
	    @parts = split(/=/, $polycounts[$j]);
	    if ($parts[0] eq "A" && $parts[1] > $acount) {
		$acount = $parts[1];
	    }
	    elsif ($parts[0] eq "T" && $parts[1] > $tcount) {
		$tcount = $parts[1];
	    }
	    elsif ($parts[0] eq "G" && $parts[1] > $gcount) {
		$gcount = $parts[1];
	    }
	    elsif ($parts[0] eq "C" && $parts[1] > $ccount) {
		$ccount = $parts[1];
	    }
	    elsif ($parts[0] eq "X" && $parts[1] > $xcount) {
		$xcount = $parts[1];
	    }
	    elsif ($parts[0] eq "N" && $parts[1] > $ncount) {
		$ncount = $parts[1];
	    }
	    else {
		print "ERROR!\n";
		&usage;
	    }
	}
	print OUT ">$i ";
	if ($acount > 0) {
	    print OUT "A=$acount";
	    if ($tcount > 0 || $gcount > 0 || $ccount > 0 || $xcount > 0 || $ncount > 0) {
		print OUT ", ";
	    }
	}
	if ($tcount > 0) {
	    print OUT "T=$tcount";
	    if ($gcount > 0 || $ccount > 0 || $xcount > 0 || $ncount > 0) {
		print OUT ", ";
	    }
	}
	if ($gcount > 0) {
	    print OUT "G=$gcount";
	    if ($ccount > 0 || $xcount > 0 || $ncount > 0) {
		print OUT ", ";
	    }
	}
	if ($ccount > 0) {
	    print OUT "C=$ccount";
	    if ($xcount > 0 || $ncount > 0) {
		print OUT ", ";
	    }
	}
	if ($xcount > 0) {
	    print OUT "X=$xcount";
	    if ($ncount > 0) {
		print OUT ", ";
	    }
	}
	if ($ncount > 0) {
	    print OUT "N=$ncount";
	}
	print OUT "\n";
	print OUT "$records{$i}\n";
    }
    else {
	print OUT ">$i $headers{$i}\n";
	print OUT "$records{$i}\n";
    }
}

close(OUT);
#--------------------------------------------------------------------------
#Subroutines
#--------------------------------------------------------------------------
sub process_string {
    ($myi) = @_;
    $stringa = "A{$myi}";
    $stringt = "T{$myi}";
    $stringg = "G{$myi}";
    $stringc = "C{$myi}";
    $stringx = "X{$myi}";
    $stringn = "N{$myi}";
    if ($string =~ /$stringa/) {
	$counta++;
	if ($headers{$header}) {
	    $headers{$header} = $headers{$header} . "\tA=" . $myi;
	}
	else {
	    $headers{$header} = "A=$myi";
	}
    }
    if ($string =~ /$stringt/) {
	$countt++;
	if ($headers{$header}) {
	    $headers{$header} = $headers{$header} . "\tT=" . $myi;
	}
	else {
	    $headers{$header} = "T=$myi";
	}
    }
    if ($string =~ /$stringg/) {
	$countg++;
	if ($headers{$header}) {
	    $headers{$header} = $headers{$header} . "\tG=" . $myi;
	}
	else {
	    $headers{$header} = "G=$myi";
	}
    }
    if ($string =~ /$stringc/) {
	$countc++;
	if ($headers{$header}) {
	    $headers{$header} = $headers{$header} . "\tC=" . $myi;
	}
	else {
	    $headers{$header} = "C=$myi";
	}
    }
    if ($string =~ /$stringx/) {
	$countx++;
	if ($headers{$header}) {
	    $headers{$header} = $headers{$header} . "\tX=" . $myi;
	}
	else {
	    $headers{$header} = "X=$myi";
	}
    }
    if ($string =~ /$stringn/) {
	$countn++;
	if ($headers{$header}) {
	    $headers{$header} = $headers{$header} . "\tN=" . $myi;
	}
	else {
	    $headers{$header} = "N=$myi";
	}
    }
    return $counta + $countt + $countg + $countc +$countx + $countn;
}
sub usage {
    print "\nUsage: poly_count.pl -f fasta_file -m integer\n";
    print "\nParameters:\n";
    print "-f fasta_file:\tThe fasta file you wish to analyze.\n";
    print "-m integer:\tThe minimum number of consecutive nucleotides to consider. Optional. Default is 5.\n";
    print "-o out_file:\tWrites the sequence ID output to this file. Optional. Default is homopolymers.txt.\n\n";
    print "This program returns the number of fasta entries with at least N consecutive Zs,\n";
    print "where N = is the range from the integer provided to the point that their are no more homopolymers,\n";
    print "and Z = A, G, C, T, X, and N.\n\n";
    print "It also returns the number of entries in the fasta file, and the average sequence length.\n\n";
    print "The output is a tab delimmited matrix, written to standard out.\n";
    print "To write the output to a file, run as follows:\n";
    print "poly_count.pl -f fasta_file -m an_integer >my_file\n\n";
    print "This file also returns a fasta file with the sequence IDs found with more than the minimum number of\n";
    print "consecutive nucleotides, along with nucleotide and count found (e.g. A=24, C=8).\n\n";
    print "Jennifer Meneghin\n";
    print "Last updated 01/24/2011\n\n";
    exit(1);
}
