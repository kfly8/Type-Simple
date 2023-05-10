package Type::Simple;
use strict;
use warnings;

our $VERSION = "0.01";

use Exporter qw(import);

our @EXPORT_OK = qw(
    type is_type

    Int Any Undef
    ArrayRef Tuple HashRef Dict Map
);

use Type::Simple::Util qw(type is_type);
use Type::Simple::Types::Primitives qw(Int Any Undef);
use Type::Simple::Types::Structures qw(ArrayRef Tuple HashRef Dict Map);

1;
__END__

=encoding utf-8

=head1 NAME

Type::Simple - It's new $module

=head1 SYNOPSIS

    use Type::Simple type => qw(Int Str Dict);

    type ID => Int;

    type User => Dict[
        id => ID,
        name => Str,
    ];

    ok User->check({ id => 1, name => "John" });
    ok !User->check({ id => 1, name => "John", extra => 'extra' });

    type Add => Fn [Int, Int] => Int;

    type Hoge<$S, $T> => Dict[
        s => $S,
        t => $T,
    ];


=head1 DESCRIPTION

Type::Simple is ...

=head1 LICENSE

Copyright (C) kobaken.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kobaken E<lt>kentafly88@gmail.comE<gt>

=cut

