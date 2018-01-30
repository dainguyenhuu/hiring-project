use utf8;
package Edge::Schema::Result::Form;

=head1 NAME

Edge::Schema::Result::Form

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<form>

=cut

__PACKAGE__->table("form");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 data

  data_type: 'json'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "data",
  { data_type => "json", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 form_submissions

Type: has_many

Related object: L<Edge::Schema::Result::FormSubmission>

=cut

__PACKAGE__->has_many(
  "form_submissions",
  "Edge::Schema::Result::FormSubmission",
  { "foreign.form_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


use JSON::XS;
__PACKAGE__->inflate_column( data => {
    inflate => sub { decode_json( +shift ) },
    deflate => sub {
        # Takes data structure or plain JSON string.
        my $json = shift;
        ref $json ? encode_json($json) : $json;
    },
});

1;
