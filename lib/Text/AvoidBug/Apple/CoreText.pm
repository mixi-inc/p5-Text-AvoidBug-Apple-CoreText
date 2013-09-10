package Text::AvoidBug::Apple::CoreText;

use 5.008005;
use strict;
use warnings;

use utf8;

our $VERSION = "0.02";

our $IN_BUG_SPACER;
our $IN_BUG_COMBINING;
our %BUG_SPACER_MAP;
our %BUG_COMBINING_MAP;

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

    _code_list_to_code_map(\@BUG_SPACER,    \$IN_BUG_SPACER,    \%BUG_SPACER_MAP);
    _code_list_to_code_map(\@BUG_COMBINING, \$IN_BUG_COMBINING, \%BUG_COMBINING_MAP);
}

sub _code_list_to_code_map {
    my($code_list, $in_xxx, $code_map) = @_;

    my @range;
    foreach my $code (@$code_list){
        if(ref($code)){
            push(@range, sprintf("%x\t%x\n", $code->[0], $code->[1]));
            foreach my $sub_code ($code->[0] .. $code->[1]){
                $code_map->{$sub_code} = 1;
            }
        }else{
            push(@range, sprintf("%x\n", $code));
            $code_map->{$code} = 1;
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

sub filter {
    my $str = shift; # must be utf8 string
    my $dont_convert_entity_reference = shift;

    $str =~ s/(
                  (
                      \p{InBugSpacer}
                  |
                      &(?:nbsp);?
                  |
                      &\#(x[0-9a-f]+|[0-9]+);?
                  )(
                      \p{InBugCombining}
                  |
                      &\#(x[0-9a-f]+|[0-9]+);?
              )
          )/_add_lrm($dont_convert_entity_reference, $1, $2, $3, $4, $5)/xieg;
    $str;
}

sub _add_lrm {
    my($dont_convert_entity_reference, $original, $spacer, $spacer_code, $combining, $combining_code) = @_;

    return $original if($dont_convert_entity_reference && $spacer =~ /^&/);
    return $original if($dont_convert_entity_reference && $combining =~ /^&/);

    if($spacer =~ /^&#/){
        $spacer_code = hex($1) if($spacer_code =~ /^x(.*)/i);
        $spacer_code += 0;
        if($BUG_SPACER_MAP{$spacer_code}){
            # fall through
        }else{
            return $original;
        }
    }
    if($combining =~ /^&#/){
        $combining_code = hex($1) if($combining_code =~ /^x(.*)/i);
        $combining_code += 0;
        if($BUG_COMBINING_MAP{$combining_code}){
            # fall through
        }else{
            return $original;
        }
    }

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
