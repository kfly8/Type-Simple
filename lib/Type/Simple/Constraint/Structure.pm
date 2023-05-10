package Type::Simple::Constraint::Structure;
use strict;
use warnings;

use parent qw(Type::Simple::Constraint);

use Carp ();
use Type::Simple::Util ();

sub BUILDARGS {
    my ($class, %args) = @_;

    unless (ref $args{parameters} && ref $args{parameters} eq 'ARRAY') {
        Carp::croak 'Type::Simple::Structure requires `parameters` arrayref';
    }

    return $class->SUPER::BUILDARGS(%args);
}

sub parameters {
    my $self = shift;
    $self->{parameters};
}

sub display_name {
    my $self = shift;
    return sprintf('%s[%s]', $self->name, join(',', map { $_->display_name } @{$self->parameters}));
}

1;
