package Game;

use Moose;

use Game::Player;
use Game::Board;

has 'number_of_players' => (
    is  => 'ro',
    isa => 'Int',

    required => 1,
);

has 'players' => (
    is   => 'rw',
    isa  => 'ArrayRef',
    lazy => 1,
    builder => '_build_players',
);

has 'board' => (
    is  => 'rw',
    isa => 'Game::Board',
    lazy    => 1,
    builder => '_build_game_board'
);

has 'game_over' => (
    is  => 'rw',
    isa => 'Int',
    default => 0,
);

has 'verbose_mode' => (
    is => 'ro',
    isa => 'Int',
    default => 0,
);

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my $args  = shift;

    die "Invalid arguments. number_of_players must be defined" unless (defined $args && ref $args eq 'HASH');
    die "Invalid arguments. number_of_players must be defined" unless defined $args->{number_of_players};
    die "Invalid number passed to number_of_players. Must be between 2 and 4" unless ( $args->{number_of_players} >= 2 && $args->{number_of_players} <= 4 );

    return $class->$orig($args);
};

sub start_new {
    my $self = shift;

    printf( "Starting a new game of dominoes with %d players.\n", $self->number_of_players );
    
    # Drawing initial 7 cards for each player
    foreach my $player ( @{ $self->players } ) {
        $player->draw_cards( $self->board, 7 );

        $player->show_cards();
    }

    my $starting_player_index = $self->_decide_starting_player();

    my $winner = $self->start_game( $starting_player_index );

    printf( "The winner is %s\n", $winner->name);

    return $winner;
}

sub start_game {
    my ( $self, $player_index ) = @_;

    my $rounds_played = 0;

    while ( ! $self->game_over ) {
        print("Playing a round\n-------------------------------------------\n") if $self->verbose_mode;
        my $playing_player = $self->players->[$player_index];

        $playing_player->show_cards() if $self->verbose_mode;

        my $player_has_played = $playing_player->play_turn( $self->board );

        if ( $player_has_played ) {
            if ( $playing_player->finished_cards ) {
                # We have a winner
                return $playing_player;
            }

            # Pass the turn to the next player
            $player_index = ( $player_index + 1 ) % $self->number_of_players;
        }
        else {
            printf("No more cards to draw\n") if $self->verbose_mode;

            $self->game_over(1);

            # No player finished the cards. Decide the winner
            return $self->_decide_winner();
        }

        $rounds_played++;
        $self->_print_stats( $rounds_played ) if $self->verbose_mode;        
    }
}

sub _print_stats {
    my ( $self, $round_number ) = @_;

    printf( "Played round number %d\n", $round_number);
        
    printf( "Head of card is %d\n", $self->board->head_of_played_cards);
    printf( "Tail of card is %d\n", $self->board->tail_of_played_cards);

    print( "Cards on the board:\n");

    foreach my $card ( @{ $self->board->played_cards } ) {
        $card->print;
    }
}

sub _decide_starting_player {
    my $self = shift;

    my $max_double = 0;
    my $starting_index = 0;

    foreach my $player ( @{ $self->players } ) {
        if ( $player->max_double > $max_double ) {
            $max_double     = $player->max_double;
            $starting_index = $player->index;
        }
    }

    return $starting_index;
}

sub _decide_winner {
    my $self = shift;

    my $winner = $self->players->[0];

    my $min_total_dots = $winner->total_dots;

    foreach my $player ( @{ $self->players } ) {
        $player->show_cards();
        if ( $player->total_dots < $min_total_dots ) {
            $min_total_dots     = $player->total_dots;
            $winner = $player;
        }
    }    

    return $winner;
}

sub _build_game_board {
    return Game::Board->new();
}

sub _build_players {
    my $self = shift;

    my $players = [];

    my $initialized_players = 0;

    while ( $initialized_players < $self->number_of_players ) {
        print( "Creating a new player\n") if $self->verbose_mode;

        my $player = Game::Player->new({
            name  => "Player_$initialized_players",
            index => $initialized_players,
            verbose_mode => $self->verbose_mode,
        });

        push @$players, $player;

        $initialized_players++;
    }

    return $players;
}

1;