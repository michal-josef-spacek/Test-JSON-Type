package Test::JSON::Type;

use base qw(Test::Builder::Module);
use strict;
use warnings;

use Cpanel::JSON::XS;
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

	my $type;
	$json_obj->decode($json, $type);
	my $type_expected;
	$json_obj->decode($json_expected, $type_expected);

	local $Test::Builder::Level = $Test::Builder::Level + 1;
	return eq_or_diff($type, $type_expected, $test_name);
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
   "string": "1"
 }
 END
 my $json_struct2 = <<'END';
 {
   "bool": true,
   "float": 0.23,
   "int": 1,
   "null": null,
   "string": "1"
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
