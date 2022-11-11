#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;

use lib('lib');
use Game;

my %params;

$params{verbose} = 0;

GetOptions (
        "number_of_players=i" => \$params{number_of_players},
        "verbose=i" => \$params{verbose},
        )
or die("Error in command line arguments\n");

start();

sub start {
    my $game = Game->new({
        number_of_players => $params{number_of_players},
        verbose_mode      => $params{verbose},
    });

    $game->start_new();
}