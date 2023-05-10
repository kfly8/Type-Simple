package Type::Simple::Constraint::Operator::Union;
use strict;
use warnings;

use parent qw(Type::Simple::Constraint::Operator);

use List::Util ();

sub BUILDARGS {
    my ($class, %args) = @_;

    $args{name} = 'Union';

    my $args = $class->SUPER::BUILDARGS(%args);

    unless (@{$args->{operands}} >= 2) {
        Carp::croak 'Union requires at least two operands';
    }

    unless (List::Util::all { Type::Simple::Util::is_type($_) } @{$args->{operands}}) {
        Carp::croak 'Union operands must be a type constraint';
    }

    return $args;
}

sub build_constraint {
    my $self = shift;

    return sub {
        my $value = $_[0];
        List::Util::any { $_->check($value) } @{$self->uniq_operands};
    }
}

sub display_name {
    my $self = shift;
    return join(' | ', map { $_->display_name } @{$self->uniq_operands});
}

1;
