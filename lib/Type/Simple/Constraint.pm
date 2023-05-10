package Type::Simple::Constraint;
use strict;
use warnings;

use Carp ();
use Type::Simple::Util ();

use overload
    q{|} => sub {
        require Type::Simple::Constraint::Operator::Union;
        Type::Simple::Constraint::Operator::Union->new(operands => [$_[0], $_[1]]);
    },
    fallback => 1;

sub new {
    my $class = shift;
    my $args = $class->BUILDARGS(@_);
    my $self = bless $args => $class;
    return $self->BUILD($args);
}

sub BUILDARGS {
    my ($class, %args) = @_;

    unless ($args{name}) {
        Carp::croak sprintf('`name` is required at %s', $class);
    }

    if ($class->can('build_constraint') && $args{constraint}) {
        Carp::croak sprintf('No `constraint`, since %s has build_constraint method', $class);
    }

    unless (
        $class->can('build_constraint') || (ref $args{constraint} && ref $args{constraint} eq 'CODE')
    ) {
        Carp::croak sprintf('`constraint` or `build_constraint` method are required at %s', $class);
    }

    return \%args;
}

sub BUILD {
    my ($self, $args) = @_;

    if ($self->can('build_constraint')) {
        $self->{constraint} = $self->build_constraint($args);
    }

    return $self;
}

sub name {
    my $self = shift;
    $self->{name};
}

sub display_name {
    my $self = shift;
    $self->name;
}

sub check {
    my $self = shift;
    local $_ = $_[0];
    $self->{constraint}->($_[0]);
}

sub get_message {
    my ($self, $value) = @_;
    return sprintf('%s did not pass type %s', Type::Simple::Util::dd( $value ), Type::Simple::Util::dd($self->display_name));
}

1;
