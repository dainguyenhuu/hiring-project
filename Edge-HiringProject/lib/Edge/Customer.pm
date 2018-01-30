package Edge::Customer;

use Moose;

has 'schema' => (
  is => 'ro',
  isa => 'Edge::Schema',
  required => 1,
);

has 'id' => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);

has 'profile' => (
  is => 'ro',
  isa => 'HashRef',
  lazy => 1,
  default => sub {
    my $self = shift;
    my $profile = $self->schema->resultset('FormSubmission')->search(
                    {
                      'data' => \["->>'id' = ?", $self->id],
                    },
                    {
                      'order_by' => { -desc => 'id' },
                    },
                  )->first;
    if ($profile) {
      return $profile->data;
    }
    else {
      return {
        fname => '--not set--',
        lname => '--not set--',
      };
    }
  },
);


no Moose;
__PACKAGE__->meta->make_immutable;
