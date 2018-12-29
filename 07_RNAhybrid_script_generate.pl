#!/usr/bin/perl
# The script is for annotate Vector miRNA

use strict;
use warnings;

if ( $#ARGV<2 )  {   die "\n Please input 3 parameters as following:\nperl 07_RNAhybrid_script_generate.pl miRNA.fasta 3-primer-UTR.fasta script.sh \n\n ";    }

unless (-e $ARGV[0] ) { die "\nThe file $ARGV[0] is not existent! \n";  }
unless (-e $ARGV[1] ) { die "\nThe file $ARGV[1] is not existent! \n";  }

my $MIRFILE=$ARGV[0];
my $UTRFILE=$ARGV[1];
my $OUTPUT=$ARGV[2]; 
my @mirnames;
my @utrnames;       


open (SH,">$OUTPUT") or die "cannot open $OUTPUT";

{
local $/="\n>";

open (MIR,"<$MIRFILE") or die "cannot open $MIRFILE";
while (my $content=<MIR>) {
    chomp($content);
    $content=~s/>//g;
    my $loc=index($content,"\n",0);
    my $firstline=substr($content,0,$loc);
    my @parts=split/\s+/,$firstline;
 
    my $sequence=substr($content,$loc+1);
       $sequence=~s/\W+//g;
       $sequence=uc($sequence);
   
    open (TEMP,">separate/$parts[0].fasta") or die "cannot open $parts[0].fasta";
        print TEMP ">$parts[0]\n$sequence\n"; 
    close TEMP; 
    push @mirnames,$parts[0];
}
close MIR;

open (UTR,"<$UTRFILE") or die "cannot open $UTRFILE";
while (my $content=<UTR>) {
    chomp($content);
    $content=~s/>//g;
    my $loc=index($content,"\n",0);
    my $firstline=substr($content,0,$loc);
    my @parts=split/\s+/,$firstline;
 
    my $sequence=substr($content,$loc+1);
       $sequence=~s/\W+//g;
       $sequence=uc($sequence);
   
    open (TEMP2,">separate/$parts[0].fasta") or die "cannot open $parts[0].fasta";
        print TEMP2 ">$parts[0]\n$sequence\n"; 
    close TEMP2; 
    push @utrnames,$parts[0];
}
close UTR;

}

foreach my $mirname(@mirnames) {
    foreach my $utrname(@utrnames) {
         print SH "RNAhybrid.exe -s 3utr_fly -q $mirname.fasta -t $utrname.fasta  > intermediate.file \n"; 
         print SH "perl 08_extract_hybrid_result.pl intermediate.file \n\n";
    }
}


close SH;


