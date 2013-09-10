# NAME

Text::AvoidBug::Apple::CoreText - Add 'left to right marker' to avoid apple CoreText bug.

# SYNOPSIS

    use Text::AvoidBug::Apple::CoreText;

my $filtered = Text::AvoidBug::Apple::CoreText::filter($src);

# DESCRIPTION

Text::AvoidBug::Apple::CoreText is filter that add 'left to right maker' to avoid apple CoreText bug.

Apple CoreText has bug.
There is a bug related to right-to-left text processing.
There are too many patterns that trigger the bug, and addressing them individually might leave some patterns out, so instead I have chosen to insert a "left-to-right mark" right after any right-to-left character.
Doing so might affect Arabic text and make it display improperly, sorry about that!
{Arabic A}{Arabic B}{Arabic C}-=! should usually be displayed as {Arabic C}{Arabic B}{Arabic A}!=-, but will instead result in {Arabic C}{Arabic B}{Arabic A}-=!.

# LICENSE

Copyright (C) Shigeki Morimoto.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Shigeki Morimoto <shigeki.morimoto@mixi.co.jp>

# NAME

Text::AvoidBug::Apple::CoreText - Add 'left to right marker' to avoid apple CoreText bug.

# SYNOPSIS

    use Text::AvoidBug::Apple::CoreText;

my $filtered = Text::AvoidBug::Apple::CoreText::filter($src);

# DESCRIPTION

Text::AvoidBug::Apple::CoreText is filter that add 'left to right maker' to avoid apple CoreText bug.

Apple CoreText has bug.
There is a bug related to right-to-left text processing.
There are too many patterns that trigger the bug, and addressing them individually might leave some patterns out, so instead I have chosen to insert a "left-to-right mark" right after any right-to-left character.
Doing so might affect Arabic text and make it display improperly, sorry about that!
{Arabic A}{Arabic B}{Arabic C}-=! should usually be displayed as {Arabic C}{Arabic B}{Arabic A}!=-, but will instead result in {Arabic C}{Arabic B}{Arabic A}-=!.

# LICENSE

Copyright (C) Shigeki Morimoto.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Shigeki Morimoto <shigeki.morimoto@mixi.co.jp>
