#!/usr/bin/env perl
use inc::Module::Install;

# Define metadata
name           'Game';
all_from       'lib/Game.pm';

# Specific dependencies
requires 'Moose'  => '2.2201';
requires 'Getopt::Long' => '2.5';

test_requires  'Test::More'  => '0.42';

auto_install;

WriteAll;