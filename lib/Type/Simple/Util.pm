package Type::Simple::Util;
use strict;
use warnings;
use feature qw(current_sub);

use Exporter qw(import);

our @EXPORT_OK = qw(is_type);

use Scalar::Util qw(blessed);
use Carp qw(croak);

sub is_type {
    my ($type) = @_;
    blessed($type) && $type->can('check') && $type->can('get_message');
}

sub to_type_coderef {
    my ($code) = @_;
    unless (ref $code && ref $code eq 'CODE') {
        croak 'type() requires a code reference';
    }

    return sub {
        my @types = @_ ? map { to_type($_) } @{$_[0]} : ();
        to_type($code->(@types));
    };
}

sub to_type {
    my ($v) = @_;

    if (blessed($v) &&  $v->isa('Type::Simple::Constraint')) {
        return $v;
    }
    elsif (ref $v) {
        no warnings qw(once);
        require Type::Simple::Types::Structures;

        if (ref $v eq 'ARRAY' && @$v == 1) {
            return Type::Simple::Types::Structures::ArrayRef[__SUB__->($v->[0])];
        }
        elsif (ref $v eq 'ARRAY') {
            return Type::Simple::Types::Structures::Tuple[map { __SUB__->($_) } @$v];
        }
        elsif (ref $v eq 'HASH') {
            return Type::Simple::Types::Structures::Dict[map { $_ => __SUB__->($v->{$_}) } sort { $a cmp $b } keys %$v];
        }
        elsif (ref $v eq 'CODE') {
            return to_type($v->());
        }
        else {
            ...
        }
    }
    else {
        ...
    }
}

sub is_string {
    my ($value) = @_;
    defined $value && !ref $value;
}

sub dd {
    my ($value) = @_;

    if (!defined $value) {
        return 'Undef';
    }
    elsif (!ref $value) {
        require B;

        my $subname = (caller(1))[3];
        if ($subname eq __PACKAGE__ . '::dd') {
            return "$value";
        }
        else {
            return sprintf('%s', B::perlstring($value))
        }
    }
    elsif (blessed $value) {
        my $ref = Scalar::Util::reftype($value);
        my $v = $ref eq 'HASH' ? { map { $_ => dd($value->{$_}) } keys %$value }
              : $ref eq 'ARRAY' ? [ map { dd($_) } @$value ]
              : $ref eq 'SCALAR' ? $$value
              : undef;

        return sprintf('%s %s', ref $value, dd($v));
    }
    else {
        return _dump($value);
    }
}

our $MAX_DUMP_LENGTH = 50;
sub _dump {
    my ($value) = @_;

    no warnings qw(once);
    require Data::Dumper;
    local $Data::Dumper::Indent   = 0;
    local $Data::Dumper::Useqq    = 1;
    local $Data::Dumper::Terse    = 1;
    local $Data::Dumper::Sortkeys = 1;
    local $Data::Dumper::Maxdepth = 2;
    local $Data::Dumper::Pair     = ':';

    my $str = Data::Dumper::Dumper($value);
    if (length($str) > $MAX_DUMP_LENGTH) {
        $str = substr($str, 0, $MAX_DUMP_LENGTH - 12) . '...' . substr($str, -1, 1);
    }
    return $str;
}

sub normalize_message {
    my ($message) = @_;

    $message =~ s/: Element //g;
    $message =~ s/within type ".+" //g;

    return $message;
}

1;
