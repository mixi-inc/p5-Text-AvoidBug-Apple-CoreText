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

subtest 'left to right' => sub {
    no_filterd("あいうえお");
    no_filterd("ａｂｃｄｅｆｇ");
};

subtest simple => sub {
    is_filterd("\x{600}");
    is_filterd("&#x600");
    is_filterd("&#x600;");
};

subtest 'simple no entity reference' => sub {
    is_filterd("\x{600}", 1);
    no_filterd("&#x600", 1);
    no_filterd("&#x600;", 1);
};

done_testing;
