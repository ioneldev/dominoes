use strict;
use warnings;

use Test::More;

BEGIN { 
    use_ok 'Game::Board';
    use_ok 'Game::Player';
}

my $board = Game::Board->new();

ok ( $board->pack_is_empty == 0, "The pack is initialized" );
ok ( scalar( @{ $board->pack_of_cards} ) == 28, "The board has 28 cards");

ok ( ! $board->has_head_of_played_cards, "The left part is uninitialized" );
ok ( ! $board->has_tail_of_played_cards, "The right part is uninitialized" );

my $card = $board->pick_card();

my $left_part_of_card  = $card->left_number;
my $right_part_of_card = $card->right_number;

ok ( scalar( @{ $board->pack_of_cards} ) == 27, "The board has 27 cards");

ok ( $board->placed_card($card), "First card was placed");

_print_played_cards();

ok ( $board->has_head_of_played_cards, "The left part is initialized" );
ok ( $board->has_tail_of_played_cards, "The right part is initialized" );

ok ( $board->head_of_played_cards  == $card->left_number, "The left part is the left part of the card" );
ok ( $board->tail_of_played_cards == $card->right_number, "The right part is the right part of the card" );

my $card2 = Game::Card->new({
    left_number  => $left_part_of_card,
    right_number => $right_part_of_card,
});

ok ( $board->placed_card($card2), "The same card was placed");

_print_played_cards();

# Place the same card. The card should flip
ok ( $board->head_of_played_cards  == $right_part_of_card, "The left part is the right part of the card" );
ok ( $board->tail_of_played_cards == $right_part_of_card, "The right part is the right part of the card" );

ok ( $card2->left_number == $right_part_of_card, "The left part flipped to the right part");
ok ( $card2->right_number == $left_part_of_card, "The right part flipped to the left part");

# Place the same card again. The card flips again
my $card3 = Game::Card->new({
    left_number  => $card2->left_number,
    right_number => $card2->right_number,
}); 

ok ( $board->placed_card($card3), "The same card was placed again");

_print_played_cards();

ok ( $board->head_of_played_cards  == $left_part_of_card, "The left part is the right part of the card" );
ok ( $board->tail_of_played_cards == $right_part_of_card, "The right part is the right part of the card" );

ok ( $card3->left_number == $left_part_of_card, "The left part not flipped to the right part");
ok ( $card3->right_number == $right_part_of_card, "The right part not flipped to the left part");

sub _print_played_cards {
    foreach my $card ( @{ $board->played_cards } ) {
        $card->print()
    }
}

done_testing();