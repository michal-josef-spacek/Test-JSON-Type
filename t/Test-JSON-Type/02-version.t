use strict;
use warnings;

use Test::JSON::Type;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Test::JSON::Type::VERSION, 0.05, 'Version.');
