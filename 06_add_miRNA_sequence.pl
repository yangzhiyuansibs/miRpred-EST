#!/usr/bin/perl

use strict;
use warnings;


if ( $#ARGV<0 )  {   die "\n Please input 1 parameters as following:\nperl 05_fasta_generate.pl name.txt\n\nnote:The column number is starting with 1";    }

unless (-e $ARGV[0] ) { die "\nThe file $ARGV[0] is not existent! \n";  }

my $INPUT=$ARGV[0];


open (OUT,">$INPUT.add.miRNA") or die "cannot open $INPUT.add.miRNA";

open (IN,"<$INPUT") or die "cannot open $INPUT";
while (my $line=<IN>) {
   chomp($line);
   my @data=split/\t/,$line;
   my $mirseq="";
   
   if ($data[8]<$data[9])  {
       $mirseq=substr($data[15],$data[14],$data[3]);
   }
   if ($data[8]>$data[9])  {
       my $mir_inv=substr($data[15],$data[14],$data[3]);
       my $nn=length($mir_inv)-1;
       my $i;
       for ( $i=$nn;$i>=0; $i=$i-1 )  {
           $mirseq=$mirseq.substr($mir_inv,$i,1);
      }      
   }   
     
   print OUT "$line\t$mirseq\n";
}
close IN;


close OUT;


