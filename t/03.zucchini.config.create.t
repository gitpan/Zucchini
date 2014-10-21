#!/usr/bin/env perl
# vim: ts=8 sts=4 et sw=4 sr sta
use strict;
use warnings;

use Test::More tests => 3;

BEGIN {
    use_ok 'Zucchini::Config::Create';
}

can_ok(
    'Zucchini::Config::Create',
    qw(
        new
        write_default_config
    )
);

my $zucchini_cfg_create = Zucchini::Config::Create->new();
isa_ok($zucchini_cfg_create, q{Zucchini::Config::Create});

$zucchini_cfg_create->write_default_config(
    '/tmp/testcnf'
);
