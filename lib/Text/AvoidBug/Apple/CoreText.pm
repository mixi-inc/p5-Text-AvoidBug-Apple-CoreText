package Text::AvoidBug::Apple::CoreText;

use 5.008005;
use strict;
use warnings;

use utf8;

our $VERSION = "0.03";

our $IN_BUG_SPACER;
our $IN_BUG_COMBINING;

_init();

sub _init {
    my @BUG_SPACER = (
        0x9,
        0x20,
        0xa0,
        0x1680,
        0x180e,
        [ 0x2000, 0x200a ],
        0x202f,
        0x205f,
        0x3000,
    );
    my @BUG_COMBINING = (
        [ 0x300, 0x36f ],
        [ 0x483, 0x487 ],
        0x135f,
        [ 0x1dc0, 0x1dff ],
        [ 0x20d0, 0x20ff ],
        [ 0x2de0, 0x2dff ],
        [ 0x302a, 0x302d ],
        [ 0x3099, 0x309a ],
        [ 0xa67c, 0xa67d ],
        [ 0xfe20, 0xfe2f ],
    );

    _code_list_to_code_map(\@BUG_SPACER,    \$IN_BUG_SPACER);
    _code_list_to_code_map(\@BUG_COMBINING, \$IN_BUG_COMBINING);
}

sub _code_list_to_code_map {
    my($code_list, $in_xxx) = @_;

    my @range;
    foreach my $code (@$code_list){
        if(ref($code)){
            push(@range, sprintf("%x\t%x\n", $code->[0], $code->[1]));
        }else{
            push(@range, sprintf("%x\n", $code));
        }
    }
    $$in_xxx = join('', @range);
}

sub InBugSpacer{
    $IN_BUG_SPACER;
}

sub InBugCombining{
    $IN_BUG_COMBINING;
}

## NOTE
# those regexp are genereated with Regexp::Assemble
#
# like this
#
# my $ra = Regexp::Assemble->new;
# foreach my $code (@BUG_SPACER){ # or @BUG_COMBINING
#     if (ref($code)) {
#         foreach my $subcode ($code->[0] .. $code->[1]) {
#             $ra->add(sprintf('&#x0*%x;?', $subcode));
#             $ra->add(sprintf('&#0*%d;?', $subcode));
#         }
#     } else {
#         $ra->add(sprintf('&#x0*%x;?', $code));
#         $ra->add(sprintf('&#0*%d;?', $code));
#     }
# }
# $ra->re;
our $SPACER_RE = '(?^:&#(?:0*(?:8(?:2(?:0[012]|39|87)|19[23456789])|1(?:2288|60)|5760|6158|32|9)|x0*(?:20(?:0[\da]|[25]f)?|1(?:680|80e)|(?:300|a)0|9));?)';
our $COMBINING_RE = '(?^:&#(?:0*(?:1(?:1(?:7(?:4[456789]|7[012345]|[56]\d)|5[56789])|2(?:33[0123]|44[12]))|8(?:4(?:[56789]|4[01234567]?|[0123]\d?)|[0123567]\d)|7(?:6(?:[89]|[234567]\d|1[6789])|[789]\d)|650(?:5[6789]|7[01]|6\d)|4(?:262[01]|959))|x0*(?:3(?:0(?:[01345678abcdef]|2[abcd]?|9[9a]?)|[123456][\dabcdef])|(?:2(?:0[def]|d[ef])|fe2)[\dabcdef]|1(?:d[cdef][\dabcdef]|35f)|48[34567]|a67[cd]));?)';

sub filter {
    my $str = shift; # must be utf8 string
    my $dont_convert_entity_reference = shift;

    $str =~ s/((\p{InBugSpacer}|&(?:nbsp);?|$SPACER_RE)(\p{InBugCombining}|$COMBINING_RE))/_add_lrm($dont_convert_entity_reference, $1, $2, $3)/xiego;
    $str;
}

sub _add_lrm {
    my($dont_convert_entity_reference, $original, $spacer, $combining) = @_;

    return $original if($dont_convert_entity_reference && $spacer =~ /^&/);
    return $original if($dont_convert_entity_reference && $combining =~ /^&/);

    $spacer . "\x{200e}" . $combining;
}


1;
__END__

=encoding utf-8

=head1 NAME

Text::AvoidBug::Apple::CoreText - Add 'left to right marker' to avoid apple CoreText bug.

=head1 SYNOPSIS

    use Text::AvoidBug::Apple::CoreText;

my $filtered = Text::AvoidBug::Apple::CoreText::filter($src);

=head1 DESCRIPTION

Text::AvoidBug::Apple::CoreText is filter that add 'left to right maker' to avoid apple CoreText bug.

Apple CoreText has bug.
There is a bug related to right-to-left text processing.
There are too many patterns that trigger the bug, and addressing them individually might leave some patterns out, so instead I have chosen to insert a "left-to-right mark" right after any right-to-left character.
Doing so might affect Arabic text and make it display improperly, sorry about that!
{Arabic A}{Arabic B}{Arabic C}-=! should usually be displayed as {Arabic C}{Arabic B}{Arabic A}!=-, but will instead result in {Arabic C}{Arabic B}{Arabic A}-=!.

=head1 LICENSE

Copyright (C) Shigeki Morimoto.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Shigeki Morimoto E<lt>shigeki.morimoto@mixi.co.jpE<gt>

=cut
