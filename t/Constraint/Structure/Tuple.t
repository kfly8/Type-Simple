use strict;
use warnings;

use Test::More;

use Type::Simple::Constraint::Structure::Tuple;

subtest 'When the parameters is empty' => sub {
    my $Type = Type::Simple::Constraint::Structure::Tuple->new(
        parameters => []
    );

    ok $Type->check([]), 'empty arrayref is valid';

    ok !$Type->check([123]), 'arrayref with one element is invalid';
    ok !$Type->check('foo'), 'string is invalid';
};

subtest 'When a type constraint is given for the parameters' => sub {
    my $Foo = Type::Simple::Constraint->new(
        name => 'Foo',
        constraint => sub { $_ eq 'foo' },
    );

    my $Type = Type::Simple::Constraint::Structure::Tuple->new(
        parameters => [$Foo],
    );

    ok $Type->check(['foo']), 'arrayref with one "foo" is valid';

    ok !$Type->check([]), 'empty arrayref is invalid';
    ok !$Type->check(['foo', 'foo']), 'arrayref with two "foo" is invalid';
    ok !$Type->check(['bar']), 'arrayref with one "bar" is invalid';
    ok !$Type->check(['foo', 'bar']), 'arrayref with "foo" and "bar" is invalid';
};

done_testing;
