#! /usr/bin/perl -w
#   Edited on 04/02/12 
#

	die "feature_table ASV_list function> redirect output\n" unless (@ARGV); 

($featurefile, $MicrobIEMfile, $function)=@ARGV;
chomp ($featurefile, $MicrobIEMfile);

die "Please follow command line args\n" unless ($MicrobIEMfile);

open (IN, "<$MicrobIEMfile" ) or die "Can't open $MicrobIEMfile\n";
while ($line =<IN>){
    chomp ($line);
    next unless ($line);
    ($ASV, $csvfunct) =split ("\t", $line);
    (@functions)=split(",", $csvfunct);
    foreach $funct (@functions){
	    if ($funct eq $function){
    		$hash{$ASV}++;
	    }
    }
}
close (IN);

open (IN, "<$featurefile" ) or die "Can't open $featurefile\n";
while ($line =<IN>){
    chomp ($line);
    next unless ($line);
    ($OTU) =split ("\t", $line);
    #die "$OTU\n";
    if ($line=~/^\#/){
	    print "$line\n";
    }  elsif ($hash{$OTU}){
    	print "$line\n" if ($hash{$OTU});
    }
}
close (IN);

