package Type::Simple::Constraint::Structure::ArrayRef;
use strict;
use warnings;

use parent qw(Type::Simple::Constraint::Structure);

use Carp ();
use List::Util ();
use Type::Simple::Util ();

sub BUILDARGS {
    my ($class, %args) = @_;

    $args{name} = 'ArrayRef';

    my $args = $class->SUPER::BUILDARGS(%args);

    if (@{$args->{parameters}} > 1) {
        Carp::croak 'ArrayRef parameters must be one type or empty parameters';
    }

    if (my $type = $args->{parameters}->[0]) {
        unless (Type::Simple::Util::is_type($type)) {
            Carp::croak 'ArrayRef parameters must be a type constraint';
        }
    }

    return $args;
}

sub build_constraint {
    my $self = shift;

    return sub {
        my $value = $_[0];

        if (my $type = $self->parameters->[0]) {
            return ref $value && ref $value eq 'ARRAY' && List::Util::all { $type->check($_) } @$value;
        }
        else {
            return ref $value && ref $value eq 'ARRAY';
        }
    }
}

sub get_message {
    my ($self, $value) = @_;

    unless (ref $value && ref $value eq 'ARRAY') {
        return $self->SUPER::get_message($value);
    }

    if (my $type = $self->parameters->[0]) {
        for my $i (0 .. $#$value) {
            unless ($type->check($value->[$i])) {
                my $message = sprintf('Element [%d]: %s within type %s', $i, $type->get_message($value->[$i]), Type::Simple::Util::dd($self->display_name));
                return Type::Simple::Util::normalize_message($message);
            }
        }
    }
}

1;
