use strict;
use warnings;

use Test::More;

use Type::Simple::Constraint::Structure::ArrayRef;

subtest 'When the parameters is empty' => sub {
    my $Type = Type::Simple::Constraint::Structure::ArrayRef->new(
        parameters => []
    );

    ok $Type->check([]), 'empty arrayref is valid';
    ok $Type->check([123]), 'arrayref with one element is valid';
    ok $Type->check([123, "hello"]), 'arrayref with number and string is valid';

    ok !$Type->check('foo'), 'string is invalid';
};

subtest 'When a type constraint is given for the parameters' => sub {
    my $Foo = Type::Simple::Constraint->new(
        name => 'Foo',
        constraint => sub { $_ eq 'foo' },
    );

    my $Type = Type::Simple::Constraint::Structure::ArrayRef->new(
        parameters => [$Foo],
    );

    ok $Type->check([]), 'empty arrayref is valid';
    ok $Type->check(['foo']), 'arrayref with one "foo" is valid';
    ok $Type->check(['foo', 'foo']), 'arrayref with two "foo" is valid';

    ok !$Type->check(['bar']), 'arrayref with one "bar" is invalid';
    ok !$Type->check(['foo', 'bar']), 'arrayref with "foo" and "bar" is invalid';
};

subtest 'get_message' => sub {
    my $Foo = Type::Simple::Constraint->new(
        name => 'Foo',
        constraint => sub { $_ eq 'foo' },
    );

    my $Type = Type::Simple::Constraint::Structure::ArrayRef->new(
        parameters => [$Foo],
    );

    is $Type->get_message('foo'), '"foo" did not pass type "ArrayRef[Foo]"', 'error message';
    is $Type->get_message(['foo', 'bar']), 'Element [1]: "bar" did not pass type "Foo" within type "ArrayRef[Foo]"', 'error message';
    is $Type->get_message(['foo']), '', 'no error message';
};

done_testing;
