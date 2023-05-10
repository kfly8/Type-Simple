use strict;
use warnings;

use Test::More;

use Type::Simple::Constraint::Structure::Map;

subtest 'When type constraints is given for the parameters' => sub {
    my $Foo = Type::Simple::Constraint->new(
        name => 'Foo',
        constraint => sub { $_ =~ /^foo/ },
    );

    my $Num = Type::Simple::Constraint->new(
        name => 'Num',
        constraint => sub { $_ =~ /^\d+$/ },
    );

    my $Type = Type::Simple::Constraint::Structure::Map->new(
        parameters => [ $Foo, $Num ]
    );

    ok $Type->check({}), 'empty hashref is valid';
    ok $Type->check({ foo => 123 }), 'hashref with "foo", is valid';
    ok $Type->check({ foo1 => 123 }), 'hashref with "foo1", is valid';
    ok $Type->check({ foo1 => 123, foo2 => 456 }), 'hashref with "foo1", "foo2", is valid';

    ok !$Type->check({ bar => 123 }), 'invalid: key prefix is not "foo"';
    ok !$Type->check({ foo => 'hello' }), 'invalid: value is not Num';
};

done_testing;
