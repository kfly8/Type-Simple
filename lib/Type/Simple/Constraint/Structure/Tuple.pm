package Type::Simple::Constraint::Structure::Tuple;
use strict;
use warnings;

use parent qw(Type::Simple::Constraint::Structure);

use Carp ();
use List::Util ();
use Type::Simple::Util ();

sub BUILDARGS {
    my ($class, %args) = @_;

    $args{name} = 'Tuple';

    my $args = $class->SUPER::BUILDARGS(%args);

    unless (List::Util::all { Type::Simple::Util::is_type($_) } @{$args->{parameters}}) {
        Carp::croak 'All elements in `parameters` must be valid types.';
    }

    return $args;
}

sub build_constraint {
    my $self = shift;

    return sub {
        my $value = $_[0];

        return unless ref $value && ref $value eq 'ARRAY';
        return unless @$value == @{$self->parameters};

        for my $i (0 .. $#{$self->parameters}) {
            return unless $self->parameters->[$i]->check($value->[$i]);
        }
        return !!1;
    }
}

sub get_message {
    my ($self, $value) = @_;

    unless (ref $value && ref $value eq 'ARRAY') {
        return $self->SUPER::get_message($value);
    }

    for my $i (0 .. $#{$self->parameters}) {
        my $type = $self->parameters->[$i];
        unless ($type->check($value->[$i])) {
            my $message = sprintf('Element [%d]: %s within type %s', $i, $type->get_message($value->[$i]), Type::Simple::Util::dd($self->display_name));
            return Type::Simple::Util::normalize_message($message);
        }
    }
}

1;
