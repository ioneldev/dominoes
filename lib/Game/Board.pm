package Game::Board;

use Moose;

use Game::Card;

has 'pack_of_cards' => (
    is   => 'rw',
    isa  => 'ArrayRef',

    builder => '_build_pack_of_cards',
);

has 'head_of_played_cards' => (
    is   => 'rw',
    isa  => 'Int',
    predicate => 'has_head_of_played_cards',
);

has 'tail_of_played_cards' => (
    is   => 'rw',
    isa  => 'Int',
    predicate => 'has_tail_of_played_cards',
);

has 'played_cards' => (
    is   => 'rw',
    isa  => 'ArrayRef',
    default => sub { return []; },
);

sub placed_card {
    my ( $self, $card ) = @_;

    if ( $self->has_head_of_played_cards && $self->has_tail_of_played_cards ) {

        if ( $self->head_of_played_cards == $card->right_number ) {
            $self->head_of_played_cards( $card->left_number );
            unshift @{ $self->played_cards }, $card;
        }
        elsif ( $self->head_of_played_cards == $card->left_number ) {
            $self->head_of_played_cards( $card->right_number );
            unshift @{ $self->played_cards }, $card->flip;
        }
        elsif ( $self->tail_of_played_cards == $card->right_number ) {
            $self->tail_of_played_cards( $card->left_number );
            push @{ $self->played_cards }, $card->flip;
        }
        elsif ( $self->tail_of_played_cards == $card->left_number ) {
            $self->tail_of_played_cards( $card->right_number );
            push @{ $self->played_cards }, $card;
        }
        else {
            return 0;
        }
    }
    else {
        # This is the first card. Place it on the board
        $self->head_of_played_cards ( $card->left_number );
        $self->tail_of_played_cards( $card->right_number );

        push @{ $self->played_cards }, $card;
    }

    return 1;
}

sub pick_card {
    my $self = shift;

    return shift @{ $self->pack_of_cards };
}

sub pack_is_empty {
    my $self = shift;

    return 0 if scalar @{ $self->pack_of_cards };
    return 1;
}

sub _build_pack_of_cards {
    my $self = shift;

    my $cards = [];

    for ( my $card_no = 0; $card_no < 28; $card_no ++ ) {
        my $card = Game::Card->new();

        push @$cards, $card;
    }

    return $cards;
}

1;