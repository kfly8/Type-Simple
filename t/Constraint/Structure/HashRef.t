use strict;
use warnings;

use Test::More;

use Type::Simple::Constraint::Structure::HashRef;

subtest 'When the parameters is empty' => sub {
    my $Type = Type::Simple::Constraint::Structure::HashRef->new(
        parameters => []
    );

    ok $Type->check({}), 'empty hashref is valid';
    ok $Type->check({k1 => 123}), 'hashref with one element is valid';
    ok $Type->check({k1 => 123, k2 => 'hello' }), 'hashref with number and string is valid';

    ok !$Type->check('foo'), 'string is invalid';
};

subtest 'When a type constraint is given for the parameters' => sub {
    my $Foo = Type::Simple::Constraint->new(
        name => 'Foo',
        constraint => sub { $_ eq 'foo' },
    );

    my $Type = Type::Simple::Constraint::Structure::HashRef->new(
        parameters => [$Foo],
    );

    ok $Type->check({}), 'empty hashref is valid';
    ok $Type->check({k1 => 'foo'}), 'hashref with one "foo" is valid';
    ok $Type->check({k1 => 'foo', k2 => 'foo'}), 'hashref with two "foo" is valid';

    ok !$Type->check({k1 => 'bar'}), 'hashref with one "bar" is invalid';
    ok !$Type->check({k1 => 'foo', k2 => 'bar'}), 'hashref with "foo" and "bar" is invalid';
};

done_testing;
