#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Plack::Builder;

use Dancer2::Debugger;
my $debugger = Dancer2::Debugger->new;

use Edge::HiringProject;
my $app = Edge::HiringProject->to_app;

builder {
    enable 'Debug', panels => [ qw(DBITrace) ];
    enable 'Debug::DBIProfile', profile => 2;
    $debugger->mount;
    mount '/' => builder {
        $debugger->enable;
        $app;
    }
}


