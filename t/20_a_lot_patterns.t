use strict;
use warnings;

use utf8;

use Test::More;

use t::lib::Util;

use_ok $_ for qw(
    Text::AvoidBug::Apple::CoreText
);

foreach my $spacer (' ', "\t", "\x{a0}", "\x{1680}", "\x{180e}",
                    "\x{2000}", "\x{2005}", "\x{200a}",
                    "\x{202f}", "\x{205f}", "\x{3000}",
                ){
    foreach my $combining ("\x{300}", "\x{301}", "\x{36f}",
                           "\x{483}", "\x{485}", "\x{487}",
                           "\x{135f}",
                           "\x{1dc0}", "\x{1dff}",
                           "\x{20d0}", "\x{20ff}",
                           "\x{2de0}", "\x{2dff}",
                           "\x{302a}", "\x{302d}",
                           "\x{3099}", "\x{309a}",
                           "\x{a67c}", "\x{a67d}",
                           "\x{fe20}", "\x{fe2f}",
                       ){
        is_filterd("$spacer$combining");
    }
};

foreach my $spacer (0x20, 0x09, 0xa0, 0x1680, 0x180e,
                    0x2000, 0x2005, 0x200a,
                    0x202f, 0x205f, 0x3000,
                ){
    foreach my $combining (0x300, 0x301, 0x36f,
                           0x483, 0x485, 0x487,
                           0x135f,
                           0x1dc0, 0x1dff,
                           0x20d0, 0x20ff,
                           0x2de0, 0x2dff,
                           0x302a, 0x302d,
                           0x3099, 0x309a,
                           0xa67c, 0xa67d,
                           0xfe20, 0xfe2f,
                       ){
        is_filterd([ sprintf("&#%d;", $spacer), sprintf("&#%d;", $combining) ]);
        is_filterd([ sprintf("&#000%d;", $spacer), sprintf("&#000%d;", $combining) ]);
        is_filterd([ sprintf("&#x%x;", $spacer), sprintf("&#x%x;", $combining) ]);
        is_filterd([ sprintf("&#x000%x;", $spacer), sprintf("&#x00000000000000000000000%x;", $combining) ]);
    }
};

done_testing;
