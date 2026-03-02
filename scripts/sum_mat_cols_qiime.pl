#! /usr/bin/perl -w
#
#

	die "Usage: mat_file\n" unless (@ARGV);
	($mat) = (@ARGV);

	die "Please follow command line args\n" unless ($mat);
	chomp ($mat);
	
	open (IN, "<$mat") or die "Can't open $mat\n";
	while ($line=<IN>){
		chomp ($line);
		next if ($line=~/#/);
		($OTU, @abunds) = split ("\t", $line);
		$j=@abunds;
		$i=0;
		until ($i >=$j){
			$hash{$i}+=$abunds[$i];
			$i++;
		}
	}
	close (IN);


foreach $index (sort {$a <=> $b} values %hash){
	print "$index\n";
}

