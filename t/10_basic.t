use strict;
use warnings;

use utf8;

use Test::More;

use t::lib::Util;

use_ok $_ for qw(
    Text::AvoidBug::Apple::CoreText
);


subtest ascii => sub {
    no_filterd("abc");
    no_filterd("foo bar baz &lt; <>");
};

subtest 'normal utf8' => sub {
    no_filterd("あいうえお");
    no_filterd("漢字");
};

subtest 'must be filtered' => sub {
    is_filterd(" \x{300}");

    is_filterd(["&#x20;&#x20", "\x{300}"]);
};

done_testing;
