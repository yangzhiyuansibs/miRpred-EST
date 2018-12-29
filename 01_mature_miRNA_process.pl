#!/usr/bin/perl

use strict;
use warnings;

my %spe2abb;

if ( $#ARGV<1 )  {   die "\n Please input 2 parameters as following:\nperl vector_miRNA_annotation.pl miRNA_original.fa out_filename.fasta \n ";    }

unless (-e $ARGV[0] ) { die "\nThe file $ARGV[0] is not existent! \n";  }

my $INPUT=$ARGV[0];
my $OUTPUT=$ARGV[1];

open (OUT,">$OUTPUT");
open (ABB,">name_abbreviation.txt") or die "cannot open name_abbreviation.txt";

{
local $/="\n>";
open (IN, "<$INPUT") or die "cannot open mature.fa file";
while (my $content=<IN>) {
   $content=~s/>//g;
   my $loc=index($content,"\n",0);
   my $firstline=substr($content,0,$loc);
   my @parts=split/\s+/,$firstline;
   my $name=$parts[0];
   my @aparts=split/-/,$parts[0];
   my $speciesname="$parts[2] $parts[3]";
      $spe2abb{$speciesname}=$aparts[0];
   
   my $sequence=substr($content,$loc+1);
   $sequence=~s/\W//g;
   $sequence=~s/U/T/g;
       print OUT ">$name\n$sequence\n";
   }
}
close IN;

my @names=sort keys %spe2abb;
foreach my $name(@names) {
   print ABB "$name\t$spe2abb{$name}\n";
}

close ABB;
close OUT;
