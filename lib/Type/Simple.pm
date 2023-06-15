package Type::Simple;
use strict;
use warnings;

our $VERSION = "0.01";

use parent qw(Exporter);

use XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

our @EXPORT_OK = qw(
    is_type

    Int Any Undef
    ArrayRef Tuple HashRef Dict Map
);

use Carp qw(croak);
use Type::Simple::Util qw(is_type eval_type to_type to_type_coderef);
use Type::Simple::Types::Primitives qw(Int Any Undef);
use Type::Simple::Types::Structures qw(ArrayRef Tuple HashRef Dict Map);

sub import {
    my ($class) = @_;
    $class->export_to_level(1, @_);

    my $caller = caller;
    $class->import_into($caller);
}

sub import_into {
    my $class = shift;
    my $caller = shift;

    my @syms = qw( type );

    my %syms = map { $_ => 1 } @syms;
    delete $syms{$_} and $^H{"Type::Simple/$_"}++ for @syms;

    croak "Unrecognised import symbols @{[ keys %syms ]}" if keys %syms;
}

1;
__END__

=encoding utf-8

=head1 NAME

Type::Simple - Minimalist type constraints with Moo(se)

=head1 SYNOPSIS

    use Type::Simple type => qw(Int Str Dict);

    type ID => Int;

    type User => Dict[
        id   => ID,
        name => Str,
    ];

    my $user = { id => 1, name => "John" };
    ok User->check($user);

=head1 DESCRIPTION

Type::Simple is a type constraint module designed with five key objectives:

=over

=item B<Instant Start>

Simple, so you can start using it in no time.

=item B<Powerful Simplicity>

Its simplicity belies its power. By combining built-in types and utilities, you can create potent type constraints. For instance, it has enabled the porting of GraphQL-JS.

=item B<Broad Compatibility>

Types defined using Type::Simple are compatible and can coexist with modules like Moo, Moose, Mouse, Function::Parameters, and Type::Params.

=item B<Developer-Friendly>

Provides clear and helpful feedback during type errors to enhance the developer's experience.

=item B<Speed Matters>

Leveraging XS modules, the built-in types work faster, because faster is always better.

=back

=head1 LICENSE

Copyright (C) kobaken.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kobaken E<lt>kentafly88@gmail.comE<gt>

=cut

