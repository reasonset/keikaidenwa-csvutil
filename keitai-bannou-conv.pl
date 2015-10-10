#!/usr/bin/perl

open(STDIN, "<:cp932");

open(SJNKF, "| nkf -S -w -Lu > $$.out.pre");

print STDERR "Progress";

my $index=1;

while (<>) {
  print STDERR ".";
  /("(?:.*?","){4})(.*)"/ or continue;
  my $ppre = $1;
  my $ppost = $2;
  chop($ppre);
  #print "$index" . "\n";
  #print "$ppre" . "\n";
  print SJNKF ($ppre . "\n");
  if (length($ppost) != 0 ) {
    open(MNKF, "| nkf -w -Lu >> $$.out.post");
    #print $index++ . "\n";
    print MNKF ($ppost . "\n");
    close(MNKF);
  } else {
    open(FH, ">>", "$$.out.post");
    print FH "\r\n";
    close(FH)
  }
}

close(SJNKF);

print STDERR "\n";

open(FPRE, "<", "$$.out.pre");
open(FPOST, "<", "$$.out.post");
open(OFILE, ">", "keitaibannou-out.csv");

while (<FPRE>) {
  chomp($_);
  my $spost = <FPOST>;
  chomp($spost);
  
  print OFILE $_ . "\"${spost}\"\r\n";
}

close OFILE;
close FPRE;
close FPOST;

unlink("$$.out.pre") or print STDERR "Can't remove temporary file.\n";
unlink("$$.out.post") or print STDERR "Can't remove temporary file.\n";
