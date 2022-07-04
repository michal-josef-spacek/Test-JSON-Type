use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::JSON::Type;
use Test::More 'tests' => 12;
use Test::NoWarnings;

# Test.
my $input1 = '{}';
my $input2 = '{}';
is_json_type($input1, $input2, 'Two same objects.');

# Test.
$input1 =<<'END';
{
	"int": 1
}
END
$input2 =<<'END';
{
	"int": 2
}
END
is_json_type($input1, $input2, 'Objects with integer.');

# Test.
$input1 =<<'END';
{
	"string": "1"
}
END
$input2 =<<'END';
{
	"string": "foo"
}
END
is_json_type($input1, $input2, 'Objects with string.');

# Test.
$input1 =<<'END';
{
	"bool": true
}
END
$input2 =<<'END';
{
	"bool": false
}
END
is_json_type($input1, $input2, 'Objects with bool.');

# Test.
$input1 =<<'END';
{
	"float": 5.6789
}
END
$input2 =<<'END';
{
	"float": 1.2345
}
END
is_json_type($input1, $input2, 'Objects with float.');

# Test.
$input1 =<<'END';
{
	"null": null
}
END
$input2 =<<'END';
{
	"null": null
}
END
is_json_type($input1, $input2, 'Objects with null.');

# Test.
$input1 =<<'END';
{
	"array": []
}
END
$input2 =<<'END';
{
	"array": []
}
END
is_json_type($input1, $input2, 'Objects with blank array.');

# Test.
$input1 = undef;
$input2 =<<'END';
{
	"int": 1
}
END
eval {
	is_json_type($input1, $input2);
};
is($EVAL_ERROR, "JSON string to compare is required.\n",
	"JSON string to compare is required.");
clean();

# Test.
$input1 =<<'END';
{
	"int": 1
}
END
$input2 = undef;
eval {
	is_json_type($input1, $input2);
};
is($EVAL_ERROR, "Expected JSON string to compare is required.\n",
	"Expected JSON string to compare is required.");
clean();

# Test.
$input1 = '';
$input2 =<<'END';
{
	"int": 1
}
END
eval {
	is_json_type($input1, $input2);
};
is($EVAL_ERROR, "JSON string isn't valid.\n",
	"JSON string isn't valid.");
clean();

# Test.
$input1 =<<'END';
{
	"int": 1
}
END
$input2 = '';
eval {
	is_json_type($input1, $input2);
};
is($EVAL_ERROR, "Expected JSON string isn't valid.\n",
	"Expected JSON string isn't valid.");
clean();
