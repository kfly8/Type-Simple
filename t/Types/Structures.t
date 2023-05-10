use strict;
use warnings;
use Test::More;

use Type::Simple::Types::Structures qw(
    ArrayRef
    HashRef
);

isa_ok ArrayRef, 'Type::Simple::Constraint::Structure::ArrayRef';
isa_ok HashRef, 'Type::Simple::Constraint::Structure::HashRef';

done_testing;
