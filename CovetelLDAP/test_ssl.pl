#!/usr/bin/env perl
use strict;
use warnings;
use Covetel::LDAP;

my $filter = shift @ARGV;

my $ldap = Covetel::LDAP->new({config_file => 'covetel.yml'});

my $resp = $ldap->search({filter => '('.$filter.')'});

foreach ($resp->entries()){
	print $_->dn(), "\n";
}
