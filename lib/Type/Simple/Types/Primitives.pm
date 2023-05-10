package Type::Simple::Types::Primitives;
use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(Int Any Undef);

use Type::Simple::Constraint::Primitive;

use constant Int => Type::Simple::Constraint::Primitive->new(
    name => 'Int',
    constraint => sub { defined($_) && $_ =~ /^[0-9]+$/ },
);

use constant Any => Type::Simple::Constraint::Primitive->new(
    name => 'Any',
    constraint => sub { !!1 },
);

use constant Undef => Type::Simple::Constraint::Primitive->new(
    name => 'Undef',
    constraint => sub { !defined $_ },
);

1;
