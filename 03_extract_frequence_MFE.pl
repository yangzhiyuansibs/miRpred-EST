#!/usr/bin/perl

use strict;
use warnings;


if ( $#ARGV<0 )  {   die "\n Please input 1 parameters as following:\nperl 03_extract_frequence_MFE.pl *.anno.bow";    }

unless (-e $ARGV[0] ) { die "\nThe file $ARGV[0] is not existent! \n";  }

my $INPUT=$ARGV[0];

open (ARM,">RNAfold_arm.txt") or die "cannot open RNAfold_arm.txt";

open (IN,"<$INPUT") or die "cannot open $INPUT";
while (my $line=<IN>) {
   chomp($line);
   my @data=split/\t/,$line;
   my $len=$data[3];
   my $struc="";
   my $energy=0;
   my $frequency=0;
   my %num;
      $num{'('}=0;
      $num{')'}=0;
      $num{'.'}=0;
    
   my $foldcount=0;
   open (TEMP,"<tmp/$data[0].$data[1].rna.fold") or die "cannot open $data[0].$data[1].rna.fold";
   while (my $foldline=<TEMP>)  {
      $foldcount++;
      chomp($foldline);
      if ( $foldcount==2 )  {
          $struc=substr($foldline,$data[14],$len);
          my @chars=split//, $struc;
          foreach my $char(@chars) {
             $num{$char}++;
          }  
      } 
      if ( $foldline=~/free energy of ensemble =\s+(\S+)\skcal/ )  {
          $energy=$1; 
      } 
      if ( $foldline=~/mfe structure in ensemble\s(\S+);\s+ensemble diversity/ )  {
          $frequency=$1; 
      }
   }
   close TEMP;
   
   print ARM "$line\t$struc\t$energy\t$frequency\t".$num{'('}."\t".$num{')'}."\t".$num{'.'}."\n";
   
}
close IN;

close ARM;


