#!/usr/bin/perl

use strict;
use warnings;


if ( $#ARGV<0 )  {   die "\n Please input 1 parameters as following:\nperl 04_identify_miRNA.pl RNAfold_arm.txt";    }

unless (-e $ARGV[0] ) { die "\nThe file $ARGV[0] is not existent! \n";  }

my $INPUT=$ARGV[0];
my $ins_mir="\t";

open (OUT,">Identified_miRNA_redundant.txt") or die "cannot open Identified_miRNA_redundant.txt";

open (INS,"<insect_tab.txt") or die "cannot open insect_tab.txt";
while (my $line=<INS>) {
   chomp($line);
   my @data=split/\t/,$line;
   $ins_mir="$ins_mir\t$data[0]\t"; 
}
close INS;


open (IN,"<$INPUT") or die "cannot open $INPUT";
while (my $line=<IN>) {
   chomp($line);
   my @data=split/\t/,$line;
   my @parts=split/-/,$data[0];
   my $abb=$parts[0];
   
   my $flag=$data[19]*$data[20];
   my $percent=int(($data[19]+$data[20])/$data[3]*1000)/10;
   if ( ($ins_mir=~/\W$abb\W/) and $data[17]<=-25 and $data[18]<=0.01 and $flag==0 and $data[21]<=5 ) {
       print OUT "$line\t$percent\n";
    }
   
}
close IN;

close OUT;


