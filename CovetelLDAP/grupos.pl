#!/usr/bin/env perl
use strict;
use warnings;
use Covetel::LDAP;
use Covetel::LDAP::Group;

my $ldap = Covetel::LDAP->new;

my @groups = $ldap->group();

use Data::Dumper;
foreach (@groups){
    print $_->nombre(), "\n";
}
