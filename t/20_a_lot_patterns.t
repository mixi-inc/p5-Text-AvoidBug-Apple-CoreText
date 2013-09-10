use strict;
use warnings;

use utf8;

use Test::More;

use t::lib::Util;

use_ok $_ for qw(
    Text::AvoidBug::Apple::CoreText
);

foreach my $spacer (' ', "\t"){
    foreach my $combining ("\x{300}", "\x{301}"){
        is_filterd("$spacer$combining");
    }
};

done_testing;
