#!/usr/bin/perl
use utf8;
my $file = $ARGV[0];
#open INPUT, $file or die "Cannot open file ".$file.".";
open INPUT, '<:encoding(UTF-8)', $file or die;
binmode(INPUT, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
@lines = <INPUT>;
foreach $line (@lines) {
    next if ($line =~ /^[A-Z]\n$/);
        if ($line =~ m/^([a-z()\s^']+)\n$/) 
        {
            print "\n";
            print $1;
            print "    "
        } else {
            if($line =~ m/[a-zA-Z()^']+$/) {
                $line =~ s/\n$/ /;
            } else {
                $line =~ s/\n$//;
            };
            print $line;
        };
}
close(INPUT);
