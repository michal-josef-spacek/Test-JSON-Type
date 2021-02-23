#!/usr/bin/env perl

use strict;
use warnings;

use Test::JSON::Type;
use Test::More 'tests' => 1;

my $json_struct_err1 = <<'END';
{
  "int": 1,
  "array": ["1", 1]
}
END
my $json_struct_err2 = <<'END';
{
  "int": 1,
  "array": 1
}
END
is_json_type($json_struct_err1, $json_struct_err2, 'Structured JSON strings with error.');

# Output:
# TODO