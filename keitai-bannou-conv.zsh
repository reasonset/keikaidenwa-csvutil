#!/usr/bin/zsh

head -n1 "$1" | nkf -w -Lu >| out.csv

tail -n+2 "$1" | perl -n -e 'if ($_ =~ /"(?:[^"]*|"")*"\s*$/) { print STDOUT $&; print STDERR $`; print STDERR "\n" }' >| out.l 2>| out.f
nkf -w -Lu out.l > out.lu
nkf -w -Lu out.f > out.fu

ruby -e 'File.foreach(ARGV[0]).zip(File.foreach(ARGV[1])) {|i,j| puts(i.chomp + "," + j) }' out.fu out.lu | sort -u >> out.csv
rm out.[lf] out.[lf]u