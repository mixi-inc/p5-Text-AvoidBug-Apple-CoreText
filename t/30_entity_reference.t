use strict;
use warnings;

use utf8;

use Test::More;

use t::lib::Util;

use_ok $_ for qw(
    Text::AvoidBug::Apple::CoreText
);

subtest 'normals entity reference' => sub {
    no_filterd("&#x41;\x{300}");
    no_filterd(" &#x41;");
    no_filterd("&#x41;&#x41;");
};

subtest 'spacer is entity reference' => sub {
    is_filterd(["&#x20;", "\x{300}"]);
    is_filterd(["&#x20",  "\x{300}"]);
    no_filterd("&#x20\x{300}", 1);

    is_filterd(["&#32;", "\x{300}"]);
    is_filterd(["&#32",  "\x{300}"]);
    no_filterd("&#32\x{300}", 1);

    is_filterd(["&nbsp;", "\x{300}"]);
    is_filterd(["&nbsp",  "\x{300}"]);
    no_filterd("&nbsp\x{300}", 1);
};

subtest 'combining is entity reference' => sub {
    is_filterd([" ", "&#x300;"]);
    is_filterd([" ", "&#x300"]);
    no_filterd(" &#x300", 1);

    is_filterd([" ", "&#768;"]);
    is_filterd([" ", "&#768"]);
    no_filterd(" &#768", 1);
};

subtest 'spacer and combining are entity reference' => sub {
    is_filterd(["&#x20;", "&#x300;"]);
    no_filterd("&#x20;&#x300;", 1);
};

done_testing;
