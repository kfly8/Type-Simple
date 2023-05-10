package Type::Simple::Constraint::Primitive;
use strict;
use warnings;

use parent qw(Type::Simple::Constraint);

sub get_message {
    my ($self, $value) = @_;
    return "" if $self->check($value);
    return $self->SUPER::get_message($value);
}

1;
