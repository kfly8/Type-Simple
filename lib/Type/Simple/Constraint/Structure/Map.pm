package Type::Simple::Constraint::Structure::Map;
use strict;
use warnings;

use parent qw(Type::Simple::Constraint::Structure);

use Carp ();
use List::Util ();
use Type::Simple::Util ();

sub BUILDARGS {
    my ($class, %args) = @_;

    $args{name} = 'Map';

    my $args = $class->SUPER::BUILDARGS(%args);

    unless (@{$args->{parameters}} == 2) {
        Carp::croak 'The `parameters` array must be key and value.';
    }

    unless (List::Util::all { Type::Simple::Util::is_type($_) } @{$args->{parameters}}) {
        Carp::croak 'Map parameters must be a type constraint';
    }

    $args->{key} = $args->{parameters}->[0];
    $args->{value} = $args->{parameters}->[1];

    return $args;
}

sub build_constraint {
    my $self = shift;

    return sub {
        my $value = $_[0];

        return unless ref $value && ref $value eq 'HASH';

        for my $key (keys %$value) {
            return unless $self->key->check($key);
            return unless $self->value->check($value->{$key});
        }

        return !!1;
    }
}

sub key { $_[0]->{key} }
sub value { $_[0]->{value} }

1;
