use strict;
use warnings;

use utf8;

use Test::More;

use t::lib::Util;

use_ok $_ for qw(
    Text::AvoidBug::Apple::CoreText
);

subtest simple => sub {
    eq_filterd("\x{600}", "\x{600}\x{200e}");
    eq_filterd(<<"END;",<<"END;");
\x{600}
\x{600}
\x{600}
END;
\x{600}\x{200e}
\x{600}\x{200e}
\x{600}\x{200e}
END;
    eq_filterd(<<"END;",<<"END;");
\x{600}\x{601}
\x{602}\x{603}
aaa\x{602}bbb\x{603}ccc
END;
\x{600}\x{200e}\x{601}\x{200e}
\x{602}\x{200e}\x{603}\x{200e}
aaa\x{602}\x{200e}bbb\x{603}\x{200e}ccc
END;

};

done_testing;
