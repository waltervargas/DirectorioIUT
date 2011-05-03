#!/usr/bin/env perl
use strict;
use warnings;
use Covetel::LDAP;
use Covetel::LDAP::Person;

my $filter = $ARGV[0];

my $ldap = Covetel::LDAP->new;

my $resp = $ldap->search(
    {
        base => 'ou=Mantenimiento,dc=iutai,dc=tec,dc=ve',
        filter => '(cn=Usuario Mantenimiento)', 
        attrs => ['uidNumber'] , 
    }
);

use Data::Dumper;
print Dumper $resp->entry(0)->get_value('uidNumber');
