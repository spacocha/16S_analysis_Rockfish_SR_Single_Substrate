#! /usr/bin/perl -w

die "Usage: .mat > redirect\n" unless (@ARGV);
($mat) = (@ARGV);
chomp ($mat);

$first=1;
open (IN, "<$mat" ) or die "Can't open $mat\n";
while ($line =<IN>){
    chomp ($line);
    if ($first){
    	$first=0;
	($OTU_ID, @pieces)=split ("\t", $line);
	print "OTU_ID";
	foreach $piece (@pieces){
		print "\t$piece";
	}
	print "\n";	
    } else {
	  print "$line\n";
    }
}

close (IN);

