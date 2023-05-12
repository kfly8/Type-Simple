[![Actions Status](https://github.com/kfly8/Type-Simple/actions/workflows/test.yml/badge.svg)](https://github.com/kfly8/Type-Simple/actions) [![MetaCPAN Release](https://badge.fury.io/pl/Type-Simple.svg)](https://metacpan.org/release/Type-Simple)
# NAME

Type::Simple - Minimalist type constraints with Moo(se)

# SYNOPSIS

```perl
use Type::Simple type => qw(Int Str Dict);

type ID => Int;

type User => Dict[
    id   => ID,
    name => Str,
];

my $user = { id => 1, name => "John" };
ok User->check($user);
```

# DESCRIPTION

Type::Simple is a type constraint module designed with five key objectives:

- **Instant Start**

    Simple, so you can start using it in no time.

- **Powerful Simplicity**

    Its simplicity belies its power. By combining built-in types and utilities, you can create potent type constraints. For instance, it has enabled the porting of GraphQL-JS.

- **Broad Compatibility**

    Types defined using Type::Simple are compatible and can coexist with modules like Moo, Moose, Mouse, Function::Parameters, and Type::Params.

- **Developer-Friendly**

    Provides clear and helpful feedback during type errors to enhance the developer's experience.

- **Speed Matters**

    Leveraging XS modules, the built-in types work faster, because faster is always better.

# LICENSE

Copyright (C) kobaken.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

kobaken <kentafly88@gmail.com>
