package Type::Simple::Constraint::Structure::Dict;
use strict;
use warnings;

use parent qw(Type::Simple::Constraint::Structure);

use Carp ();
use List::Util ();
use Type::Simple::Util ();

sub BUILDARGS {
    my ($class, %args) = @_;

    $args{name} = 'Dict';

    my $args = $class->SUPER::BUILDARGS(%args);

    unless (@{$args->{parameters}} % 2 == 0) {
        Carp::croak 'The `parameters` array must be key and value pair.';
    }

    for my $pair (List::Util::pairs @{ $args->{parameters} }) {
        my ($key, $type) = @$pair;

        unless (Type::Simple::Util::is_string($key)) {
            Carp::croak 'The key in `parameters` must be a string.';
        }

        unless (Type::Simple::Util::is_type($type)) {
            Carp::croak 'The value in `parameters` must be a type.';
        }
    }

    return $args;
}

sub build_constraint {
    my $self = shift;

    return sub {
        my $value = $_[0];

        return unless ref $value && ref $value eq 'HASH';

        my $count = scalar @{$self->pairs};
        return if $count < keys %$value; # value has extra keys

        for my $pair ($self->pairs) {
            my ($key, $type) = @$pair;

            if ($key->optional) {
                return if exists $value->{$key} && !$type->check($value->{$key});
            }
            else {
                return if !$type->check($value->{$key});
            }
        }
        return !!1;
    }
}

sub pairs {
    my $self = shift;
    $self->{pairs} ||= do {
        my @pairs = List::Util::pairmap { [Type::Simple::Constraint::Structure::Dict::Key->new(key => $a), $b] } @{$self->{parameters}};
        \@pairs
    };
    wantarray ? @{$self->{pairs}} : $self->{pairs};
}

package Type::Simple::Constraint::Structure::Dict::Key;

use parent qw(Type::Simple::Constraint);

use overload qw{""} => sub { $_[0]->key }, fallback => 1;

sub BUILDARGS {
    my ($class, %args) = @_;

    $args{name} = 'Dict::Key';

    my $args = $class->SUPER::BUILDARGS(%args);

    unless (defined $args->{key}) {
        Carp::croak 'The `key` parameter is required.';
    }

    if (ref $args->{key}) {
        Carp::croak 'The `key` parameter must be a string.';
    }

    # Optional key
    if ($args->{key} =~ /.\?\z/) {
        $args->{optional} = !!1;
        $args->{key} =~ s/\A(.+)\?\z/$1/;
    }
    else {
        $args->{optional} = !!0;
    }

    return $args;
}

sub build_constraint {
    my $self = shift;
    return sub { defined $_ && $_ eq $self->key }
}

sub key { $_[0]->{key} }
sub optional { $_[0]->{optional} }

1;
