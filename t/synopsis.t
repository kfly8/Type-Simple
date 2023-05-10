use strict;
use warnings;
use Test::More;

TODO: {
    local $TODO = 'not yet';
    fail;
    #use Type::Simple type => qw(Int Str Dict);

    #type ID => Int;

    #type User => Dict[
    #    id => ID,
    #    name => Str,
    #];

    #ok ID->check(1);
    #ok ID->check("1");
    #ok !ID->check("a");

    #ok User->check({ id => 1, name => "John" });
    #ok !User->check({ id => 1, name => "John", extra => 'extra' });
};

done_testing;
