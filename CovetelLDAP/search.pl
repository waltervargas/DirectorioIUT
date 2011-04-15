#!/usr/bin/env perl
use strict;
use warnings;
use Covetel::LDAP;
use Covetel::LDAP::Person;

my $uid = $ARGV[0];

my $ldap = Covetel::LDAP->new;

my @persons = $ldap->person({uid => $uid});

use Data::Dumper;
foreach (@persons){
    print $_->dn(), "\n";
    print Dumper($_);

}
