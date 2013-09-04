use strict;
use warnings;

use utf8;

use Test::More;

use t::lib::Util;

use_ok $_ for qw(
    Text::AvoidBug::Apple::CoreText
);

subtest with_all_right_to_left_char => sub {
    test_range([0x600 .. 0x6ff], 'Arabic');
    test_range([0x750 .. 0x77f], 'Arabic Supplement');
    test_range([0x8a0 .. 0x8ff], 'Arabic Extended-A');
    test_range([0xfb50 .. 0xfdff], 'Arabic Presentation Forms-A');
    test_range([0xfe70 .. 0xfeff], 'Arabic Presentation Forms-B');
    test_range([0x10e60 .. 0x10e7f], 'Rumi Numeral Symbols');
    test_range([0x1ee00 .. 0x1eeff], 'Arabic Mathematical Alphabetic Symbols');
    test_range([0x590 ..0x05FF], 'Hebrew');
    test_range([0xfb1d .. 0xfb4f], 'Hebrew : Alphabetic Presentation Forms');
    test_range([0x700 .. 0x74f], 'Syriac');
    test_range([0x200f, 0x202b, 0x202e], 'rlm rle rlo');
};

sub test_range {
    my($range, $message) = @_;

    foreach my $code (@$range){
        my $str = "&#$code";
        my $filterd = Text::AvoidBug::Apple::CoreText::filter($str);
        my $expected = $str . "\x{200e}";

        if($filterd ne $expected){
            my $code_in_hex = sprintf("%x", $code);
            is($filterd, $expected, "$message [$code_in_hex]");
        }
    }
    ok(1);
};

done_testing;
