use strict;
use warnings;

use Test::More;

BEGIN { 
    use_ok 'Game::Card';
}

local $@;
undef $@;

my $card;

eval {
    $card = Game::Card->new();
    1;
};

ok ( ! $@, "Card was successfully created");
ok ( ! $card->has_total_number, "Card doesn't have total number");
ok ( $card->total_number >= 0, "Card just computed the total number");
ok ( $card->has_total_number, "Card has total number");
ok ( $card->has_left_number, "Card has a left number");
ok ( $card->has_right_number, "Card has a right number");

undef $@;

eval {
    $card = Game::Card->new({
        left_number => 7,
        right_number => 1});
    1;
};

ok ( defined $@, "Died in constructor with error: $@");

undef $@;

eval {
    $card = Game::Card->new({
        left_number => 3,
        right_number => 9});
    1;
};

ok ( defined $@, "Died in constructor with error: $@");

undef $@;

eval {
    $card = Game::Card->new({
        left_number => 3,
        right_number => 1});
    1;
};

ok ( ! $@, "Card was successfully created");
ok ( ! $card->has_total_number, "Card doesn't have total number");
ok ( $card->total_number >= 0, "Card just computed the total number");
ok ( $card->has_total_number, "Card has total number");
ok ( $card->has_left_number, "Card has a left number");
ok ( $card->has_right_number, "Card has a right number");
ok ( $card->left_number == 3, "Card has left number 3");
ok ( $card->right_number == 1, "Card has right number 1");
ok ( $card->total_number == 4, "Card has total number 4");

undef $@;

eval {
    $card = Game::Card->new({
        left_number => 3,
    });
    1;
};


ok ( defined $@, "Died in constructor with error: $@");

undef $@;

eval {
    $card = Game::Card->new({
        right_number => 3,
    });
    1;
};


ok ( defined $@, "Died in constructor with error: $@");

undef $@;

eval {
    $card = Game::Card->new({});
    1;
};


ok ( defined $@, "Died in constructor with error: $@");

done_testing();