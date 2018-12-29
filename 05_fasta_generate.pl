#!/usr/bin/perl

use strict;
use warnings;


if ( $#ARGV<0 )  {   die "\n Please input 1 parameters as following:\nperl 05_fasta_generate.pl name.txt column1 column2\n\nnote:The column number is starting with 1";    }

unless (-e $ARGV[0] ) { die "\nThe file $ARGV[0] is not existent! \n";  }

my $INPUT=$ARGV[0];
my $num1=$ARGV[1]-1;
my $num2=$ARGV[2]-1;
my %flag;

open (OUT,">$INPUT.fasta") or die "cannot open $INPUT.fasta";

open (IN,"<$INPUT") or die "cannot open $INPUT";
while (my $line=<IN>) {
   chomp($line);
   my @data=split/\t/,$line;
   $flag{$data[$num1]}=$data[$num2]; 
}
close IN;

my @uniq_names=sort keys %flag;
foreach my $name(@uniq_names) {
   print OUT ">$name\n$flag{$name}\n";
}


close OUT;


