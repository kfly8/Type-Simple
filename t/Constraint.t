use strict;
use warnings;

use Test::More;

use Type::Simple::Constraint;

subtest 'check' => sub {
    my $type = Type::Simple::Constraint->new(
        name => 'Foo',
        constraint => sub { $_ eq 'foo' },
    );

    ok $type->check('foo'), 'foo is Foo';
    ok !$type->check('bar'), 'bar is not Foo';
};

subtest 'get_message' => sub {
    my $type = Type::Simple::Constraint->new(
        name => 'Foo',
        constraint => sub { $_ eq 'foo' },
    );

    is $type->get_message('bar'), '"bar" did not pass type "Foo"', 'error message';
    is $type->get_message('foo'), '"foo" did not pass type "Foo"', 'error message even if it passes';
    is $type->get_message({ foo => 'hello' }), '{"foo":"hello"} did not pass type "Foo"';

    my $foo = bless { bbb => 'helloaaaaaaaaaaaaaaaaaaaaaa', aaa => bless [], 'Baz' }, 'Foo::Bar';
    is $type->get_message($foo), 'Foo::Bar {"aaa":"Baz []","bbb":"helloaaaaaaaaaa...} did not pass type "Foo"';
};

subtest 'union operator' => sub {
    my $Foo = Type::Simple::Constraint->new(
        name => 'Foo',
        constraint => sub { $_ eq 'foo' }
    );

    my $Bar = Type::Simple::Constraint->new(
        name => 'Bar',
        constraint => sub { $_ eq 'bar' }
    );

    my $Union = $Foo | $Bar;
    isa_ok $Union, 'Type::Simple::Constraint::Operator::Union';
    is $Union->display_name, 'Foo | Bar';
};

done_testing;
