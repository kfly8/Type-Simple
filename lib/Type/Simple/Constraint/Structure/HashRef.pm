package Type::Simple::Constraint::Structure::HashRef;
use strict;
use warnings;

use parent qw(Type::Simple::Constraint::Structure);

use Carp ();
use List::Util ();
use Type::Simple::Util ();

sub BUILDARGS {
    my ($class, %args) = @_;

    $args{name} = 'HashRef';

    my $args = $class->SUPER::BUILDARGS(%args);

    if (@{$args->{parameters}} > 1) {
        Carp::croak 'HashRef parameters must be one type or empty parameters';
    }

    if (my $type = $args->{parameters}->[0]) {
        unless (Type::Simple::Util::is_type($type)) {
            Carp::croak 'HashRef parameters must be a type constraint';
        }
    }

    return $args;
}

sub build_constraint {
    my $self = shift;

    return sub {
        my $value = $_[0];

        if (my $type = $self->parameters->[0]) {
            return ref $value && ref $value eq 'HASH' && List::Util::all { $type->check($_) } values %$value;
        }
        else {
            return ref $value && ref $value eq 'HASH';
        }
    }
}

1;
