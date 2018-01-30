use utf8;
package Edge::Schema::Result::FormSubmission;

=head1 NAME

Edge::Schema::Result::FormSubmission

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<form_submission>

=cut

__PACKAGE__->table("form_submission");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 form_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 data

  data_type: 'json'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "form_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
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

=head2 form

Type: belongs_to

Related object: L<Edge::Schema::Result::Form>

=cut

__PACKAGE__->belongs_to(
  "form",
  "Edge::Schema::Result::Form",
  { id => "form_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
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
