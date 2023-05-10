use strict;
use warnings;

use Test::More;

use Type::Simple::Constraint::Operator::Union;

my $Foo = Type::Simple::Constraint->new(
    name => 'Foo',
    constraint => sub { $_ eq 'foo' },
);

my $Bar = Type::Simple::Constraint->new(
    name => 'Bar',
    constraint => sub { $_ eq 'bar' },
);

subtest 'display_name' => sub {
    my $Type = Type::Simple::Constraint::Operator::Union->new(
        operands => [$Foo, $Bar]
    );

    is $Type->display_name, 'Foo | Bar';

    my $Type2 = Type::Simple::Constraint::Operator::Union->new(
        operands => [$Foo, $Bar, $Foo],
    );

    is $Type2->display_name, 'Foo | Bar';
};

subtest 'check' => sub {
    my $Type = Type::Simple::Constraint::Operator::Union->new(
        operands => [$Foo, $Bar]
    );

    ok $Type->check('foo'), 'foo is valid';
    ok $Type->check('bar'), 'bar is valid';
    ok !$Type->check('baz'), 'baz is invalid';
};

done_testing;
