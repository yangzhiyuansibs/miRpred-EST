#!/usr/bin/perl

use strict;
use warnings;

if ( $#ARGV<0 )  {   die "\n Please input 1 parameters as following:\nperl vector_miRNA_annotation.pl *.anno.bow";    }

unless (-e $ARGV[0] ) { die "\nThe file $ARGV[0] is not existent! \n";  }

my $INPUT=$ARGV[0];

my %seq;

open (BAT,">tmp/batch_RNA_fold.sh") or die "cannot open batch_RNA_fold.sh";

open (IN,"<$INPUT") or die "cannot open $INPUT";
while (my $line=<IN>) {
   chomp($line);
   my @data=split/\t/,$line;
   $seq{$data[0]}=$data[-1];  
   open (TEMP,">tmp/$data[0].seq.txt") or die "cannot open $data[0].seq.txt";
   print TEMP "$data[-1]\n";
   close TEMP;
   
   print BAT "RNAfold -p -d 2 --infile=$data[0].seq.txt --outfile=$data[0].rna.fold\n";
   
}
close IN;

close BAT;

