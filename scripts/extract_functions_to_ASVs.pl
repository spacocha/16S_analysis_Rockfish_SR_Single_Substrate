#! /usr/bin/perl -w

die "Usage: FAPRO_report taxonomy > redirect\n" unless (@ARGV);
($FAPRO, $taxfile) = (@ARGV);
chomp ($FAPRO);
chomp ($taxfile);
die "Please include command line arg\n" unless ($taxfile);

open (IN, "<$taxfile" ) or die "Can't open $taxfile\n";
while ($line =<IN>){
    chomp ($line);
    next unless ($line);
    next if ($line=~/Taxon/);
    #Note: This was changed on 3/18/26, but run with it for most analyses
    #next if ($line=~/Archaea/);
    ($ASV, $taxonomy, $confidence)=split ("\t", $line);
    ($taxonomy)=~s/\; /\;/g;
    #die "$taxonomy\n";
    $hash{$taxonomy}{$ASV}++;
}
close (IN);

open (IN, "<${FAPRO}") or die "Can't open $FAPRO\n";
while ($line=<IN>){
    chomp ($line);
    next unless ($line);
    if ($line=~/^\#/){
	    #this starts a new function
	    ($function)=$line=~/^\# (.+?) /;
	    #die "$function\n" if ($function=~/sul/);	
    } else {
	   ($use_taxa)=$line=~/^ +(.+)$/;
	   foreach $ASV (sort keys %{$hash{$use_taxa}}){
			   #print "|$use_taxa| |$hash{$ASV}|\n";
			   $printhash{$ASV}{$function}++;
	   }
   }
}
close (IN);
print "ASV\tFunctions\n";
foreach $ASV (sort keys %printhash){
	print "$ASV\t";
	$first=1;
	foreach $function (sort keys %{$printhash{$ASV}}){
		if ($first){
			print "$function";
			$first=0;
		} else {
			print ",$function";
		}
	}
	print "\n";
}



