use strict;
use warnings;
use Test::More;

use Type::Simple::Types::Primitives qw(
    Int
    Any
    Undef
);

isa_ok Int, 'Type::Simple::Constraint::Primitive';
is Int->name, 'Int';
is Int->get_message('foo'), '"foo" did not pass type "Int"';
is Int->get_message(1), '', 'no error message';

done_testing;
