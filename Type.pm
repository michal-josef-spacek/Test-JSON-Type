package Test::JSON::Type;

use base qw(Test::Builder::Module);
use strict;
use warnings;

use Cpanel::JSON::XS;
use Cpanel::JSON::XS::Type;
use Error::Pure qw(err);
use Readonly;
use Test::Differences qw(eq_or_diff);

Readonly::Array our @EXPORT => qw(is_json_type);

our $VERSION = 0.01;

sub is_json_type {
	my ($json, $json_expected, $test_name) = @_;

	if (! defined $json) {
		err 'JSON string to compare is required.';
	}
	if (! defined $json_expected) {
		err 'Expected JSON string to compare is required.';
	}

	my $json_obj = Cpanel::JSON::XS->new;

	my $type_hr;
	$json_obj->decode($json, $type_hr);
	_readable_types($type_hr);
	my $type_expected_hr;
	$json_obj->decode($json_expected, $type_expected_hr);
	_readable_types($type_expected_hr);

	local $Test::Builder::Level = $Test::Builder::Level + 1;
	return eq_or_diff($type_hr, $type_expected_hr, $test_name);
}

sub _change_type {
	my $value_sr = shift;

	if (${$value_sr} == JSON_TYPE_BOOL) {
		${$value_sr} = 'JSON_TYPE_BOOL';
	} elsif (${$value_sr} == JSON_TYPE_INT) {
		${$value_sr} = 'JSON_TYPE_INT';
	} elsif (${$value_sr} == JSON_TYPE_FLOAT) {
		${$value_sr} = 'JSON_TYPE_FLOAT';
	} elsif (${$value_sr} == JSON_TYPE_STRING) {
		${$value_sr} = 'JSON_TYPE_STRING';
	} elsif (${$value_sr} == JSON_TYPE_NULL) {
		${$value_sr} = 'JSON_TYPE_NULL';
	} else {
		err "Unsupported value '${$value_sr}'.";
	}

	return;
}

sub _readable_types {
	my $type_r = shift;

	if (ref $type_r eq 'HASH') {
		foreach my $sub_key (keys %{$type_r}) {
			if (ref $type_r->{$sub_key}) {
				_readable_types($type_r->{$sub_key});
			} else {
				_readable_types(\$type_r->{$sub_key});
			}
		}
	} elsif (ref $type_r eq 'ARRAY') {
		foreach my $sub_type (@{$type_r}) {
			if (ref $sub_type) {
				_readable_types($sub_type);
			} else {
				_readable_types(\$sub_type);
			}
		}
	} elsif (ref $type_r eq 'SCALAR') {
		_change_type($type_r);
	} else {
		err "Unsupported value '$type_r'.";
	}

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Test::JSON::Type - Test JSON data with types.

=head1 SYNOPSIS

 use Test::JSON::Type;

 is_json_type($json, $json_expected, $test_name);

=head1 SUBROUTINES

=head2 C<is_json_type>

 is_json_type($json, $json_expected, $test_name);

TODO

=head1 ERRORS

 is_json_type():
         JSON string to compare is required.
         Expected JSON string to compare is required.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Test::JSON::Type;
 use Test::More 'tests' => 2;

 my $json_blank1 = '{}';
 my $json_blank2 = '{}';
 is_json_type($json_blank1, $json_blank2, 'Blank JSON strings.');

 my $json_struct1 = <<'END';
 {
   "bool": true,
   "float": 0.23,
   "int": 1,
   "null": null,
   "string": "bar"
 }
 END
 my $json_struct2 = <<'END';
 {
   "bool": false,
   "float": 1.23,
   "int": 2,
   "null": null,
   "string": "foo"
 }
 END
 is_json_type($json_struct1, $json_struct2, 'Structured JSON strings.');

 # Output:
 # 1..2
 # ok 1 - Blank JSON strings.
 # ok 2 - Structured JSON strings.

=head1 EXAMPLE2

 use strict;
 use warnings;

 use Test::JSON::Type;
 use Test::More 'tests' => 1;

 my $json_struct_err1 = <<'END';
 {
   "int": 1,
   "string": "1"
 }
 END
 my $json_struct_err2 = <<'END';
 {
   "int": 1,
   "string": 1
 }
 END
 is_json_type($json_struct_err1, $json_struct_err2, 'Structured JSON strings with error.');

 # Output:
 # TODO

=head1 EXAMPLE3

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

=head1 DEPENDENCIES

L<Cpanel::JSON::XS>,
L<Cpanel::JSON::XS::Type>,
L<Error::Pure>,
L<Readonly>,
L<Test::Builder::Module>,
L<Test::Differences>.

=head1 SEE ALSO

=over

=item L<Test::JSON>

Test JSON data

=item L<Test::JSON::More>

JSON Test Utility

=back

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Test-JSON-Type>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© Michal Josef Špaček 2021

BSD 2-Clause License

=head1 VERSION

0.01

=cut
