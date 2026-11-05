#!/usr/bin/env perl
# Pac-Man normally fades eaten cells to the empty color. Instead, recolor each
# eaten cell to a blue of the same contribution level.
use strict;
use warnings;

my %map = (
    # github-dark: green level => blue level
    '#0e4429' => '#0c2d6b',
    '#006d32' => '#1158c7',
    '#26a641' => '#388bfd',
    '#39d353' => '#79c0ff',
    # github (light)
    '#9be9a8' => '#b6e3ff',
    '#40c463' => '#54aeff',
    '#30a14e' => '#0969da',
    '#216e39' => '#0a3069',
);
my $empty = qr/#161b22|#ebedf0/i;

local $/;
for my $file (@ARGV) {
    open my $in, '<', $file or die "$file: $!";
    my $svg = <$in>;
    close $in;

    my $count = $svg =~ s{values="(#[0-9a-fA-F]{6})((?:;(?:$empty))+)"}{
        my ($from, $rest) = (lc $1, $2);
        my $to = $map{$from} // $from;
        $rest =~ s/$empty/$to/g;
        qq{values="$from$rest"};
    }ge;

    open my $out, '>', $file or die "$file: $!";
    print $out $svg;
    close $out;
    print "$file: recolored $count cells\n";
}
