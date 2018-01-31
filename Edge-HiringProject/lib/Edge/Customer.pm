package Edge::Customer;

use Time::Piece;
use Edge::Order;
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

has 'profile_form' => (
  is => 'ro',
  isa => 'HashRef',
  lazy => 1,
  default => sub {
    my $self = shift;
    my $profile_form = $self->schema->resultset('FormSubmission')->search(
                    {
                      'data' => \["->>'id' = ?", $self->id],
                      'data' => \["->>'form' = 'profile'"],
                    },
                    {
                      'order_by' => { -desc => 'id' },
                    },
                  )->first;
    if ($profile_form && ref $profile_form->data) {
      return $profile_form->data;
    }
    else {
      return {};
    }
  },
);

has 'orders' => (
  is => 'ro',
  isa => 'ArrayRef[Edge::Order]',
  lazy => 1,
  default => sub {
    my $self = shift;
    my @orders;
    # Preparing the resultset from database
    my $order_rs = $self->schema->resultset('FormSubmission')->search(
        {
          'data' => \["->>'form' = 'order'"],
        },{
          # Newest order on top
          'order_by' => { -desc => 'id' },
        },
    );

    # Run the query and start getting data
    while (my $order = $order_rs->next) {
      # Convert from HASHRef to data
      my $awsome = $order->data;
      # Push the data into a new Order object
      my $order_fetch = Edge::Order->new(price => $awsome->{price}, product => $awsome->{product}, quantity => $awsome->{quantity});
      # Push the data into an array
      push @orders, $order_fetch;
    }
    # Return an array reference
    return \@orders;

  },
);

has 'name' => (
  is => 'ro',
  isa => 'Str',
  lazy => 1,
  default => sub {
    my $self = shift;
    my $name = ($self->profile_form->{fname} || '') . ' ' . ($self->profile_form->{lname} || '');
    if ($name eq ' ') { return '--not set--'; }
    return $name;
  },
);

has 'age' => (
  is => 'ro',
  isa => 'Int',
  lazy => 1,
  default => sub {
    my $self = shift;
    my $birthdate = $self->profile_form->{birthdate};
    # Get year out of birthdate
    my $year = Time::Piece->strptime($birthdate, "%Y-%m-%d")->year;
    # Condition to show nothing till user input their birthdate
    if ($self->name eq '--not set--') {
      return 0;
    } else {
      my $age = localtime->year - $year;
      return $age;
    }

  },
);

no Moose;
__PACKAGE__->meta->make_immutable;
