#!/usr/bin/perl -w

my $otuFile = shift;
my $tableFile = shift;
my $desCol = shift;
my $valCol = shift;

# ### Get OTUs.
#
my %otus = ();
open (OTUS, $otuFile);
while (<OTUS>) {
	chomp;
	$otus{$_} = 1;
}
close(OTUS);

open (TABLE, $tableFile);

# ### Print header.
# 
my $line = <TABLE>;
chomp($line);

my @headers = split(/\t/, $line);
my $header = join("\t", @headers[1..$desCol]);
foreach my $otu (sort (keys %otus) )
{
	$header .= "\t$otu";
}
print "$header\n";

# ### Get table data.
#
my %oTable = ();
while (<TABLE>) {
	chomp;
	
	my @fields = split(/\t/);
	my $rowHeader = join("\t", @fields[1..$desCol]);
	$oTable{$rowHeader}{$fields[0]} = $fields[$valCol];
}
close(TABLE);

# ### Print resulting data.
#
foreach my $rowHeader (sort (keys %oTable))
{
	$line = $rowHeader;
	foreach my $otu (sort (keys %otus))
	{
		$line .= "\t" . ( ( defined( $oTable{$rowHeader}{$otu} ) ) ? $oTable{$rowHeader}{$otu} : 0 );
	}
	chomp($line);
	print $line, "\n";
}
