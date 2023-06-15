package Type::Simple::Types::Structures;
use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(
    ArrayRef Tuple
    HashRef Dict Map
);

sub ArrayRef(;$) {
    require Type::Simple::Constraint::Structure::ArrayRef;
    Type::Simple::Constraint::Structure::ArrayRef->new( parameters => $_[0] ? $_[0] : [] );
}

sub Tuple(;$) {
    require Type::Simple::Constraint::Structure::Tuple;
    Type::Simple::Constraint::Structure::Tuple->new( parameters => $_[0] );
}

sub HashRef(;$) {
    require Type::Simple::Constraint::Structure::HashRef;
    Type::Simple::Constraint::Structure::HashRef->new( parameters => $_[0] ? $_[0] : [] );
}

sub Dict(;$) {
    require Type::Simple::Constraint::Structure::Dict;
    Type::Simple::Constraint::Structure::Dict->new( parameters => $_[0] );
}

sub Map(;$) {
    require Type::Simple::Constraint::Structure::Map;
    Type::Simple::Constraint::Structure::Map->new( parameters => $_[0] );
}

1;
