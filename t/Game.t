use strict;
use warnings;

use Test::More;

BEGIN { 
    use_ok 'Game';
}

local $@;
undef $@;

eval {
    Game->new({
        number_of_players => 1
    });
};

ok ( $@, "Died in constructor with error: $@");

undef $@;

eval {
    Game->new({
        number_of_players => 5
    });
};

ok ( $@, "Died in constructor with error: $@");

undef $@;

eval {
    Game->new();
};

ok ( $@, "Died in constructor with error: $@");

undef $@;
my $game;

eval {
    $game = Game->new({
        number_of_players => 3,
        # verbose_mode => 1,
    });
};

ok ( ! $@, "Successfully created game");
ok ( $game->number_of_players == 3, "Game has 3 players");
ok ( $game->game_over == 0, "Game is not over");

$game->start_new();

done_testing;