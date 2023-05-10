package Type::Simple::Util;
use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(type is_type);

use Scalar::Util qw(blessed);

sub type { die 'Not implemented yet' }

sub is_type {
    my ($type) = @_;
    blessed($type) && $type->can('check') && $type->can('get_message');
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
