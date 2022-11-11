package Game::Player;

use Moose;

has 'name' => (
    is  => 'ro',
    isa => 'Str',
    required => 1,
);

has 'index' => (
    is  => 'ro',
    isa => 'Int',
    required => 1,
);

has 'cards' => (
    is  => 'rw',
    isa => 'ArrayRef',
    default => sub { return [] },
);

has 'max_double' => (
    is  => 'rw',
    isa => 'Int',
    default => 0,
);

has 'total_dots' => (
    is => 'rw',
    isa => 'Int',
    default => 0,
);

has 'finished_cards' => (
    is => 'rw',
    isa => 'Int',
    default => 0
);

has 'verbose_mode' => (
    is => 'ro',
    isa => 'Int',
    default => 0,
);

sub play_turn {
    my ( $self, $board ) = @_;

    if ( $self->can_play_cards( $board ) ) {

        if ( scalar @{ $self->cards } == 0 ) {
            # player has played last card
            printf ("Player %s has played the last card\n", $self->name) if $self->verbose_mode;

            $self->finished_cards(1);
        }

        return 1;
    }

    return $self->draw_cards( $board, 1);
}

sub can_play_cards {
    my ( $self, $board ) = @_;

    printf ("Player %s is searching cards to play\n", $self->name) if $self->verbose_mode;

    for ( my $index = 0; $index < scalar @{ $self->cards }; $index++ ) {
        my $card = $self->cards->[$index];
        if ( $board->placed_card( $card ) ) {
            $self->_update_total_dots($card, 'subtract');
            
            splice @{ $self->cards }, $index, 1;

            printf ("Player %s found a card to play\n", $self->name) if $self->verbose_mode;
            $card->print() if $self->verbose_mode;

            return 1;
        }
    }

    return 0;
}

sub draw_cards {
    my ( $self, $board, $number_of_cards ) = @_;

    printf ("Player %s is drawing %d card/s\n", $self->name, $number_of_cards) if $self->verbose_mode;

    while ( $number_of_cards ) {
        return 0 if $board->pack_is_empty();

        my $card = $board->pick_card();

        push @{ $self->cards }, $card;

        $self->_update_total_dots($card, 'add');

        if ( $card->total_number > $self->max_double ) {
            $self->max_double( $card->total_number );
        }

        $number_of_cards--;
    }

    return 1;
}

sub show_cards {
    my $self = shift;

    return unless $self->verbose_mode;

    printf( "Showing cards of player with name: %s\n", $self->name );
    foreach my $card ( @{ $self->cards } ) {
        $card->print();
    }
    print( "-------------------------------------------\n");
}

sub _update_total_dots {
    my ( $self, $card, $action ) = @_;

    if ( $action eq 'add' ) {
        $self->total_dots( $self->total_dots + $card->total_number );
    }
    elsif ( $action eq 'subtract' ) {
        $self->total_dots( $self->total_dots - $card->total_number );
    }
}

1;