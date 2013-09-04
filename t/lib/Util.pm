package t::lib::Util;

use strict;
use warnings;

use Test::Builder;

use parent qw(Exporter);
our @EXPORT = qw(is_filterd no_filterd eq_filterd);

sub is_filterd {
    my($original, $dont_convert_entity_reference) = @_;

    eq_filterd($original, $original . "\x{200e}", $dont_convert_entity_reference);
}

sub no_filterd {
    my($original, $dont_convert_entity_reference) = @_;

    eq_filterd($original, $original, $dont_convert_entity_reference);
}

sub eq_filterd {
    my($original, $expected, $dont_convert_entity_reference) = @_;

    my $filterd = Text::AvoidBug::Apple::CoreText::filter($original, $dont_convert_entity_reference);
    Test::Builder->new->is_eq($filterd, $expected);
}

1;
