package Edge::Order;

use Moose;

## Product variable
has 'product' => (
  is => 'ro', # read only
  isa => 'Str', # String
  required => 1, # Required
);

## Price Variable [Number Only]
has 'price' => (
  is => 'ro',
  isa => 'Int',
  required => 1,
);

# Quantity variable
has 'quantity' => (
  is => 'ro',
  isa => 'Int',
  required => 1,
);

# Total variable
has 'total' => (
  is => 'ro',
  isa => 'Int',
  default => sub {
    my $self = shift;
    return $self->quantity * $self->price;
  },
);

no Moose;
__PACKAGE__->meta->make_immutable;
