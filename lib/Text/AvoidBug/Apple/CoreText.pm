package Text::AvoidBug::Apple::CoreText;

use 5.008005;
use strict;
use warnings;

use utf8;

our $VERSION = "0.01";


sub filter {
    my $str = shift; # must be utf8 string
    my $dont_convert_entity_reference = shift;

    $str =~ s/([\x{600}-\x{6ff}\x{750}-\x{77f}\x{8a0}-\x{8ff}\x{fb50}-\x{fdff}\x{fe70}-\x{feff}\x{10e60}-\x{10e7f}\x{1ee00}-\x{1eeff}\x{590}-\x{05FF}\x{FB1D}-\x{FB4F}\x{700}-\x{74f}\x{200f}\x{202b}\x{202e}]
                  |
                      &(?:rlm|rle|rlo);?
                  |
                      &\#(x[0-9a-f]+|[0-9]+);?
                  )/_add_lrm($dont_convert_entity_reference,$1,$2)/xieg;
    $str;
}

sub _add_lrm {
    my($dont_convert_entity_reference, $original, $code) = @_;

    return $original if($dont_convert_entity_reference && $original =~ /^&/);

    if($original =~ /^&#/){
        $code = hex($1) if($code =~ /^x(.*)/i);
        $code += 0;

        # http://en.wikipedia.org/wiki/Arabic_script_in_Unicode
        # http://en.wikipedia.org/wiki/Unicode_and_HTML_for_the_Hebrew_alphabet
        # http://www.fileformat.info/info/unicode/block/syriac/index.htm
        if ((0x600 <= $code && $code <= 0x6ff) # Arabic
                ||
            (0x750 <= $code && $code <= 0x77f) # Arabic Supplement
                ||
            (0x8a0 <= $code && $code <= 0x8ff) # Arabic Extended-A
                ||
            (0xfb50 <= $code && $code <= 0xfdff) # Arabic Presentation Forms-A
                ||
            (0xfe70 <= $code && $code <= 0xfeff) # Arabic Presentation Forms-B
                ||
            (0x10e60 <= $code && $code <= 0x10e7f) # Rumi Numeral Symbols
                ||
            (0x1ee00 <= $code && $code <= 0x1eeff) # Arabic Mathematical Alphabetic Symbols
                ||
            (0x590 <= $code && $code <= 0x05FF) # Hebrew
                ||
            (0xFB1D <= $code && $code <= 0xFB4F) # Hebrew : Alphabetic Presentation Forms
                ||
            (0x700 <= $code && $code <= 0x74f) # Syriac
                ||
            ($code == 0x200f || $code == 0x202b || $code == 0x202e) # rlm rle rlo
        ) {
            # fall through
        }else{
            return $original;
        }
    }
    $original . "\x{200e}";
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

