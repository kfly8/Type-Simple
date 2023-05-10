use strict;
use warnings;

use Test::More;

use Type::Simple::Constraint::Structure::Dict;

subtest 'When the parameters is empty' => sub {
    my $Type = Type::Simple::Constraint::Structure::Dict->new(
        parameters => []
    );

    ok $Type->check({}), 'empty hashref is valid';

    ok !$Type->check({ key => 'foo' }), 'hashref with one element is invalid';
    ok !$Type->check('foo'), 'string is invalid';
};

subtest 'When type constraints is given for the parameters' => sub {
    my $Foo = Type::Simple::Constraint->new(
        name => 'Foo',
        constraint => sub { defined $_ && $_ eq 'foo' },
    );

    my $Bar = Type::Simple::Constraint->new(
        name => 'Bar',
        constraint => sub { defined $_ && $_ eq 'bar' },
    );

    my $Type = Type::Simple::Constraint::Structure::Dict->new(
        parameters => [ 'k1' => $Foo, 'k2?' => $Bar ]
    );

    ok $Type->check({ k1 => 'foo', k2 => 'bar' }), 'hashref with "foo", "bar" is valid';
    ok $Type->check({ k1 => 'foo' }), 'k2 is optional';

    ok !$Type->check({}), 'empty hashref is invalid';
    ok !$Type->check({ k1 => 'bar' }), 'invalid: k1 must be foo';
    ok !$Type->check({ k1 => 'foo', k2 => 'foo' }), 'invalid: k2 must be bar';
    ok !$Type->check({ k2 => 'bar' }), 'invalid: k1 must be exists';
    ok !$Type->check({ k1 => 'foo', k2 => 'bar', k3 => 'baz' }), 'extra k3 is invalid';
};

done_testing;
