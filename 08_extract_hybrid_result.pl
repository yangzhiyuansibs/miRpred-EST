#!/usr/bin/perl

use strict;
use warnings;

# check the input parameter
 if ( $#ARGV<0 )  {   die "\n Please input 1 parameter as following:\nperl extract_hybrid_result.pl input_file \n\nn"; }
 
my $INPUT=$ARGV[0];

open (OUT, ">>hybrid_energy_result.txt") or die "cannot open hybrid_energy_result.txt";
   my $mirname="";
   my $utrname="";
   my $mfe=0;
   my $pvalue=1;
   
open (IN, "<$INPUT") or die "cannot open $INPUT";
while ( my $line=<IN> ) {
   chomp($line);

   if ($line=~/miRNA : (gmr-.+)$/)  {   
      $mirname=$1;
   }
   if ($line=~/target: (\w+)$/)  {   
      $utrname=$1;
   }
   if ($line=~/mfe: (-\d+\S+) kcal/)  {   
      $mfe=$1;
   }
   if ($line=~/p-value: (0\S+)$/)  {   
      $pvalue=$1;
   }
   
}
close IN;

 if ($mfe<=-20 and $pvalue<=0.05) {
print OUT "$mirname\t$utrname\t$mfe\t$pvalue\n";
 }

close OUT;

