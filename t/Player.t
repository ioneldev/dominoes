use strict;
use warnings;

use Test::More;

BEGIN { 
    use_ok 'Game::Player';
    use_ok 'Game::Board';
}

my $player = Game::Player->new({
    name  => "A",
    index => 0
});

ok( $player->name eq "A", "Player name initialized");
ok( $player->index == 0, "Player index is 0");

ok( scalar @{ $player->cards } == 0, "Player " . $player->name . " has no cards" );
ok( $player->max_double == 0, "Player " . $player->name . " has 0 max double");

my $board = Game::Board->new({
    pack_of_cards => [
        Game::Card->new({ left_number => 1, right_number => 2}),
        Game::Card->new({ left_number => 2, right_number => 4}),
        Game::Card->new({ left_number => 5, right_number => 1}),
        Game::Card->new({ left_number => 6, right_number => 5}),
    ]
});

ok( $player->draw_cards($board, 4), "Player " . $player->name . " drew 4 cards");
ok( $player->total_dots() == 26, "Player has 26 total dots");
ok( $board->pack_is_empty, "Boards pack is empty");
ok( $player->draw_cards($board, 1) == 0, "Player " . $player->name . " can't draw any more cards" );


$board = Game::Board->new({
    pack_of_cards => [
        Game::Card->new({ left_number => 1, right_number => 2}),
        Game::Card->new({ left_number => 2, right_number => 4}),
        Game::Card->new({ left_number => 5, right_number => 1}),
    ]
});

$player = Game::Player->new({
    name  => "B",
    index => 1
});

$player->draw_cards($board, 1);
ok ( $player->total_dots == 3, "Player has 3 total dots");
ok ( scalar @{ $board->pack_of_cards} == 2, "Player " . $player->name . " drew a card from the pack. 2 more cards in the pack");

ok ( $player->play_turn( $board ), "Player " . $player->name . " can play first turn" );
ok ( scalar @{ $board->played_cards} == 1, "Player " . $player->name . " placed a card on the board");
ok ( $player->total_dots == 0, "Player has 0 total dots");
# _print_played_cards();

ok ( $player->play_turn( $board ), "Player " . $player->name . " can play second turn, but must pick up card" );
ok ( scalar @{ $board->pack_of_cards} == 1, "Player " . $player->name . " drew a card from the pack. 1 more cards in the pack");
ok ( scalar @{ $board->played_cards } == 1, "Player " . $player->name . " didn't put a new card on the board");
ok ( $player->total_dots == 6, "Player has 6 total dots");
# _print_played_cards();


ok ( $player->play_turn( $board ), "Player " . $player->name . " can play third turn" );
ok ( scalar @{ $board->played_cards } == 2, "Player " . $player->name . " put a new card on the board");
ok ( $player->total_dots == 0, "Player has 0 total dots");

ok ( $player->play_turn( $board ), "Player " . $player->name . " can play forth turn, but must pick up card" );
ok ( scalar @{ $board->pack_of_cards} == 0, "Player " . $player->name . " drew a card from the pack. 0 more cards in the pack");
ok ( scalar @{ $board->played_cards } == 2, "Player " . $player->name . " didn't put a new card on the board");
ok ( $player->total_dots == 6, "Player has 6 total dots");

ok ( $player->play_turn( $board ) , "Player " . $player->name . " can play fifth turn" );
ok ( scalar @{ $board->played_cards } == 3, "Player " . $player->name . " put a new card on the board");

ok ( $player->play_turn( $board ) == 0, "Player " . $player->name . " can't play sixth turn" );

_print_played_cards();

sub _print_played_cards {
    foreach my $card ( @{ $board->played_cards } ) {
        $card->print()
    }
}

done_testing();