use strict;
use warnings;
use Test::More;

use Type::Simple qw(
    ArrayRef
    Tuple
    HashRef
    Dict
    Map
    Int
    Any
    Undef
);

subtest 'get_message' => sub {
    my $A = Tuple[Int];
    my $B = ArrayRef[$A];
    my $Type = Tuple[Int, $B];

    is $Type->get_message(['12', [ [123], ['foo'] ]]),
       'Element [1][1][0]: "foo" did not pass type "Int" within type "Tuple[Int,ArrayRef[Tuple[Int]]]"';
};

done_testing;
