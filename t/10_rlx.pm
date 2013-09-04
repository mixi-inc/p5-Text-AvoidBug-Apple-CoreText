use strict;
use warnings;

use utf8;

use Test::More;

use t::lib::Util;

use_ok $_ for qw(
    Text::AvoidBug::Apple::CoreText
);

subtest simple => sub {
    is_filterd("&rlm;");
    is_filterd("&rle;");
    is_filterd("&rlo;");
    is_filterd("\x{200f}");
    is_filterd("\x{202b}");
    is_filterd("\x{202e}");

    no_filterd("&rlm;", 1);
    no_filterd("&rle;", 1);
    no_filterd("&rlo;", 1);
};

done_testing;
