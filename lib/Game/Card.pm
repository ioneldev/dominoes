package Game::Card;

use Moose;

has 'left_number' => (
    is  => 'rw',
    isa => 'Int',
    required => 1,
    predicate => 'has_left_number',
);

has 'right_number' => (
    is  => 'rw',
    isa => 'Int',
    required => 1,
    predicate => 'has_right_number',
);

has 'total_number' => (
    is => 'ro',
    isa => 'Int',
    predicate => 'has_total_number',
    lazy => 1,
    builder => '_build_total_number',
);

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my $args  = shift;

    if ( defined $args && ref $args eq 'HASH' ) {
        die "Invalid arguments. left_number and right_number must be defined" unless ( defined $args->{left_number} && defined $args->{right_number} );

        die "Invalid number passed to left_number. Must be between 0 and 6"  unless ( $args->{left_number} >= 0 && $args->{left_number} <= 6 );
        die "Invalid number passed to right_number. Must be between 0 and 6" unless ( $args->{right_number} >= 0 && $args->{right_number} <= 6 );

        return $class->$orig($args);
    } 
 
    return $class->$orig({
        left_number    => int( rand(100) % 7 ),
        right_number => int( rand(100) % 7 )
    });
};

sub flip {
    my $self = shift;

    my $intermediary = $self->left_number;
    $self->left_number( $self->right_number );
    $self->right_number( $intermediary );

    return $self;
}

sub print {
    my $self = shift;

    print( "-----\n" );
    printf( "|%d|%d|\n", $self->left_number, $self->right_number );
    print( "-----\n" );
}

sub _build_total_number {
    my $self = shift;

    return $self->left_number + $self->right_number;
}

1;