#!/usr/bin/env perl
use strict;
use warnings;
use Covetel::LDAP;
use Covetel::LDAP::Person;

my $ldap = Covetel::LDAP->new;

my @persons = $ldap->person();

use Data::Dumper;
foreach (@persons){
    print $_->firstname(), "\n";
}
