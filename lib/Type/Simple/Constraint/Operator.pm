package Type::Simple::Constraint::Operator;
use strict;
use warnings;

use parent qw(Type::Simple::Constraint);

use Carp ();
use List::Util ();
use Scalar::Util ();
use Type::Simple::Util ();

sub BUILDARGS {
    my ($class, %args) = @_;

    unless (ref $args{operands} && ref $args{operands} eq 'ARRAY') {
        Carp::croak 'Type::Simple::Structure requires `operands` arrayref';
    }

    return $class->SUPER::BUILDARGS(%args);
}

sub operands {
    my $self = shift;
    $self->{operands};
}

sub uniq_operands {
    my $self = shift;
    $self->{uniq_operands} ||= do {
        my %seen;
        [ grep { !$seen{Scalar::Util::refaddr($_)}++ } @{$self->operands} ];
    };
}

1;
